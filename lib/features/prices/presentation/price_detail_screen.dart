import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/l10n/crop_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../registration/domain/bucket_rules.dart';
import '../../registration/domain/bucket_status.dart';
import '../../registration/presentation/controllers/bucket_controller.dart';
import '../../registration/presentation/widgets/key_value_row.dart';
import '../../registration/presentation/widgets/quota_bar.dart';
import '../../registration/presentation/widgets/refreshable_async.dart';
import '../domain/price_forecast.dart';
import '../domain/price_series.dart';
import 'controllers/prices_controller.dart';
import 'widgets/best_month_card.dart';
import 'widgets/price_change_badge.dart';
import 'widgets/price_trend_chart.dart';

/// Price Detail (spec §11.30): this month's price, the trend chart, the best
/// month to harvest, costs, the national quota and the model's inputs.
class PriceDetailScreen extends ConsumerStatefulWidget {
  const PriceDetailScreen({super.key, required this.cropName});

  /// Database crop key.
  final String cropName;

  @override
  ConsumerState<PriceDetailScreen> createState() => _PriceDetailScreenState();
}

class _PriceDetailScreenState extends ConsumerState<PriceDetailScreen> {
  late final String _crop = cropKey(widget.cropName);

  @override
  void initState() {
    super.initState();
    ref.read(analyticsProvider).track(AnalyticsEvents.priceViewed, {'crop': _crop});
  }

  Future<void> _refresh() async {
    refreshPrices(ref, crop: _crop);
    ref.invalidate(bucketStatusProvider);
    try {
      await ref.read(priceSeriesProvider(_crop).future);
    } catch (_) {
      // The error state is shown by the list.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeTag;
    final label = CropLabels.of(context, _crop);
    final seriesAsync = ref.watch(priceSeriesProvider(_crop));
    final bucket = ref.watch(bucketForCropProvider(_crop));
    final level = bucket == null ? null : ref.watch(surplusThresholdsProvider).levelOf(bucket);

    return AppScaffold(
      title: label,
      subtitle: l10n.pricesTitle,
      body: RefreshableAsync<PriceSeries>(
        value: seriesAsync,
        onRefresh: _refresh,
        isEmpty: (series) => series.isEmpty,
        empty: EmptyState(
          icon: Icons.show_chart_rounded,
          title: l10n.pricesNotFoundTitle,
          message: l10n.pricesNotFoundBody(label),
        ),
        builder: (series) {
          final best = series.bestMonth;
          final reference = series.reference;
          final askMonth = best?.harvestDate ?? addMonths(series.thisMonth, 1);
          return [
            _HeroCard(series: series),
            const SizedBox(height: AppSpacing.lg),
            SectionCard(
              title: l10n.pricesTrendTitle,
              subtitle: l10n.pricesTrendSubtitle,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: PriceTrendChart(series: series),
            ),
            if (best != null) ...[
              const SizedBox(height: AppSpacing.lg),
              BestMonthCard(best: best),
            ],
            if (reference != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _CostCard(forecast: reference),
            ],
            if (bucket != null && level != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _QuotaCard(bucket: bucket, level: level),
            ],
            if (reference != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _WhyCard(forecast: reference, series: series),
            ],
            const SizedBox(height: AppSpacing.lg),
            SecondaryButton(
              label: l10n.pricesAskBot,
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: () => context.push(
                Routes.chatWith(l10n.pricesAskPrompt(label, Fmt.monthYear(askMonth, locale))),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.pricesFooterNote,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
          ];
        },
      ),
    );
  }
}

/// This month's wholesale price, change badge and estimated retail price.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.series});

  final PriceSeries series;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = context.localeTag;
    final pending = series.forecastPending;
    final actualMonth = series.latestActual?.date;
    final retail = series.current?.retailPrice;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CropAvatar(series.crop),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  pending && actualMonth != null
                      ? l10n.pricesLatestActual(Fmt.monthYear(actualMonth, locale))
                      : l10n.pricesThisMonth,
                  style: text.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              Fmt.perKg(series.currentPrice),
              key: const Key('price-hero'),
              style: text.displaySmall?.copyWith(fontSize: 34),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PriceChangeBadge(changePct: series.changePct),
              Text(l10n.pricesVsLastMonth, style: text.bodySmall),
            ],
          ),
          if (retail != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.pricesRetail(Fmt.perKg(retail)), style: text.bodyMedium),
          ],
          if (pending || series.isStale) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                if (pending)
                  TagChip(
                    l10n.pricesForecastPending,
                    color: AppColors.ink500,
                    icon: Icons.hourglass_empty_rounded,
                  ),
                if (series.isStale)
                  TagChip(
                    l10n.pricesStale,
                    color: AppColors.orange600,
                    icon: Icons.history_toggle_off_rounded,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Cost per kg, fair price, profit per kg and the minimum floor price.
class _CostCard extends StatelessWidget {
  const _CostCard({required this.forecast});

  final PriceForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profit = forecast.profitPerKg ?? forecast.marginPerKg;
    return SectionCard(
      title: l10n.pricesCostTitle,
      subtitle: Fmt.monthYear(forecast.harvestDate, context.localeTag),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KeyValueRow(label: l10n.pricesCostPerKg, value: Fmt.perKg(forecast.costPerKg)),
          KeyValueRow(label: l10n.pricesFairPrice, value: Fmt.perKg(forecast.fairPrice)),
          KeyValueRow(
            label: l10n.pricesProfitPerKg,
            value: Fmt.perKg(profit),
            valueColor: profit == null
                ? null
                : (profit >= 0 ? AppColors.green600 : AppColors.red600),
          ),
          KeyValueRow(label: l10n.pricesFloorPrice, value: Fmt.perKg(forecast.floorPrice)),
        ],
      ),
    );
  }
}

/// National quota for the crop, when an active target exists.
class _QuotaCard extends StatelessWidget {
  const _QuotaCard({required this.bucket, required this.level});

  final BucketStatus bucket;
  final SurplusLevel level;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.pricesQuotaTitle,
      trailing: SurplusChip(level),
      onTap: () => context.push(Routes.outlookCrop(bucket.key)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          QuotaBar(bucket: bucket, level: level),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.pricesQuotaOpen,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.green600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.green600),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Why this price?" — the inputs the model used (spec §11.30 item 6).
class _WhyCard extends StatelessWidget {
  const _WhyCard({required this.forecast, required this.series});

  final PriceForecast forecast;
  final PriceSeries series;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final cycle = forecast.growthCycleMonths;
    final version = forecast.modelVersion.trim();
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Theme(
        // No divider lines around the tile inside the card.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.help_outline_rounded, color: AppColors.green600),
          title: Text(l10n.pricesWhyTitle, style: text.titleMedium),
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          children: [
            Text(l10n.pricesWhyIntro, style: text.bodySmall),
            const SizedBox(height: AppSpacing.sm),
            if (forecast.rainfallMm != null)
              KeyValueRow(
                label: l10n.pricesWhyRainfall,
                value: l10n.pricesWhyRainfallValue(Fmt.amount(forecast.rainfallMm)),
              ),
            KeyValueRow(
              label: l10n.pricesWhyWeather,
              value: forecast.weatherShock ? l10n.pricesWhyWeatherApplied : l10n.pricesWhyWeatherNone,
              valueColor: forecast.weatherShock ? AppColors.orange600 : null,
            ),
            if (forecast.dieselLkr != null)
              KeyValueRow(label: l10n.pricesWhyDiesel, value: Fmt.rs(forecast.dieselLkr)),
            if (forecast.transportIndex != null)
              KeyValueRow(
                label: l10n.pricesWhyTransport,
                value: Fmt.amount(forecast.transportIndex),
              ),
            if (cycle != null)
              KeyValueRow(label: l10n.pricesWhyCycle, value: l10n.pricesWhyCycleValue(cycle)),
            if (version.isNotEmpty) KeyValueRow(label: l10n.pricesWhyModel, value: version),
            if (series.generatedAt != null)
              KeyValueRow(
                label: l10n.pricesWhyGenerated,
                value: Fmt.date(series.generatedAt, context.localeTag),
              ),
          ],
        ),
      ),
    );
  }
}
