import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/cart/data/order_repository.dart';
import 'package:farmfriend/features/cart/domain/order.dart';
import 'package:farmfriend/features/cart/domain/order_item.dart';
import 'package:farmfriend/features/cart/presentation/controllers/orders_controller.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cart_fakes.dart';

void main() {
  group('PlaceOrderResult.fromJson', () {
    test('success carries the order id, total and shipping', () {
      final result = PlaceOrderResult.fromJson({
        'status': 'success',
        'order_id': 8,
        'total': 650,
        'shipping': '350',
      });
      expect(result, isA<PlaceOrderSuccess>());
      final success = result as PlaceOrderSuccess;
      expect(success.orderId, 8);
      expect(success.total, 650);
      expect(success.shipping, 350);
    });

    test('success tolerates a numeric string id and missing totals', () {
      final result = PlaceOrderResult.fromJson({'status': 'success', 'order_id': '12'});
      expect((result as PlaceOrderSuccess).orderId, 12);
      expect(result.total, isNull);
      expect(result.shipping, isNull);
    });

    test('empty_cart', () {
      expect(PlaceOrderResult.fromJson({'status': 'empty_cart'}), isA<PlaceOrderEmptyCart>());
    });

    test('insufficient_stock names the product and what is left', () {
      final result = PlaceOrderResult.fromJson({
        'status': 'insufficient_stock',
        'product_id': 3,
        'product_name': 'Hoe',
        'available': '2',
      });
      expect(result, isA<PlaceOrderInsufficientStock>());
      final stock = result as PlaceOrderInsufficientStock;
      expect(stock.productId, '3');
      expect(stock.productName, 'Hoe');
      expect(stock.available, 2);
    });

    test('an unknown or missing status falls back to unknown', () {
      expect(PlaceOrderResult.fromJson({'status': 'on_hold'}), isA<PlaceOrderUnknown>());
      expect(PlaceOrderResult.fromJson(const {}), isA<PlaceOrderUnknown>());
    });
  });

  group('CancelOrderResult.fromJson', () {
    test('maps every status', () {
      expect(CancelOrderResult.fromJson({'status': 'success'}), CancelOrderResult.success);
      expect(CancelOrderResult.fromJson({'status': 'not_found'}), CancelOrderResult.notFound);
      expect(
        CancelOrderResult.fromJson({'status': 'not_cancellable'}),
        CancelOrderResult.notCancellable,
      );
    });

    test('accepts a bare string and falls back to unknown', () {
      expect(CancelOrderResult.fromJson('success'), CancelOrderResult.success);
      expect(CancelOrderResult.fromJson({'status': 'later'}), CancelOrderResult.unknown);
      expect(CancelOrderResult.fromJson(null), CancelOrderResult.unknown);
    });
  });

  group('OrdersController', () {
    late FakeOrderRepository repo;
    late FakeProductRepository products;

    ProviderContainer container0({String? uid = 'u1'}) {
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          currentUserIdProvider.overrideWithValue(uid),
          orderRepositoryProvider.overrideWithValue(repo),
          productRepositoryProvider.overrideWithValue(products),
        ],
      );
      addTearDown(container.dispose);
      container.listen(ordersControllerProvider, (_, _) {});
      return container;
    }

    Order orderIn(ProviderContainer c, int id) =>
        c.read(ordersControllerProvider).requireValue.firstWhere((o) => o.id == id);

    setUp(() {
      repo = FakeOrderRepository([order(8), order(7, status: 'Delivered')]);
      products = FakeProductRepository(const []);
    });

    test('is empty while signed out', () async {
      final container = container0(uid: null);
      expect(await container.read(ordersControllerProvider.future), isEmpty);
    });

    test('a realtime status change is merged, keeps the items and is reported', () async {
      final container = container0();
      await container.read(ordersControllerProvider.future);

      final changed = container.read(ordersControllerProvider.notifier).applyUpdate({
        'id': 8,
        'user_id': 'u1',
        'status': 'Approved',
        'admin_note': 'Ready on Friday',
        'total_amount': 650,
        'shipping_amount': 350,
      });

      expect(changed, 'Approved');
      final updated = orderIn(container, 8);
      expect(updated.status, 'Approved');
      expect(updated.adminNote, 'Ready on Friday');
      expect(updated.items, hasLength(1));
      expect(updated.canCancel, isFalse);
    });

    test('an update that leaves the status alone is not reported', () async {
      final container = container0();
      await container.read(ordersControllerProvider.future);

      final changed = container.read(ordersControllerProvider.notifier).applyUpdate({
        'id': 8,
        'status': 'pending',
        'admin_note': 'We will call you',
      });

      expect(changed, isNull);
      expect(orderIn(container, 8).adminNote, 'We will call you');
    });

    test('cancel marks the order cancelled and its realtime echo is not news', () async {
      final container = container0();
      await container.read(ordersControllerProvider.future);
      final controller = container.read(ordersControllerProvider.notifier);

      expect(await controller.cancel(8), CancelOrderResult.success);

      expect(repo.cancelled, [8]);
      expect(orderIn(container, 8).canCancel, isFalse);
      expect(products.cacheCleared, isTrue);
      expect(controller.applyUpdate({'id': 8, 'status': 'Cancelled'}), isNull);
    });

    test('a refused cancel leaves the order as it was', () async {
      repo.cancelResult = CancelOrderResult.notCancellable;
      final container = container0();
      await container.read(ordersControllerProvider.future);

      final result = await container.read(ordersControllerProvider.notifier).cancel(8);

      expect(result, CancelOrderResult.notCancellable);
      expect(orderIn(container, 8).status, 'Pending');
    });

    test('the realtime provider subscribes only while signed in and cleans up', () async {
      final signedOut = container0(uid: null)..read(ordersRealtimeProvider);
      expect(repo.onUpdate, isNull);
      signedOut.dispose();

      final container = container0()..listen(ordersRealtimeProvider, (_, _) {});
      expect(repo.onUpdate, isNotNull);
      container.dispose();
      expect(repo.channelRemoved, isTrue);
    });
  });
}
