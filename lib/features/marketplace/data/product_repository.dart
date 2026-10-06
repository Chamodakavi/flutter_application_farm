import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/product.dart';

/// Reads the `products` table (spec §11.13). The app never writes products.
class ProductRepository {
  ProductRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  /// The first pages of each category are kept for offline use (spec §17.3).
  static const cachedPages = 2;

  /// One page of [AppConst.pageSize] products, newest first.
  ///
  /// [category] null means "All"; [query] is matched against the name with
  /// `ilike`. Search results and later pages always come from the network.
  Future<List<Product>> page({
    String? category,
    String query = '',
    required int page,
    bool forceRefresh = false,
  }) {
    final search = query.trim();

    Future<Object?> load() async {
      final from = page * AppConst.pageSize;
      var request = _db.from(Tables.products).select();
      if (category != null) request = request.eq('category', category);
      if (search.isNotEmpty) request = request.ilike('name', '%${_escapeLike(search)}%');
      return request.order('id', ascending: false).range(from, from + AppConst.pageSize - 1);
    }

    if (search.isNotEmpty || page >= cachedPages) {
      return guard(() async => _decodeList(await load()));
    }
    return _cache.fetch(
      box: HiveBoxes.cacheProducts,
      key: 'page_${category ?? '*'}_$page',
      ttl: CacheTtl.products,
      load: load,
      decode: _decodeList,
      forceRefresh: forceRefresh,
    );
  }

  /// Distinct `products.category` values, so categories added by an admin
  /// show up as filter chips without an app update.
  Future<List<String>> categories({bool forceRefresh = false}) => _cache.fetch(
    box: HiveBoxes.cacheProducts,
    key: 'categories',
    ttl: CacheTtl.products,
    load: () => _db.from(Tables.products).select('category'),
    decode: (json) {
      final names = <String>{
        for (final row in asRows(json))
          if (asString(row['category']).trim().isNotEmpty) asString(row['category']).trim(),
      };
      return names.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    },
    forceRefresh: forceRefresh,
  );

  /// One product by id — network first so the stock is current; the saved
  /// copy is used only when offline. Deep links land here (spec §9.3).
  Future<Product> byId(int id) => _cache.fetch(
    box: HiveBoxes.cacheProducts,
    key: 'product_$id',
    ttl: CacheTtl.products,
    load: () => _db.from(Tables.products).select().eq('id', id).maybeSingle(),
    decode: (json) {
      if (json is! Map) throw const AppException.notFound();
      return Product.fromJson(Map<String, dynamic>.from(json));
    },
    forceRefresh: true,
  );

  /// Number of products with stock > 0. `products.stock` is `varchar`, so the
  /// count is done on the device from a light two-column read.
  Future<int> inStockCount() => _cache.fetch(
    box: HiveBoxes.cacheProducts,
    key: 'in_stock_count',
    ttl: CacheTtl.products,
    load: () async {
      final rows = await _db.from(Tables.products).select('id,stock');
      return rows.where((row) => asInt(row['stock']) > 0).length;
    },
    decode: asInt,
    forceRefresh: true,
  );

  /// Drops every saved page — stock changes after an order is placed or
  /// cancelled.
  Future<void> clearCache() => _cache.clear(HiveBoxes.cacheProducts);

  static List<Product> _decodeList(Object? json) => asRows(json).map(Product.fromJson).toList();

  /// `%` and `_` typed by the user are literal characters, not wildcards.
  static String _escapeLike(String text) =>
      text.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');
}

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
