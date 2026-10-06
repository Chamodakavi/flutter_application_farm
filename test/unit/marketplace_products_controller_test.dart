import 'package:farmfriend/core/config/constants.dart';
import 'package:farmfriend/features/marketplace/data/product_repository.dart';
import 'package:farmfriend/features/marketplace/presentation/controllers/product_filter_provider.dart';
import 'package:farmfriend/features/marketplace/presentation/controllers/products_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cart_fakes.dart';

void main() {
  ProviderContainer container0(FakeProductRepository repo) {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [productRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('ProductFilter is a value: equal filters share one provider', () {
    expect(const ProductFilter(category: 'Seeds', query: 'car'),
        const ProductFilter(category: 'Seeds').withQuery(' car '));
    expect(const ProductFilter(), isNot(const ProductFilter(category: 'Tools')));
    expect(const ProductFilter(category: 'Seeds').withCategory(null), const ProductFilter());
  });

  test('pages are appended until a short page ends the list', () async {
    final repo = FakeProductRepository([for (var i = 1; i <= 45; i++) product(i)]);
    final container = container0(repo);
    final provider = productsControllerProvider(const ProductFilter());
    container.listen(provider, (_, _) {});

    var state = await container.read(provider.future);
    expect(state.items, hasLength(AppConst.pageSize));
    expect(state.hasMore, isTrue);

    await container.read(provider.notifier).loadMore();
    state = container.read(provider).requireValue;
    expect(state.items, hasLength(40));
    expect(state.hasMore, isTrue);

    await container.read(provider.notifier).loadMore();
    state = container.read(provider).requireValue;
    expect(state.items, hasLength(45));
    expect(state.hasMore, isFalse);

    // At the end: no further request.
    await container.read(provider.notifier).loadMore();
    expect(repo.requestedPages, [0, 1, 2]);
    expect(state.items.map((p) => p.id).toSet(), hasLength(45));
  });

  test('the filter narrows the list', () async {
    final repo = FakeProductRepository([
      product(1, name: 'Carrot seeds'),
      product(2, name: 'Hoe'),
      product(3, name: 'Cabbage seeds'),
    ]);
    final container = container0(repo);
    final provider = productsControllerProvider(const ProductFilter(query: 'seeds'));
    container.listen(provider, (_, _) {});

    final state = await container.read(provider.future);
    expect(state.items.map((p) => p.id), [1, 3]);
    expect(state.hasMore, isFalse);
  });

  test('inStockProductCountProvider counts products with stock > 0', () async {
    final repo = FakeProductRepository([product(1), product(2, stock: 0), product(3, stock: 4)]);
    final container = container0(repo);
    expect(await container.read(inStockProductCountProvider.future), 2);
  });
}
