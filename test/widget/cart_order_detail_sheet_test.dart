import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/core/widgets/widgets.dart';
import 'package:farmfriend/features/cart/data/order_repository.dart';
import 'package:farmfriend/features/cart/domain/order.dart';
import 'package:farmfriend/features/cart/domain/order_item.dart';
import 'package:farmfriend/features/cart/presentation/order_detail_sheet.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/cart_fakes.dart';

void main() {
  Future<FakeOrderRepository> pumpSheet(
    WidgetTester tester,
    Order shown, {
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) async {
    final repo = FakeOrderRepository([shown]);
    await pumpApp(
      tester,
      Scaffold(body: OrderDetailSheet(order: shown)),
      overrides: [
        currentUserIdProvider.overrideWithValue('u1'),
        orderRepositoryProvider.overrideWithValue(repo),
        productRepositoryProvider.overrideWithValue(FakeProductRepository(const [])),
      ],
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    await tester.pumpAndSettle();
    return repo;
  }

  // TC_MKT_03
  testWidgets('a pending order shows Cancel Order and its details', (tester) async {
    await pumpSheet(tester, order(8, adminNote: 'We will call you'));

    expect(find.text('Order #8'), findsOneWidget);
    expect(find.text('Your order is waiting for admin review.'), findsOneWidget);
    expect(find.text('We will call you'), findsOneWidget);
    expect(find.text('Carrot seeds'), findsOneWidget);
    expect(find.text('Qty: 3 × LKR 100'), findsOneWidget);
    expect(find.text('LKR 350'), findsOneWidget); // shipping row
    expect(find.text('LKR 650'), findsOneWidget);
    expect(find.widgetWithText(DangerButton, 'Cancel Order'), findsOneWidget);
  });

  testWidgets('orders that are no longer pending have no Cancel button', (tester) async {
    for (final status in ['Approved', 'Shipped', 'Delivered', 'Cancelled', 'Rejected']) {
      await pumpSheet(tester, order(8, status: status));
      expect(find.text('Order #8'), findsOneWidget, reason: status);
      expect(find.byType(DangerButton), findsNothing, reason: status);
      expect(find.text('Cancel Order'), findsNothing, reason: status);
    }
  });

  testWidgets('cancelling asks first, calls the RPC and hides the button', (tester) async {
    final repo = await pumpSheet(tester, order(8));

    await tester.ensureVisible(find.text('Cancel Order'));
    await tester.tap(find.text('Cancel Order'));
    await tester.pumpAndSettle();
    expect(find.text('Cancel this order?'), findsOneWidget);

    // "Keep order" changes nothing.
    await tester.tap(find.text('Keep order'));
    await tester.pumpAndSettle();
    expect(repo.cancelled, isEmpty);

    await tester.tap(find.text('Cancel Order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, cancel order'));
    await tester.pumpAndSettle();

    expect(repo.cancelled, [8]);
    expect(find.byType(DangerButton), findsNothing);
    expect(find.text('Your order was cancelled.'), findsOneWidget);
    expect(find.text('This order was cancelled.'), findsOneWidget);
  });

  testWidgets('a refused cancel explains why inside the sheet', (tester) async {
    final repo = await pumpSheet(tester, order(8));
    repo.cancelResult = CancelOrderResult.notCancellable;

    await tester.ensureVisible(find.text('Cancel Order'));
    await tester.tap(find.text('Cancel Order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, cancel order'));
    await tester.pumpAndSettle();

    expect(find.textContaining('can no longer be cancelled'), findsOneWidget);
  });

  testWidgets('the sheet does not overflow in Sinhala at text scale 1.3', (tester) async {
    await pumpSheet(
      tester,
      order(8, adminNote: 'සිකුරාදා භාර දෙනු ලැබේ'),
      locale: const Locale('si'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(DangerButton), findsOneWidget);
  });
}
