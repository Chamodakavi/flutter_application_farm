import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/bucket_rules.dart';
import '../../domain/bucket_status.dart';
import 'quota_bar.dart';

/// One crop on Crop Outlook: name, level chip, `filled / limit MT` bar,
/// remaining, fair price and harvest window (spec §11.12).
class BucketCard extends StatelessWidget {
  const BucketCard({super.key, required this.bucket, required this.level, this.onTap});

  final BucketStatus bucket;
  final SurplusLevel level;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final label = CropLabels.of(context, bucket.cropName);
    final english = CropLabels.english(bucket.cropName);
    final harvest = bucket.harvestLabel(context.localeTag);

    return SectionCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CropAvatar(bucket.cropName),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (english != label) Text(english, style: text.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: SurplusChip(level)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          QuotaBar(bucket: bucket, level: level),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              if (bucket.fairPrice != null)
                _Fact(
                  icon: Icons.sell_outlined,
                  text: l10n.outlookFairPriceLine(Fmt.perKg(bucket.fairPrice)),
                ),
              if (harvest != null)
                _Fact(icon: Icons.event_outlined, text: l10n.outlookHarvestWindow(harvest)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: AppColors.ink500),
      const SizedBox(width: AppSpacing.xs),
      Flexible(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
    ],
  );
}
