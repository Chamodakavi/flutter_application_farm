import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/order.dart';
import '../domain/order_item.dart';

/// Called with the new and the old `orders` row of a realtime UPDATE. The old
/// row only carries the primary key unless the table has full replica identity.
typedef OrderUpdateCallback =
    void Function(Map<String, dynamic> newRow, Map<String, dynamic> oldRow);

/// Orders are read directly and written only through the `place_order` and
/// `cancel_order` RPCs (spec §7.1, §7.2).
class OrderRepository {
  OrderRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  String get _uid {
    final id = _db.auth.currentUser?.id;
    if (id == null) throw const AppException.auth('session_expired');
    return id;
  }

  /// The user's orders with their items, newest first. Network first; the
  /// saved copy is used only when offline.
  Future<List<Order>> fetchOrders() => guard(() {
    final uid = _uid;
    return _cache.fetch(
      box: HiveBoxes.cacheUser,
      key: 'orders_$uid',
      ttl: CacheTtl.user,
      forceRefresh: true,
      load: () => _db
          .from(Tables.orders)
          .select('*, order_items(*)')
          .eq('user_id', uid)
          .order('created_at', ascending: false),
      decode: (json) => asRows(json).map(Order.fromJson).toList(),
    );
  });

  /// Turns the server cart into a Cash-on-Delivery order. The shipping fee is
  /// decided by the server, so `p_shipping` is not sent.
  Future<PlaceOrderResult> placeOrder({required String phone}) => guard(() async {
    final result = await _db.rpc(Rpc.placeOrder, params: {'p_phone': phone});
    return PlaceOrderResult.fromJson(_asMap(result));
  });

  Future<CancelOrderResult> cancelOrder(int orderId) => guard(() async {
    final result = await _db.rpc(Rpc.cancelOrder, params: {'p_order_id': orderId});
    return CancelOrderResult.fromJson(result is List && result.isNotEmpty ? result.first : result);
  });

  /// Subscribes to realtime UPDATEs of the user's orders (spec §17.1).
  /// Returns the function that removes the channel again.
  void Function() watchUpdates(String uid, OrderUpdateCallback onUpdate) {
    try {
      final channel = _db
          .channel('orders-$uid')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: Tables.orders,
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: uid,
            ),
            callback: (payload) => onUpdate(payload.newRecord, payload.oldRecord),
          )
          .subscribe();
      return () => unawaited(_db.removeChannel(channel));
    } catch (_) {
      // Realtime is a convenience; the list still refreshes on pull.
      return () {};
    }
  }

  /// RPCs return a JSON object; tolerate a one-row list around it.
  static Map<String, dynamic> _asMap(Object? value) {
    final object = value is List && value.isNotEmpty ? value.first : value;
    return object is Map ? Map<String, dynamic>.from(object) : const {};
  }
}

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
