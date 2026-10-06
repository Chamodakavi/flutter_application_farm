import 'dart:async';
import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/l10n/locale_provider.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../../core/utils/app_status.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../marketplace/data/product_repository.dart';
import '../../../marketplace/presentation/controllers/products_controller.dart';
import '../../data/order_repository.dart';
import '../../domain/order.dart';
import '../../domain/order_item.dart';
import '../order_l10n.dart';
import 'cart_controller.dart';

/// The signed-in user's orders, newest first (spec §11.17). Empty while
/// signed out.
class OrdersController extends AsyncNotifier<List<Order>> {
  /// Orders this device just cancelled — their realtime echo is not news.
  final _cancelledHere = <int>{};

  @override
  Future<List<Order>> build() async {
    final uid = ref.watch(currentUserIdProvider);
    if (uid == null) return const [];
    return ref.read(orderRepositoryProvider).fetchOrders();
  }

  /// Reloads from the server, keeping the current list on screen meanwhile.
  Future<void> refresh() async {
    final orders = await ref.read(orderRepositoryProvider).fetchOrders();
    if (ref.mounted) state = AsyncData(orders);
  }

  /// Places a Cash-on-Delivery order from the server cart (spec §11.16).
  ///
  /// On success the cart, orders and stock figures are reloaded and
  /// `order_placed` is tracked with the item count and total only.
  Future<PlaceOrderResult> placeOrder(String phone) async {
    final itemCount = ref.read(cartControllerProvider).value?.length ?? 0;
    final estimate = ref.read(cartTotalsProvider).total;
    final result = await ref.read(orderRepositoryProvider).placeOrder(phone: phone);
    if (!ref.mounted) return result;

    switch (result) {
      case PlaceOrderSuccess():
        ref.read(analyticsProvider).track(AnalyticsEvents.orderPlaced, {
          'items': itemCount,
          'total': result.total ?? estimate,
        });
        ref.read(lastPlacedOrderProvider.notifier).set(result);
        await _stockChanged();
        if (!ref.mounted) return result;
        ref.invalidate(cartControllerProvider);
        ref.invalidateSelf();
      case PlaceOrderInsufficientStock():
        // The cart was built from older stock figures: reload both.
        await _stockChanged();
        if (!ref.mounted) return result;
        ref.invalidate(cartControllerProvider);
      case PlaceOrderEmptyCart():
        ref.invalidate(cartControllerProvider);
      case PlaceOrderUnknown():
        break;
    }
    return result;
  }

  /// Cancels a pending order through the `cancel_order` RPC.
  Future<CancelOrderResult> cancel(int orderId) async {
    _cancelledHere.add(orderId);
    final CancelOrderResult result;
    try {
      result = await ref.read(orderRepositoryProvider).cancelOrder(orderId);
    } catch (_) {
      _cancelledHere.remove(orderId);
      rethrow;
    }
    if (!ref.mounted) return result;

    if (result == CancelOrderResult.success) {
      final orders = state.value;
      if (orders != null) {
        state = AsyncData([
          for (final o in orders) o.id == orderId ? o.copyWith(status: 'Cancelled') : o,
        ]);
      }
      await _stockChanged();
    } else {
      _cancelledHere.remove(orderId);
    }
    // The server row is the truth (status wording, updated_at, admin note).
    if (ref.mounted) unawaited(refresh().catchError((_) {}));
    return result;
  }

  /// Merges a realtime `orders` row into the list (spec §17.1).
  ///
  /// Returns the new raw status when it changed because of someone else
  /// (the admin), or null when there is nothing to tell the farmer.
  String? applyUpdate(Map<String, dynamic> row, [Map<String, dynamic> oldRow = const {}]) {
    final id = asIntOrNull(row['id']);
    if (id == null) return null;

    final orders = state.value;
    final known = orders?.where((o) => o.id == id).firstOrNull;
    final newStatus = asStringOrNull(row['status']);
    final previous = asStringOrNull(oldRow['status']) ?? known?.status;

    Order? updated;
    if (known != null) {
      try {
        // Realtime rows have no embedded items: keep the ones already loaded.
        updated = Order.fromJson(row).copyWith(items: known.items);
      } catch (_) {}
    }
    if (orders != null && updated != null) {
      state = AsyncData([for (final o in orders) o.id == id ? updated : o]);
    } else {
      unawaited(refresh().catchError((_) {}));
    }

    final status = AppStatus.fromDb(newStatus);
    final cancelledHere = _cancelledHere.remove(id) && status == AppStatus.cancelled;
    // Without a known previous status, anything past "pending" is a change.
    final changed = previous == null
        ? status != AppStatus.pending
        : previous.trim().toLowerCase() != (newStatus ?? '').trim().toLowerCase();
    return changed && !cancelledHere ? newStatus : null;
  }

  Future<void> _stockChanged() async {
    await ref.read(productRepositoryProvider).clearCache();
    if (!ref.mounted) return;
    ref
      ..invalidate(inStockProductCountProvider)
      ..invalidate(productsControllerProvider)
      ..invalidate(productProvider);
  }
}

final ordersControllerProvider = AsyncNotifierProvider<OrdersController, List<Order>>(
  OrdersController.new,
);

/// The result of the last successful `place_order`, so the success screen can
/// show the server total before the orders list has reloaded.
class LastPlacedOrder extends Notifier<PlaceOrderSuccess?> {
  @override
  PlaceOrderSuccess? build() {
    ref.watch(currentUserIdProvider);
    return null;
  }

  void set(PlaceOrderSuccess result) => state = result;
}

final lastPlacedOrderProvider = NotifierProvider<LastPlacedOrder, PlaceOrderSuccess?>(
  LastPlacedOrder.new,
);

/// Watched by the app shell while signed in: subscribes to realtime `orders`
/// updates for the user, refreshes the list and shows a local notification
/// when a status changes (spec §17.1). Does nothing while signed out; the
/// channel is removed when the account changes or the shell goes away.
final ordersRealtimeProvider = Provider<void>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return;

  // Keep the list loaded: the previous status of an order is what tells a
  // status change apart from any other edit of the row.
  ref.listen(ordersControllerProvider, (_, _) {}, onError: (_, _) {});

  final stop = ref.read(orderRepositoryProvider).watchUpdates(uid, (row, oldRow) {
    if (!ref.mounted) return;
    final id = asIntOrNull(row['id']);
    final status = ref.read(ordersControllerProvider.notifier).applyUpdate(row, oldRow);
    if (id == null || status == null) return;

    // No BuildContext here: resolve the strings from the chosen language.
    final l10n = _l10nFor(ref.read(localeControllerProvider));
    final parsed = AppStatus.fromDb(status);
    unawaited(
      ref.read(localNotificationsProvider).show(
        channel: NotifyChannel.orders,
        title: l10n.orderNotifyTitle('$id', parsed.label(l10n, status)),
        body: l10n.orderStatusMessage(parsed),
        route: Routes.ordersWith(id),
      ),
    );
  });
  ref.onDispose(stop);
});

AppLocalizations _l10nFor(Locale locale) {
  try {
    return lookupAppLocalizations(locale);
  } catch (_) {
    return lookupAppLocalizations(const Locale('en'));
  }
}
