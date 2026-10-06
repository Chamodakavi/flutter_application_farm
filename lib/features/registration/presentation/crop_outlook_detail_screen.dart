import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/crop_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/bucket_rules.dart';
import '../domain/bucket_status.dart';
import 'controllers/bucket_controller.dart';
import 'widgets/bucket_live_scope.dart';
import 'widgets/key_value_row.dart';
import 'widgets/refreshable_async.dart';

/// One crop's national bucket in detail (spec §11.12): gauge, quota numbers,
/// dates, allowed extent, fair vs. wholesale price, and the next steps.
class CropOutlookDetailScreen extends ConsumerWidget {
  const CropOutlookDetailScreen({super.key, required this.cropName});

  /// Database crop key (also the target of surplus push notifications).
  final String cropName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = context.localeTag;
    final key = cropName.trim().toUpperCase();
    final label = CropLabels.of(context, key);
    final bucketAsync = ref.watch(bucketStatusProvider);
    final thresholds = ref.watch(surplusThresholdsProvider);

    Future<void> refresh() async {
      ref.invalidate(bucketStatusProvider);
      try {
        await ref.read(bucketStatusProvider.future);
      } catch (_) {
        // The error state is shown by the list.
      }
    }

    return AppScaffold(
      title: label,
      subtitle: l10n.outlookTitle,
      body: BucketLiveScope(
        child: RefreshableAsync<List<BucketStatus>>(
          value: bucketAsync,
          onRefresh: refresh,
          isEmpty: (all) => bucketFor(all, key) == null,
          empty: EmptyState(
            icon: Icons.inventory_2_outlined,
            title: l10n.outlookNotFoundTitle,
            message: l10n.outlookNotFoundBody(label),
            actionLabel: l10n.outlookSeeAll,
            onAction: () => context.pushReplacement(Routes.outlook),
          ),
          builder: (all) {
            final bucket = bucketFor(all, key)!;
            final level = thresholds.levelOf(bucket);
            final planting = bucket.plantingLabel(locale);
            final harvest = bucket.harvestLabel(locale);
            final full = level == SurplusLevel.full;
            return [
              _GaugeCard(bucket: bucket, level: level),
              const SizedBox(height: AppSpacing.lg),
              SectionCard(
                title: l10n.outlookNumbers,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyValueRow(label: l10n.registerLimit, value: Fmt.mt(bucket.limitMt)),
                    KeyValueRow(label: l10n.registerFilled, value: Fmt.mt(bucket.filledMt)),
                    KeyValueRow(
                      label: l10n.registerRemaining,
                      value: Fmt.mt(bucket.roomMt),
                      valueColor: level.color,
                    ),
                    if (bucket.allowedExtentHa != null)
                      KeyValueRow(
                        label: l10n.outlookAllowedExtent,
                        value: l10n.outlookHectares(Fmt.amount(bucket.allowedExtentHa)),
                      ),
                    if (planting != null)
                      KeyValueRow(label: l10n.registerPlantingDate, value: planting),
                    if (harvest != null)
                      KeyValueRow(label: l10n.registerHarvestDate, value: harvest),
                  ],
                ),
              ),
              if (bucket.fairPrice != null || bucket.wholesalePrice != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _PriceCompareCard(bucket: bucket),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (full) ...[
                InfoNote(tone: InfoNoteTone.danger, text: l10n.outlookFullNote),
                const SizedBox(height: AppSpacing.md),
              ],
              PrimaryButton(
                label: l10n.outlookRegisterCta,
                icon: Icons.verified_outlined,
                // Register is a bottom-navigation tab: switch to it.
                onPressed: full ? null : () => context.go(Routes.registerWith(crop: key)),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: l10n.outlookAskBot(label),
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () => context.push(Routes.chatWith(l10n.outlookAskPrompt(label))),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({required this.bucket, required this.level});

  final BucketStatus bucket;
  final SurplusLevel level;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return SectionCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CropAvatar(bucket.cropName),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(CropLabels.of(context, bucket.cropName), style: text.titleLarge),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: SurplusChip(level)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) => QuotaGauge(
              ratio: bucket.fillRatio,
              level: level,
              size: math.min(240, constraints.maxWidth),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.quotaFilledOfLimit(Fmt.amount(bucket.filledMt), Fmt.amount(bucket.limitMt)),
            style: text.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            l10n.quotaRemaining(Fmt.amount(bucket.roomMt)),
            style: text.titleSmall?.copyWith(color: level.color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.registerFarmerCount(bucket.farmerCount),
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Fair price next to the estimated wholesale price as two bars on one scale.
class _PriceCompareCard extends StatelessWidget {
  const _PriceCompareCard({required this.bucket});

  final BucketStatus bucket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fair = bucket.fairPrice, wholesale = bucket.wholesalePrice;
    final top = math.max(fair ?? 0, wholesale ?? 0);
    return SectionCard(
      title: l10n.outlookPriceCompare,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fair != null)
            _PriceBar(
              label: l10n.registerFairPrice,
              value: fair,
              fraction: top <= 0 ? 0 : fair / top,
              color: AppColors.green600,
            ),
          if (fair != null && wholesale != null) const SizedBox(height: AppSpacing.md),
          if (wholesale != null)
            _PriceBar(
              label: l10n.registerWholesale,
              value: wholesale,
              fraction: top <= 0 ? 0 : wholesale / top,
              color: AppColors.orange500,
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => context.push(Routes.priceDetail(bucket.key)),
              icon: const Icon(Icons.show_chart_rounded, size: 18),
              label: Text(l10n.registerSeeTrend),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBar extends StatelessWidget {
  const _PriceBar({
    required this.label,
    required this.value,
    required this.fraction,
    required this.color,
  });

  final String label;
  final double value;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: text.bodyMedium)),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(Fmt.perKg(value), style: text.titleSmall, textAlign: TextAlign.end),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadii.pillBorder,
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1).toDouble(),
            minHeight: 12,
            color: color,
            backgroundColor: AppColors.line200,
          ),
        ),
      ],
    );
  }
}
