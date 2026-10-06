import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/price_series.dart';
import 'price_change_badge.dart';
import 'sparkline.dart';

/// One crop on the Crop Prices list: icon and name, this month's wholesale
/// price, change vs. last month, six-month sparkline and the fair-price chip
/// (spec §11.29).
class PriceListTile extends StatelessWidget {
  const PriceListTile({super.key, required this.summary, this.onTap});

  final PriceSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final label = CropLabels.of(context, summary.cropName);
    final english = CropLabels.english(summary.cropName);
    final aboveFair = summary.aboveFair;

    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CropAvatar(summary.cropName),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (english != label)
                      Text(english, style: text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Sparkline(values: summary.sparkline),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Price, change and chips share one line when they fit and wrap
          // when they do not (long translations, large fonts).
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(Fmt.perKg(summary.price), style: text.titleMedium),
              PriceChangeBadge(changePct: summary.changePct),
              if (summary.forecastPending)
                TagChip(
                  l10n.pricesForecastPending,
                  color: AppColors.ink500,
                  icon: Icons.hourglass_empty_rounded,
                ),
              if (aboveFair != null)
                TagChip(
                  aboveFair ? l10n.pricesAboveFair : l10n.pricesBelowFair,
                  color: aboveFair ? AppColors.green600 : AppColors.orange500,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
