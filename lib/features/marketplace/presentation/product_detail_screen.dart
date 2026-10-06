import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/product.dart';
import 'add_to_cart.dart';
import 'controllers/product_filter_provider.dart';
import 'controllers/products_controller.dart';
import 'widgets/image_gallery.dart';
import 'widgets/stock_badge.dart';

/// Product detail (spec §11.14). The product is read by id, so shared links
/// and notifications can open this screen directly.
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

enum _Action { add, buy }

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  /// Descriptions longer than this start collapsed.
  static const _collapseAfter = 180;

  int _qty = 1;
  bool _expanded = false;
  _Action? _busy;

  Future<void> _addToCart(_Action action, int qty) async {
    setState(() => _busy = action);
    final added = await addToCart(
      context,
      ref,
      widget.productId,
      qty: qty,
      confirm: action == _Action.add,
    );
    if (!mounted) return;
    setState(() => _busy = null);
    if (added && action == _Action.buy) unawaited(context.push(Routes.cart));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = productProvider(widget.productId);
    final value = ref.watch(provider);
    final product = value.value;

    return AppScaffold(
      appBar: FarmAppBar(showBack: true, title: product?.name ?? l10n.productDetailTitle),
      bottomBar: product == null ? null : _bottomBar(product),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(provider);
          try {
            await ref.read(provider.future);
          } catch (_) {
            // The error state (or the product already shown) covers it.
          }
        },
        child: AsyncValueView<Product>(
          value: value,
          onRetry: () => ref.invalidate(provider),
          loading: const _DetailSkeleton(),
          error: (e) => ListView(
            children: [ErrorState(error: e, onRetry: () => ref.invalidate(provider))],
          ),
          data: _content,
        ),
      ),
    );
  }

  int _clampedQty(Product product) => _qty.clamp(1, math.max(1, product.stock));

  Widget _content(Product product) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final type = product.type?.trim() ?? '';
    final category = product.category?.trim() ?? '';
    final weight = product.weight?.trim() ?? '';
    final description = product.description?.trim() ?? '';
    final long = description.length > _collapseAfter;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.page,
      children: [
        ImageGallery(images: product.gallery),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: text.titleLarge),
              if (type.isNotEmpty || category.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (type.isNotEmpty) TypeBadge(type),
                    if (category.isNotEmpty)
                      TagChip(
                        productCategoryLabel(l10n, category),
                        icon: Icons.category_outlined,
                      ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                Fmt.rs(product.price),
                style: text.displaySmall?.copyWith(color: AppColors.green600),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StockBadge(stock: product.stock),
                  if (weight.isNotEmpty)
                    Text(l10n.productWeight(weight), style: text.bodySmall),
                ],
              ),
            ],
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SectionCard(
            title: l10n.productDescription,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  maxLines: long && !_expanded ? 4 : null,
                  overflow: long && !_expanded ? TextOverflow.ellipsis : null,
                  style: text.bodyMedium,
                ),
                if (long)
                  TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(_expanded ? l10n.productShowLess : l10n.productReadMore),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (product.inStock)
          SectionCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                Text(l10n.productQuantity, style: text.titleSmall),
                QtyStepper(
                  value: _clampedQty(product),
                  min: 1,
                  max: product.stock,
                  onChanged: (qty) => setState(() => _qty = qty),
                ),
              ],
            ),
          )
        else
          InfoNote(text: l10n.productOutOfStockNote, tone: InfoNoteTone.warning),
      ],
    );
  }

  /// Sticky bar: price × qty and the two actions.
  Widget _bottomBar(Product product) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final qty = _clampedQty(product);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.md,
          children: [
            Text('${Fmt.rs(product.price)} × $qty', style: text.bodySmall),
            Text(Fmt.rs(product.price * qty), style: text.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        OnlineOnly(
          builder: (context, online) {
            final enabled = online && product.inStock && _busy == null;
            return Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: l10n.productAddToCart,
                    loading: _busy == _Action.add,
                    onPressed: enabled ? () => _addToCart(_Action.add, qty) : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: l10n.productBuyNow,
                    loading: _busy == _Action.buy,
                    onPressed: enabled ? () => _addToCart(_Action.buy, qty) : null,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) => ShimmerScope(
    child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.page,
      children: const [
        AspectRatio(aspectRatio: 4 / 3, child: ShimmerBox(height: double.infinity, radius: 20)),
        SizedBox(height: AppSpacing.lg),
        ShimmerBox(height: 150, radius: 20),
        SizedBox(height: AppSpacing.md),
        ShimmerBox(height: 110, radius: 20),
      ],
    ),
  );
}
