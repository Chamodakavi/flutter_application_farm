import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../../marketplace/domain/product.dart';
import '../domain/cart_line.dart';

/// The server-persisted cart, shared with the web app (spec §13.3).
class CartRepository {
  CartRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  String get _uid {
    final id = _db.auth.currentUser?.id;
    if (id == null) throw const AppException.auth('session_expired');
    return id;
  }

  /// The user's cart rows joined with their products.
  ///
  /// `cart.product_id` is `varchar` with no foreign key, so the join is done
  /// here: cart rows first, then the products with `id in (…)`. Lines whose
  /// product was deleted are dropped. Network first; the saved copy is used
  /// only when offline.
  Future<List<CartLine>> fetch() => guard(() {
    final uid = _uid;
    return _cache.fetch(
      box: HiveBoxes.cacheUser,
      key: 'cart_$uid',
      ttl: CacheTtl.user,
      forceRefresh: true,
      load: () async {
        final rows = await _db.from(Tables.cart).select().eq('user_id', uid).order('created_at');
        final ids = rows.map((r) => asIntOrNull(r['product_id'])).nonNulls.toSet().toList();
        final products = ids.isEmpty
            ? const <Map<String, dynamic>>[]
            : await _db.from(Tables.products).select().inFilter('id', ids);
        return {'cart': rows, 'products': products};
      },
      decode: _decode,
    );
  });

  /// Adds a line. [productId] is the product id as text (`'12'`).
  Future<void> insert({required String productId, required int qty}) => guard(() async {
    await _db.from(Tables.cart).insert({'user_id': _uid, 'product_id': productId, 'qty': qty});
  });

  Future<void> updateQty(int cartId, int qty) => guard(() async {
    await _db.from(Tables.cart).update({'qty': qty}).eq('id', cartId);
  });

  Future<void> delete(int cartId) => guard(() async {
    await _db.from(Tables.cart).delete().eq('id', cartId);
  });

  static List<CartLine> _decode(Object? json) {
    if (json is! Map) return const [];
    final products = {
      for (final row in asRows(json['products'])) asInt(row['id']): Product.fromJson(row),
    };
    return [
      for (final row in asRows(json['cart']))
        if (products[asIntOrNull(row['product_id'])] case final product?)
          CartLine.fromRow(row, product),
    ];
  }
}

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
