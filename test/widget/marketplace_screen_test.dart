import 'package:farmfriend/core/supabase/supabase_providers.dart';
import 'package:farmfriend/features/cart/data/cart_repository.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:farmfriend/features/marketplace/domain/product.dart';
import 'package:farmfriend/features/marketplace/presentation/marketplace_screen.dart';
import 'package:farmfriend/features/marketplace/presentation/widgets/product_card.dart';
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
  Future<void> pumpMarket(
    WidgetTester tester,
    List<Product> products, {
    FakeCartRepository? cart,
    String? initialCategory,
    Locale locale = const Locale('en'),
    double textScale = 1.0,
    Size surfaceSize = const Size(390, 844),
  }) async {
    await pumpApp(
      tester,
      MarketplaceScreen(initialCategory: initialCategory),
      overrides: [
        currentUserIdProvider.overrideWithValue('u1'),
        profileProvider.overrideWith(_Profile.new),
        unreadNotificationCountProvider.overrideWithValue(0),
        productRepositoryProvider.overrideWithValue(FakeProductRepository(products)),
        cartRepositoryProvider.overrideWithValue(cart ?? FakeCartRepository(products: products)),
      ],
      locale: locale,
      textScale: textScale,
      surfaceSize: surfaceSize,
    );
    await tester.pumpAndSettle();
  }

  final catalogue = [
    const Product(id: 1, name: 'Carrot seeds', price: 160, stock: 12, type: 'Seeds', category: 'Seeds'),
    const Product(id: 2, name: 'Hoe', price: 1250, stock: 0, type: 'Steel', category: 'Tools'),
    const Product(id: 3, name: 'Watering can', price: 890, stock: 4, type: 'Plastic', category: 'Tools'),
  ];

  testWidgets('shows the header, category chips from the data and the grid', (tester) async {
    await pumpMarket(tester, catalogue);

    expect(find.text('Marketplace'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Seeds'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Tools'), findsOneWidget);
    expect(find.byType(ProductCard), findsNWidgets(3));

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tools'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(find.text('Carrot seeds'), findsNothing);
  });

  testWidgets('search is debounced and filters by name', (tester) async {
    await pumpMarket(tester, catalogue);

    await tester.enterText(find.byType(TextField), 'can');
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(ProductCard), findsNWidgets(3)); // still waiting
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Watering can'), findsOneWidget);
  });

  testWidgets('Add puts the product in the cart and offers "View cart"', (tester) async {
    final cart = FakeCartRepository(products: catalogue);
    await pumpMarket(tester, catalogue, cart: cart);

    await tester.tap(find.text('Add').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(cart.stored, {'1': 1});
    expect(find.text('Added to cart'), findsOneWidget);
    expect(find.text('View cart'), findsOneWidget);
  });

  testWidgets('an empty category shows the empty state', (tester) async {
    await pumpMarket(tester, catalogue, initialCategory: 'Fertilizer');

    expect(find.byType(ProductCard), findsNothing);
    expect(find.text('No products yet'), findsOneWidget);
    // The category from the link still has a chip so it can be cleared.
    expect(find.widgetWithText(ChoiceChip, 'Fertilizer'), findsOneWidget);

    await tester.tap(find.text('Show all products'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(3));
  });

  // TC_L10N_01
  testWidgets('the product grid does not overflow in Tamil at text scale 1.3 on 320×640', (
    tester,
  ) async {
    final products = [
      const Product(
        id: 1,
        name: 'உயர்தர கலப்பின கேரட் விதைகள் 100 கிராம்',
        price: 1130,
        stock: 120,
        type: 'Stainless Steel',
        category: 'Seeds',
      ),
      const Product(
        id: 2,
        name: 'மண்வெட்டி',
        price: 125000.50,
        stock: 0,
        type: 'Steel',
        category: 'Tools',
      ),
      for (var i = 3; i <= 8; i++)
        Product(
          id: i,
          name: 'நீர்ப்பாசனக் குழாய் மற்றும் தெளிப்பான் தொகுப்பு $i',
          price: 890.0 * i,
          stock: i,
          type: 'Plastic',
          category: 'Tools',
        ),
    ];
    await pumpMarket(
      tester,
      products,
      locale: const Locale('ta'),
      textScale: 1.3,
      surfaceSize: const Size(320, 640),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('சந்தை'), findsOneWidget);
    expect(find.text('கையிருப்பு இல்லை', skipOffstage: false), findsOneWidget);

    // Scroll through the whole grid: every card is laid out at least once.
    for (var i = 0; i < 4; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.byType(ProductCard), findsWidgets);
  });
}
