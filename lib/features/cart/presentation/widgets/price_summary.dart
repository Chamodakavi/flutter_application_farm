import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// A label on the left and an amount on the right. When both do not fit on
/// one line (long Sinhala/Tamil labels, large text) the amount moves to the
/// next line instead of overflowing.
class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, required this.value, this.strong = false});

  final String label;
  final String value;

  /// Emphasised — the total row.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      children: [
        Text(
          label,
          style: strong ? text.titleSmall : text.bodyMedium?.copyWith(color: AppColors.ink500),
        ),
        Text(value, style: strong ? text.titleMedium : text.titleSmall),
      ],
    );
  }
}

/// Subtotal, shipping and total rows (cart, checkout and order detail).
/// The amounts arrive formatted so each screen keeps its own money style
/// (`Rs. 1,130.00` in the cart, `LKR 1,130` on orders).
class PriceSummary extends StatelessWidget {
  const PriceSummary({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
    this.note,
  });

  final String subtotal;
  final String shipping;
  final String total;

  /// Small print under the total ("estimate" wording in the cart).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SummaryRow(label: l10n.cartSubtotal, value: subtotal),
        const SizedBox(height: AppSpacing.sm),
        SummaryRow(label: l10n.cartShipping, value: shipping),
        const Divider(height: AppSpacing.xxl),
        SummaryRow(label: l10n.cartTotal, value: total, strong: true),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(note!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}
