import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/cart_line.dart';

/// One cart line (spec §11.15): thumbnail, name, unit price, quantity
/// stepper, line subtotal and a remove button. Warns when the quantity is
/// more than the shop has.
class CartLineTile extends StatelessWidget {
  const CartLineTile({
    super.key,
    required this.line,
    this.onQtyChanged,
    this.onRemove,
    this.onTap,
  });

  final CartLine line;

  /// Called with the new quantity; 0 means "remove". Null disables the
  /// stepper (offline).
  final ValueChanged<int>? onQtyChanged;
  final VoidCallback? onRemove;

  /// Opens the product.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final product = line.product;

    return SectionCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTap,
                child: NetworkImageBox(
                  url: product.image,
                  width: 64,
                  height: 64,
                  borderRadius: AppRadii.inputBorder,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(l10n.cartUnitPrice(Fmt.rs(product.price)), style: text.bodySmall),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.cartRemove,
                onPressed: onRemove,
                color: AppColors.red600,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              IgnorePointer(
                ignoring: onQtyChanged == null,
                child: Opacity(
                  opacity: onQtyChanged == null ? 0.5 : 1,
                  child: QtyStepper(
                    value: line.qty,
                    // Stepping below 1 removes the line (with Undo).
                    min: 0,
                    max: product.stock,
                    onChanged: onQtyChanged ?? (_) {},
                  ),
                ),
              ),
              Text(Fmt.rs(line.subtotal), style: text.titleMedium),
            ],
          ),
          if (line.exceedsStock) ...[
            const SizedBox(height: AppSpacing.sm),
            InfoNote(
              tone: InfoNoteTone.warning,
              text: product.inStock
                  ? l10n.cartOnlyLeft('${product.stock}')
                  : l10n.cartLineOutOfStock,
            ),
          ],
        ],
      ),
    );
  }
}
