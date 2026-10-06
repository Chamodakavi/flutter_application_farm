import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/profit_plan.dart';

/// Planner output (spec §11.31): planting month, expected harvest, cost,
/// income, profit in green or red, and the break-even price.
class ProfitResultCard extends StatelessWidget {
  const ProfitResultCard({super.key, required this.plan, this.footer});

  final ProfitPlan plan;

  /// Extra content under the rows (the quota-room line).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = context.localeTag;
    final profit = plan.profitLkr;
    final profitColor = profit == null
        ? AppColors.ink900
        : (plan.isLoss ? AppColors.red600 : AppColors.green600);

    return SectionCard(
      title: l10n.plannerResultTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (plan.yieldMtPerHa == null) ...[
            InfoNote(tone: InfoNoteTone.warning, text: l10n.plannerNoYield),
            const SizedBox(height: AppSpacing.md),
          ],
          _Row(
            icon: Icons.event_available_rounded,
            label: l10n.plannerPlantIn,
            value: Fmt.monthYear(plan.forecast.plantingDate, locale),
          ),
          _Row(
            icon: Icons.agriculture_rounded,
            label: l10n.plannerExpectedHarvest,
            value: Fmt.mt(plan.expectedMt),
            valueKey: const Key('planner-harvest'),
            bold: true,
          ),
          _Row(
            icon: Icons.payments_outlined,
            label: l10n.plannerCost,
            value: Fmt.rsWhole(plan.costLkr),
            valueKey: const Key('planner-cost'),
          ),
          _Row(
            icon: Icons.storefront_outlined,
            label: l10n.plannerIncome,
            value: Fmt.rsWhole(plan.revenueLkr),
            valueKey: const Key('planner-income'),
          ),
          const Divider(height: AppSpacing.xl),
          _Row(
            icon: plan.isLoss ? Icons.trending_down_rounded : Icons.trending_up_rounded,
            label: plan.isLoss ? l10n.plannerLoss : l10n.plannerProfit,
            value: Fmt.rsWhole(profit),
            valueKey: const Key('planner-profit'),
            valueStyle: text.titleLarge?.copyWith(color: profitColor),
            iconColor: profitColor,
          ),
          _Row(
            icon: Icons.balance_rounded,
            label: l10n.plannerBreakEven,
            value: Fmt.perKg(plan.breakEvenPerKg),
          ),
          if (footer != null) ...[const SizedBox(height: AppSpacing.sm), footer!],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    this.valueKey,
    this.valueStyle,
    this.iconColor = AppColors.green600,
    this.bold = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Key? valueKey;
  final TextStyle? valueStyle;
  final Color iconColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: text.bodyMedium)),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              key: valueKey,
              textAlign: TextAlign.end,
              style: valueStyle ?? (bold ? text.titleMedium : text.titleSmall),
            ),
          ),
        ],
      ),
    );
  }
}
