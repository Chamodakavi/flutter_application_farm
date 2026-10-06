import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/price_forecast.dart';

/// `yyyy-MM` — the month format of the planner route.
String plannerMonthParam(DateTime month) =>
    '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';

/// The forecast month with the highest margin, when to plant for it, and the
/// two next steps: register the crop or plan the profit (spec §11.30).
class BestMonthCard extends StatelessWidget {
  const BestMonthCard({super.key, required this.best});

  final PriceForecast best;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = context.localeTag;
    final margin = best.marginPerKg ?? best.profitPerKg;
    final planting = best.plantingDate;

    return SectionCard(
      color: AppColors.cream50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.orange500),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(l10n.pricesBestMonthTitle, style: text.labelMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(Fmt.monthYear(best.harvestDate, locale), style: text.displaySmall),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(Fmt.perKg(best.wholesalePrice), style: text.titleMedium),
              if (margin != null)
                Text(
                  l10n.pricesBestMonthProfit(Fmt.perKg(margin)),
                  style: text.titleSmall?.copyWith(
                    color: margin >= 0 ? AppColors.green600 : AppColors.red600,
                  ),
                ),
            ],
          ),
          if (planting != null) ...[
            const SizedBox(height: AppSpacing.md),
            InfoNote(
              tone: InfoNoteTone.success,
              icon: Icons.event_available_rounded,
              text: l10n.pricesPlantToHarvest(
                Fmt.monthYear(planting, locale),
                Fmt.monthYear(best.harvestDate, locale),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: l10n.pricesRegisterCrop,
            icon: Icons.verified_outlined,
            // Register is a bottom-navigation tab: switch to it.
            onPressed: () => context.go(Routes.registerWith(crop: best.cropName)),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: l10n.pricesPlanProfit,
            icon: Icons.calculate_outlined,
            onPressed: () => context.push(
              Routes.plannerWith(crop: best.cropName, month: plannerMonthParam(best.harvestDate)),
            ),
          ),
        ],
      ),
    );
  }
}
