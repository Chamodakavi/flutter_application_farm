import 'package:farmfriend/core/widgets/widgets.dart';
import 'package:farmfriend/features/marketplace/domain/product.dart';
import 'package:farmfriend/features/marketplace/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/cart_fakes.dart';

void main() {
  Future<void> pumpCard(
    WidgetTester tester,
    Product shown, {
    VoidCallback? onAdd,
    VoidCallback? onTap,
  }) => pumpApp(
    tester,
    Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => SizedBox(
            width: 170,
            height: ProductCard.heightFor(context, 170),
            child: ProductCard(product: shown, onAdd: onAdd, onTap: onTap),
          ),
        ),
      ),
    ),
  );

  testWidgets('an in-stock product shows stock, name, price and a working Add button', (
    tester,
  ) async {
    var added = 0;
    var opened = 0;
    await pumpCard(
      tester,
      product(1, name: 'Carrot seeds', price: 160, stock: 5, type: 'Seeds'),
      onAdd: () => added++,
      onTap: () => opened++,
    );

    expect(find.text('In Stock: 5'), findsOneWidget);
    expect(find.text('Carrot seeds'), findsOneWidget);
    expect(find.text('Rs. 160.00'), findsOneWidget);
    expect(find.widgetWithText(TypeBadge, 'Seeds'), findsOneWidget);
    expect(find.text('Out of stock'), findsNothing);

    await tester.tap(find.text('Add'));
    expect(added, 1);
    await tester.tap(find.text('Carrot seeds'));
    expect(opened, 1);
  });

  testWidgets('an out-of-stock product shows the chip and its Add button is disabled', (
    tester,
  ) async {
    var added = 0;
    await pumpCard(
      tester,
      product(2, name: 'Hoe', price: 1250, stock: 0),
      onAdd: () => added++,
    );

    expect(find.widgetWithText(TagChip, 'Out of stock'), findsOneWidget);
    expect(find.textContaining('In Stock'), findsNothing);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);

    await tester.tap(find.text('Add'), warnIfMissed: false);
    expect(added, 0);
  });

  testWidgets('the card height grows with the text scale', (tester) async {
    late double normal;
    late double large;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          normal = ProductCard.heightFor(context, 173);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: Builder(
              builder: (context) {
                large = ProductCard.heightFor(context, 173);
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
    // Never shorter than the spec's 0.62 aspect ratio, taller for big text.
    expect(normal, greaterThanOrEqualTo(173 / 0.62));
    expect(large, greaterThan(normal));
  });
}
