import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/config/app_config.dart';
import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/core/widgets/widgets.dart';
import 'package:farmfriend/features/cart/data/cart_repository.dart';
import 'package:farmfriend/features/cart/data/order_repository.dart';
import 'package:farmfriend/features/cart/domain/order_item.dart';
import 'package:farmfriend/features/cart/presentation/checkout_screen.dart';
import 'package:farmfriend/features/cart/presentation/order_detail_sheet.dart';
import 'package:farmfriend/features/cart/presentation/order_success_screen.dart';
import 'package:farmfriend/features/cart/presentation/orders_screen.dart';
import 'package:farmfriend/features/cart/presentation/widgets/order_tile.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/cart_fakes.dart';

class _Profile extends ProfileController {
  @override
  Future<AppUser?> build() async => const AppUser(
    id: 'u1',
    name: 'Nimal',
    surname: 'Perera',
    phone: '0771234567',
    district: 'Kandy',
  );
}

/// Records events instead of sending them.
class _Analytics extends AnalyticsService {
  _Analytics(super.ref);

  final events = <String, Map<String, Object?>>{};

  @override
  void track(String event, [Map<String, Object?> props = const {}]) => events[event] = props;
}

void main() {
  late FakeCartRepository cart;
  late FakeOrderRepository orders;
  late _Analytics analytics;

  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) async {
    await pumpApp(
      tester,
      screen,
      overrides: [
        currentUserIdProvider.overrideWithValue('u1'),
        profileProvider.overrideWith(_Profile.new),
        cartRepositoryProvider.overrideWithValue(cart),
        orderRepositoryProvider.overrideWithValue(orders),
        productRepositoryProvider.overrideWithValue(FakeProductRepository(const [])),
        appConfigOrDefaultProvider.overrideWithValue(const AppConfig(shippingFeeLkr: 350)),
        analyticsProvider.overrideWith((ref) => analytics = _Analytics(ref)),
      ],
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    cart = FakeCartRepository(
      products: [product(1, name: 'Carrot seeds', price: 100), product(2, name: 'Hoe', price: 50)],
      initial: {1: 3, 2: 1},
    );
    orders = FakeOrderRepository();
  });

  group('CheckoutScreen', () {
    testWidgets('prefills the contact details and shows the summary', (tester) async {
      await pump(tester, const CheckoutScreen());

      expect(find.text('Nimal Perera'), findsOneWidget);
      expect(find.text('0771234567'), findsOneWidget);
      expect(find.text('Kandy'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      // The only payment option is pre-selected.
      expect(
        find.byWidgetPredicate((w) => w is RadioGroup && w.groupValue != null),
        findsOneWidget,
      );
      expect(find.text('Carrot seeds × 3'), findsOneWidget);
      expect(find.text('Rs. 300.00'), findsOneWidget); // line subtotal
      expect(find.text('Rs. 350.00'), findsNWidgets(2)); // subtotal and shipping
      expect(find.text('Rs. 700.00'), findsOneWidget); // estimated total
    });

    // TC_MKT_02
    testWidgets('Place order sends the phone, tracks the order and opens the success screen', (
      tester,
    ) async {
      await pump(tester, const CheckoutScreen());

      await tester.tap(find.text('Place order'));
      await tester.pumpAndSettle();

      expect(orders.placedWithPhone, '0771234567');
      expect(analytics.events[AnalyticsEvents.orderPlaced], {'items': 2, 'total': 650});
      expect(find.text(routeMarker('/cart/success/9')), findsOneWidget);
    });

    testWidgets('an invalid phone number is rejected before the RPC', (tester) async {
      await pump(tester, const CheckoutScreen());

      await tester.enterText(find.widgetWithText(TextFormField, '0771234567'), '12345');
      await tester.tap(find.text('Place order'));
      await tester.pumpAndSettle();

      expect(orders.placedWithPhone, isNull);
      expect(find.textContaining('valid mobile number'), findsOneWidget);
    });

    testWidgets('insufficient stock names the product and leads back to the cart', (
      tester,
    ) async {
      orders.placeResult = const PlaceOrderResult.insufficientStock(
        productId: '2',
        productName: 'Hoe',
        available: 0,
      );
      await pump(tester, const CheckoutScreen());

      await tester.tap(find.text('Place order'));
      await tester.pumpAndSettle();

      expect(find.text('Not enough stock'), findsOneWidget);
      expect(find.textContaining('"Hoe" is out of stock'), findsOneWidget);

      await tester.tap(find.text('Update cart'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/cart')), findsOneWidget);
    });

    testWidgets('empty_cart from the server sends the user back to the cart', (tester) async {
      orders.placeResult = const PlaceOrderResult.emptyCart();
      await pump(tester, const CheckoutScreen());

      await tester.tap(find.text('Place order'));
      await tester.pumpAndSettle();

      expect(find.text(routeMarker('/cart')), findsOneWidget);
    });

    testWidgets('an unknown result keeps the user on checkout with a message', (tester) async {
      orders.placeResult = const PlaceOrderResult.unknown();
      await pump(tester, const CheckoutScreen());

      await tester.tap(find.text('Place order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('We could not place your order. Please try again.'), findsOneWidget);
      expect(find.text('Place order'), findsOneWidget);
    });

    testWidgets('does not overflow in Sinhala at text scale 1.3', (tester) async {
      await pump(
        tester,
        const CheckoutScreen(),
        locale: const Locale('si'),
        textScale: 1.3,
        surfaceSize: const Size(320, 640),
      );
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('OrderSuccessScreen', () {
    testWidgets('shows the order number, total and both actions', (tester) async {
      orders = FakeOrderRepository([order(9)]);
      await pump(tester, const OrderSuccessScreen(orderId: 9));

      expect(find.text('#9'), findsOneWidget);
      expect(find.text('LKR 650'), findsOneWidget);
      expect(find.text('Your order is waiting for admin review.'), findsOneWidget);
      expect(find.text('Continue shopping'), findsOneWidget);

      await tester.ensureVisible(find.text('View my orders'));
      await tester.tap(find.text('View my orders'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker('/orders')), findsOneWidget);
    });
  });

  group('OrdersScreen', () {
    testWidgets('lists orders with status, total and item count', (tester) async {
      orders = FakeOrderRepository([order(8), order(7, status: 'Delivered')]);
      await pump(tester, const OrdersScreen());

      expect(find.byType(OrderTile), findsNWidgets(2));
      expect(find.text('Order #8'), findsOneWidget);
      expect(find.widgetWithText(StatusChip, 'Pending'), findsOneWidget);
      expect(find.widgetWithText(StatusChip, 'Delivered'), findsOneWidget);
      expect(find.text('LKR 650'), findsNWidgets(2));
      expect(find.text('1 item'), findsNWidgets(2));
      expect(find.byType(OrderDetailSheet), findsNothing);
    });

    testWidgets('openOrderId opens that order once the list has loaded', (tester) async {
      orders = FakeOrderRepository([order(8), order(7, status: 'Delivered')]);
      await pump(tester, const OrdersScreen(openOrderId: 7));

      expect(find.byType(OrderDetailSheet), findsOneWidget);
      expect(find.text('Your order was delivered. Thank you!'), findsOneWidget);
    });

    testWidgets('no orders shows the empty state', (tester) async {
      await pump(tester, const OrdersScreen());
      expect(find.text('No orders yet'), findsOneWidget);
      expect(find.text('Start Shopping'), findsOneWidget);
    });
  });
}
