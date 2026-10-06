import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/product.dart';
import 'stock_badge.dart';

/// Grid card of the marketplace (spec §11.13): 4:3 image with the type badge,
/// cream body with stock, name, price and a green Add button. An out-of-stock
/// product is greyed, shows a chip and cannot be added.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAdd,
    this.adding = false,
  });

  final Product product;
  final VoidCallback? onTap;

  /// Null disables the button (offline). Ignored when out of stock.
  final VoidCallback? onAdd;

  /// Shows a spinner on the button while the cart is being updated.
  final bool adding;

  static const _imageRatio = 4 / 3;
  static const _targetRatio = 0.62;
  static const _padding = AppSpacing.sm;
  static const _buttonHeight = 44.0;

  /// Height of a card that is [width] wide.
  ///
  /// Close to the spec's 0.62 aspect ratio at normal text size, and taller
  /// when the text is scaled up or the script needs more line height
  /// (Sinhala, Tamil), so the body never overflows.
  static double heightFor(BuildContext context, double width) {
    final text = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    double line(TextStyle? style, {double? height}) =>
        scaler.scale(style?.fontSize ?? 14) * (height ?? style?.height ?? 1.4);

    final stock = math.max(line(text.bodySmall), line(text.labelSmall, height: 1.2) + 8);
    final button = math.max(AppSpacing.minTap, line(text.labelMedium) + 16);
    final body =
        _padding +
        stock +
        AppSpacing.xs +
        2 * line(text.titleSmall) +
        AppSpacing.xs +
        line(text.titleSmall) +
        AppSpacing.sm +
        button +
        _padding;
    // 2 px for the border and a little slack for rounding.
    return math.max(width / _targetRatio, width / _imageRatio + body + 6).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final available = product.inStock;
    final type = product.type?.trim() ?? '';

    Widget image = NetworkImageBox(url: product.image, aspectRatio: _imageRatio);
    if (!available) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.mode(AppColors.line200, BlendMode.saturation),
        child: image,
      );
    }

    final body = Padding(
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StockBadge(stock: product.stock),
          const SizedBox(height: AppSpacing.xs),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(color: available ? null : AppColors.ink500),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              Fmt.rs(product.price),
              maxLines: 1,
              style: text.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: available ? AppColors.forest900 : AppColors.ink500,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton(
            onPressed: available && !adding ? onAdd : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(_buttonHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              textStyle: text.labelMedium,
            ),
            child: adding
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_shopping_cart_rounded, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(l10n.productAdd, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );

    return Semantics(
      label: product.name,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.cream50,
          borderRadius: AppRadii.cardBorder,
          border: Border.all(color: AppColors.line200),
          boxShadow: kCardShadow,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: AppRadii.cardBorder,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    image,
                    if (type.isNotEmpty)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: TypeBadge(type),
                        ),
                      ),
                  ],
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
