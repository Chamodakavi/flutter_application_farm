import 'package:farmfriend/core/config/app_config.dart';
import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/core/widgets/widgets.dart';
import 'package:farmfriend/features/cart/data/cart_repository.dart';
import 'package:farmfriend/features/cart/data/order_repository.dart';
import 'package:farmfriend/features/cart/presentation/cart_screen.dart';
import 'package:farmfriend/features/cart/presentation/widgets/cart_line_tile.dart';
import 'package:farmfriend/features/cart/presentation/widgets/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/cart_fakes.dart';

void main() {
  Future<void> pumpCart(
    WidgetTester tester,
    FakeCartRepository cart, {
    FakeOrderRepository? orders,
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) async {
    await pumpApp(
      tester,
      const CartScreen(),
      overrides: [
        currentUserIdProvider.overrideWithValue('u1'),
        cartRepositoryProvider.overrideWithValue(cart),
        orderRepositoryProvider.overrideWithValue(orders ?? FakeOrderRepository()),
        appConfigOrDefaultProvider.overrideWithValue(const AppConfig(shippingFeeLkr: 350)),
      ],
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('an empty cart shows the empty state with Start Shopping', (tester) async {
    await pumpCart(tester, FakeCartRepository());

    expect(find.text('Shopping Cart'), findsOneWidget);
    expect(find.text('Cash on Delivery'), findsOneWidget);
    expect(find.text('Your Cart is Empty'), findsOneWidget);
    expect(find.text('Start Shopping'), findsOneWidget);
    expect(find.text('Proceed to checkout'), findsNothing);

    await tester.tap(find.text('Start Shopping'));
    await tester.pumpAndSettle();
    expect(find.text(routeMarker('/market')), findsOneWidget);
  });

  testWidgets('lines, estimated totals and the last three orders are shown', (tester) async {
    final cart = FakeCartRepository(
      products: [product(1, name: 'Carrot seeds', price: 160), product(2, name: 'Hoe', price: 1000)],
      initial: {1: 2, 2: 1},
    );
    final orders = FakeOrderRepository([order(9), order(8), order(7), order(6)]);
    await pumpCart(tester, cart, orders: orders);

    expect(find.byType(CartLineTile), findsNWidgets(2));
    expect(find.text('Carrot seeds'), findsOneWidget);
    expect(find.text('Rs. 1,320.00'), findsOneWidget); // subtotal
    expect(find.text('Rs. 350.00'), findsOneWidget); // shipping from config
    expect(find.text('Rs. 1,670.00'), findsNWidgets(2)); // summary + sticky bar
    expect(find.widgetWithText(PrimaryButton, 'Proceed to checkout'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Order #7'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.byType(OrderTile, skipOffstage: false), findsNWidgets(3));
    expect(find.text('Order #6', skipOffstage: false), findsNothing);
  });

  testWidgets('the stepper updates the quantity; stepping below 1 removes with Undo', (
    tester,
  ) async {
    final cart = FakeCartRepository(
      products: [product(1, name: 'Carrot seeds', price: 160)],
      initial: {1: 1},
    );
    await pumpCart(tester, cart);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(cart.stored, {'1': 2});
    expect(find.text('Rs. 320.00'), findsNWidgets(2)); // line subtotal + summary subtotal

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    expect(cart.stored, isEmpty);
    expect(find.text('Your Cart is Empty'), findsOneWidget);
    expect(find.text('Carrot seeds removed from cart'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(cart.stored, {'1': 1});
    expect(find.byType(CartLineTile), findsOneWidget);
  });

  testWidgets('a quantity above the stock is flagged and blocks checkout', (tester) async {
    final cart = FakeCartRepository(
      products: [product(1, name: 'Carrot seeds', stock: 2)],
      initial: {1: 5},
    );
    await pumpCart(tester, cart);

    expect(find.textContaining('Only 2 left in stock'), findsOneWidget);
    final button = tester.widget<PrimaryButton>(
      find.widgetWithText(PrimaryButton, 'Proceed to checkout'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('the cart does not overflow in Tamil at text scale 1.3', (tester) async {
    final cart = FakeCartRepository(
      products: [
        product(1, name: 'உயர்தர கலப்பின கேரட் விதைகள் 100 கிராம்', price: 1130, stock: 1),
        product(2, name: 'மண்வெட்டி', price: 12500),
      ],
      initial: {1: 3, 2: 12},
    );
    await pumpCart(
      tester,
      cart,
      orders: FakeOrderRepository([order(8), order(7, status: 'Delivered')]),
      locale: const Locale('ta'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
