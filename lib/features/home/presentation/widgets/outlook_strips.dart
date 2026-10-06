import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config_provider.dart';
import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../prices/presentation/widgets/price_change_badge.dart';
import '../../../registration/domain/bucket_status.dart';
import '../controllers/home_controller.dart';

/// Section title with a "See all" link.
class _StripHeader extends StatelessWidget {
  const _StripHeader({required this.title, required this.subtitle, required this.onSeeAll});

  final String title;
  final String subtitle;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleMedium),
              Text(subtitle, style: text.bodySmall),
            ],
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: onSeeAll,
            child: Text(context.l10n.commonSeeAll, textAlign: TextAlign.end),
          ),
        ),
      ],
    );
  }
}

/// Horizontally scrolling cards that take the height of their tallest child,
/// so longer Sinhala/Tamil labels and large text never clip.
class _CardRow extends StatelessWidget {
  const _CardRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    clipBehavior: Clip.none,
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            SizedBox(width: 164, child: child),
          ],
        ],
      ),
    ),
  );
}

class _StripCard extends StatelessWidget {
  const _StripCard({required this.onTap, required this.children});

  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SectionCard(
    onTap: onTap,
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    ),
  );
}

/// Top five crops by quota fill with mini progress bars (mobile addition to
/// the web dashboard — the "national bucket" at a glance).
class CropOutlookStrip extends ConsumerWidget {
  const CropOutlookStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final config = ref.watch(appConfigOrDefaultProvider);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StripHeader(
          title: l10n.homeCropOutlook,
          subtitle: l10n.homeCropOutlookSubtitle,
          onSeeAll: () => context.push(Routes.outlook),
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView<List<BucketStatus>>(
          value: ref.watch(topBucketsProvider),
          compact: true,
          onRetry: () => ref.invalidate(topBucketsProvider),
          loading: const ShimmerScope(child: ShimmerBox(height: 132, radius: AppRadii.card)),
          empty: SectionCard(child: Text(l10n.homeOutlookEmpty, style: text.bodyMedium)),
          data: (buckets) => _CardRow(
            children: [
              for (final b in buckets)
                _StripCard(
                  onTap: () => context.push(Routes.outlookCrop(b.cropName)),
                  children: [
                    Row(
                      children: [
                        CropAvatar(b.cropName, size: 36),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            CropLabels.of(context, b.cropName),
                            style: text.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    QuotaProgressBar(
                      filledMt: b.filledMt,
                      limitMt: b.limitMt,
                      level: _level(b, config.mediumRatio, config.highRatio),
                      showLabels: false,
                      height: 8,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(l10n.homePercentFull(b.fillPercent), style: text.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    SurplusChip(_level(b, config.mediumRatio, config.highRatio)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  SurplusLevel _level(BucketStatus b, double medium, double high) =>
      SurplusLevel.fromRatio(b.fillRatio, medium: medium, high: high);
}

/// Top five crops by price change this month.
class PriceOutlookStrip extends ConsumerWidget {
  const PriceOutlookStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StripHeader(
          title: l10n.homePriceOutlook,
          subtitle: l10n.homePriceOutlookSubtitle,
          onSeeAll: () => context.push(Routes.prices),
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView(
          value: ref.watch(topPriceMoversProvider),
          compact: true,
          onRetry: () => ref.invalidate(topPriceMoversProvider),
          loading: const ShimmerScope(child: ShimmerBox(height: 112, radius: AppRadii.card)),
          empty: SectionCard(child: Text(l10n.homePricesEmpty, style: text.bodyMedium)),
          data: (prices) => _CardRow(
            children: [
              for (final p in prices)
                _StripCard(
                  onTap: () => context.push(Routes.priceDetail(p.cropName)),
                  children: [
                    Row(
                      children: [
                        CropAvatar(p.cropName, size: 36),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            CropLabels.of(context, p.cropName),
                            style: text.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      Fmt.perKg(p.wholesalePrice),
                      style: text.titleMedium?.copyWith(color: AppColors.forest900),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    PriceChangeBadge(changePct: p.change, compact: true),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
