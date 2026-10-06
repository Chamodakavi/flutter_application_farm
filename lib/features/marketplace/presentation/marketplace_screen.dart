import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/network/connectivity_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/product.dart';
import 'add_to_cart.dart';
import 'controllers/product_filter_provider.dart';
import 'controllers/products_controller.dart';
import 'widgets/category_chips.dart';
import 'widgets/product_card.dart';

/// Marketplace — tab 2 (spec §11.13): search, category chips and a
/// two-column product grid with infinite scroll.
class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key, this.initialCategory, this.initialQuery});

  /// From `/market?category=Seeds&q=…`.
  final String? initialCategory;
  final String? initialQuery;

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  static const _gridGap = AppSpacing.md;

  /// Start loading the next page this far before the end of the list.
  static const _loadMoreThreshold = 600.0;

  late final _search = TextEditingController(text: widget.initialQuery?.trim() ?? '');
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 350));
  final _scroll = ScrollController();

  late ProductFilter _filter = ProductFilter(
    category: (widget.initialCategory?.trim().isEmpty ?? true)
        ? null
        : widget.initialCategory!.trim(),
    query: widget.initialQuery?.trim() ?? '',
  );

  /// Products whose Add button is waiting for the cart.
  final _adding = <int>{};

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients || _scroll.position.extentAfter > _loadMoreThreshold) return;
    ref.read(productsControllerProvider(_filter).notifier).loadMore();
  }

  void _onSearchChanged(String text) {
    setState(() {}); // shows or hides the clear button
    _debouncer.run(() {
      if (mounted) _setFilter(_filter.withQuery(text));
    });
  }

  void _clearSearch() {
    _search.clear();
    _debouncer.dispose(); // drops a search that is still waiting
    _setFilter(_filter.withQuery(''));
  }

  void _showAll() {
    _search.clear();
    _debouncer.dispose();
    _setFilter(const ProductFilter());
  }

  void _setFilter(ProductFilter filter) {
    if (filter == _filter) {
      setState(() {});
      return;
    }
    setState(() => _filter = filter);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Future<void> _refresh() async {
    final provider = productsControllerProvider(_filter);
    if (!ref.read(provider).hasValue) {
      ref
        ..invalidate(provider)
        ..invalidate(productCategoriesProvider);
      return;
    }
    try {
      await ref.read(provider.notifier).refresh();
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  Future<void> _add(Product product) async {
    setState(() => _adding.add(product.id));
    await addToCart(context, ref, product.id);
    if (mounted) setState(() => _adding.remove(product.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final provider = productsControllerProvider(_filter);
    final products = ref.watch(provider);
    final categories = ref.watch(productCategoriesProvider).value ?? const <String>[];
    final online = ref.watch(isOnlineProvider);

    return AppScaffold(
      appBar: const FarmAppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.marketTitle, style: text.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.marketSubtitle,
                      style: text.bodyMedium?.copyWith(color: AppColors.ink500),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextField(
                      controller: _search,
                      onChanged: _onSearchChanged,
                      onSubmitted: (value) => _setFilter(_filter.withQuery(value)),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: l10n.marketSearchHint,
                        fillColor: AppColors.white,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _search.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: l10n.marketSearchClear,
                                onPressed: _clearSearch,
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CategoryChips(
                categories: categories,
                selected: _filter.category,
                onSelected: (category) => _setFilter(_filter.withCategory(category)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            ..._productSlivers(products, online: online),
            const SliverToBoxAdapter(child: SizedBox(height: kFabClearance)),
          ],
        ),
      ),
    );
  }

  List<Widget> _productSlivers(AsyncValue<ProductsState> products, {required bool online}) {
    final l10n = context.l10n;
    final provider = productsControllerProvider(_filter);

    if (!products.hasValue) {
      if (products.hasError) {
        return [
          SliverToBoxAdapter(
            child: ErrorState(error: products.error, onRetry: () => ref.invalidate(provider)),
          ),
        ];
      }
      return const [
        SliverToBoxAdapter(child: ShimmerGrid(shrinkWrap: true, padding: AppSpacing.page)),
      ];
    }

    final state = products.requireValue;
    if (state.items.isEmpty) {
      final searching = _filter.query.isNotEmpty;
      return [
        SliverToBoxAdapter(
          child: EmptyState(
            icon: searching ? Icons.search_off_rounded : Icons.storefront_outlined,
            title: searching ? l10n.commonNoResults : l10n.marketEmptyTitle,
            message: searching ? l10n.marketEmptySearch(_filter.query) : l10n.marketEmptyMessage,
            actionLabel: searching || _filter.category != null ? l10n.marketShowAll : null,
            onAction: _showAll,
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        sliver: SliverLayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.crossAxisExtent - _gridGap) / 2;
            return SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: _gridGap,
                crossAxisSpacing: _gridGap,
                // ≈ 0.62 aspect ratio, taller when the text needs more room.
                mainAxisExtent: ProductCard.heightFor(context, cardWidth),
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final product = state.items[index];
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                  adding: _adding.contains(product.id),
                  onTap: () => context.push(Routes.product(product.id)),
                  onAdd: online ? () => _add(product) : null,
                );
              },
            );
          },
        ),
      ),
      if (state.loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
        )
      else if (state.loadMoreError != null)
        SliverToBoxAdapter(
          child: ErrorState(
            error: state.loadMoreError,
            compact: true,
            onRetry: () => ref.read(provider.notifier).loadMore(),
          ),
        ),
    ];
  }
}
