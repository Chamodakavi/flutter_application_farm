import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/constants.dart';
import '../../data/product_repository.dart';
import '../../domain/product.dart';
import 'product_filter_provider.dart';

/// Number of products with stock > 0 (Home stat card).
final inStockProductCountProvider = FutureProvider<int>(
  (ref) => ref.watch(productRepositoryProvider).inStockCount(),
);

/// One product by id, for the detail screen and deep links (spec §11.14).
final productProvider = FutureProvider.autoDispose.family<Product, int>(
  (ref, id) => ref.watch(productRepositoryProvider).byId(id),
);

/// The pages loaded so far for one [ProductFilter].
@immutable
class ProductsState {
  const ProductsState({
    required this.items,
    required this.hasMore,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<Product> items;

  /// False once a page came back shorter than [AppConst.pageSize].
  final bool hasMore;
  final bool loadingMore;

  /// Set when the last "load more" failed; the grid shows a retry row.
  final Object? loadMoreError;
}

/// Infinite-scroll product list (spec §11.13): `range(from, to)` pages of
/// [AppConst.pageSize].
class ProductsController extends AsyncNotifier<ProductsState> {
  ProductsController(this.filter);

  final ProductFilter filter;
  int _nextPage = 1;

  Future<List<Product>> _fetch(int page, {bool forceRefresh = false}) =>
      ref.read(productRepositoryProvider).page(
        category: filter.category,
        query: filter.query,
        page: page,
        forceRefresh: forceRefresh,
      );

  ProductsState _firstPage(List<Product> items) =>
      ProductsState(items: items, hasMore: items.length >= AppConst.pageSize);

  @override
  Future<ProductsState> build() async {
    _nextPage = 1;
    return _firstPage(await _fetch(0));
  }

  /// Appends the next page; a no-op while one is loading or at the end.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(
      ProductsState(items: current.items, hasMore: true, loadingMore: true),
    );
    try {
      final more = await _fetch(_nextPage);
      if (!ref.mounted) return;
      _nextPage++;
      // A product added meanwhile shifts the pages; never show one twice.
      final known = current.items.map((p) => p.id).toSet();
      state = AsyncData(
        ProductsState(
          items: [...current.items, ...more.where((p) => !known.contains(p.id))],
          hasMore: more.length >= AppConst.pageSize,
        ),
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(ProductsState(items: current.items, hasMore: true, loadMoreError: e));
    }
  }

  /// Pull-to-refresh: reloads the first page from the network. Throws when
  /// that fails, leaving the current list on screen.
  Future<void> refresh() async {
    final repo = ref.read(productRepositoryProvider);
    final items = await _fetch(0, forceRefresh: true);
    try {
      await repo.categories(forceRefresh: true);
    } catch (_) {
      // The chips keep their saved values.
    }
    if (!ref.mounted) return;
    ref.invalidate(productCategoriesProvider);
    _nextPage = 1;
    state = AsyncData(_firstPage(items));
  }
}

final productsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ProductsController, ProductsState, ProductFilter>(ProductsController.new);
