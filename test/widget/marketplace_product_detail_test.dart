import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/core/widgets/widgets.dart';
import 'package:farmfriend/features/cart/data/cart_repository.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:farmfriend/features/marketplace/domain/product.dart';
import 'package:farmfriend/features/marketplace/presentation/product_detail_screen.dart';
import 'package:farmfriend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/cart_fakes.dart';

class _Profile extends ProfileController {
  @override
  Future<AppUser?> build() async => const AppUser(id: 'u1', name: 'Nimal', phone: '0771234567');
}

void main() {
  late FakeCartRepository cart;

  Future<void> pumpDetail(
    WidgetTester tester,
    List<Product> products,
    int id, {
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) async {
    cart = FakeCartRepository(products: products);
    await pumpApp(
      tester,
      ProductDetailScreen(productId: id),
      overrides: [
        currentUserIdProvider.overrideWithValue('u1'),
        profileProvider.overrideWith(_Profile.new),
        unreadNotificationCountProvider.overrideWithValue(0),
        productRepositoryProvider.overrideWithValue(FakeProductRepository(products)),
        cartRepositoryProvider.overrideWithValue(cart),
      ],
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    await tester.pumpAndSettle();
  }

  const seeds = Product(
    id: 1,
    name: 'Carrot seeds',
    price: 160,
    stock: 3,
    type: 'Seeds',
    category: 'Seeds',
    weight: '100 g',
    description: 'Hybrid carrot seeds for the up-country season.',
  );

  testWidgets('shows the product and limits the quantity to the stock', (tester) async {
    await pumpDetail(tester, const [seeds], 1);

    expect(find.text('Carrot seeds'), findsWidgets);
    expect(find.text('In Stock: 3'), findsOneWidget);
    expect(find.text('Weight: 100 g'), findsOneWidget);
    expect(find.text('Hybrid carrot seeds for the up-country season.'), findsOneWidget);
    expect(find.text('Rs. 160.00 × 1'), findsOneWidget);

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
    }
    expect(find.text('Rs. 160.00 × 3'), findsOneWidget);
    expect(find.text('Rs. 480.00'), findsOneWidget);
  });

  testWidgets('Add to cart adds the chosen quantity and confirms', (tester) async {
    await pumpDetail(tester, const [seeds], 1);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.text('Add to cart'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(cart.stored, {'1': 2});
    expect(find.text('Added to cart'), findsOneWidget);
  });

  testWidgets('Buy now adds the product and opens the cart', (tester) async {
    await pumpDetail(tester, const [seeds], 1);

    await tester.tap(find.text('Buy now'));
    await tester.pumpAndSettle();

    expect(cart.stored, {'1': 1});
    expect(find.text(routeMarker('/cart')), findsOneWidget);
  });

  testWidgets('an out-of-stock product cannot be added', (tester) async {
    await pumpDetail(tester, const [Product(id: 2, name: 'Hoe', price: 1250)], 2);

    expect(find.widgetWithText(TagChip, 'Out of stock'), findsOneWidget);
    expect(find.byType(QtyStepper), findsNothing);
    expect(
      tester.widget<PrimaryButton>(find.widgetWithText(PrimaryButton, 'Buy now')).onPressed,
      isNull,
    );
    expect(
      tester.widget<SecondaryButton>(find.widgetWithText(SecondaryButton, 'Add to cart')).onPressed,
      isNull,
    );
  });

  testWidgets('a product that no longer exists shows the error state', (tester) async {
    await pumpDetail(tester, const [seeds], 99);
    expect(find.text("We couldn't find what you were looking for."), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('does not overflow in Tamil at text scale 1.3', (tester) async {
    await pumpDetail(
      tester,
      const [
        Product(
          id: 1,
          name: 'உயர்தர கலப்பின கேரட் விதைகள் 100 கிராம்',
          price: 125000.50,
          stock: 120,
          type: 'Stainless Steel',
          category: 'Seeds',
          weight: '100 g',
          description: 'மலையகப் பருவத்திற்கான உயர்தர கலப்பின கேரட் விதைகள்.',
        ),
      ],
      1,
      locale: const Locale('ta'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
