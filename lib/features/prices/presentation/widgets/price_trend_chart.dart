import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/price_forecast.dart';
import '../../domain/price_series.dart';

/// Price trend of one crop (spec §11.30): solid line = actual prices of the
/// last 24 months, dashed line = model forecast for the next 12, shaded band
/// between the floor and the fair price, and a vertical "today" marker. Tap a
/// point for the month, the price and whether it is actual or forecast.
class PriceTrendChart extends StatelessWidget {
  const PriceTrendChart({super.key, required this.series, this.height = 240});

  final PriceSeries series;
  final double height;

  static const _actualColor = AppColors.forest800;
  static const _forecastColor = AppColors.orange600;
  static const _bandColor = AppColors.green500;

  static int _monthIndex(DateTime d) => d.year * 12 + d.month - 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final locale = context.localeTag;

    final firstShown = addMonths(series.thisMonth, -24);
    final history = series.history.where((p) => !p.date.isBefore(firstShown)).toList();
    final List<PriceForecast> forecast = series.upcoming;

    // A line needs two different months.
    final months = {
      for (final p in history) _monthIndex(p.date),
      for (final f in forecast) _monthIndex(f.harvestDate),
    };
    if (months.length < 2) {
      return SizedBox(
        height: height / 2,
        child: Center(
          child: Text(l10n.pricesChartEmpty, style: text.bodyMedium, textAlign: TextAlign.center),
        ),
      );
    }

    final origin = math.min(
      history.isEmpty ? _monthIndex(forecast.first.harvestDate) : _monthIndex(history.first.date),
      forecast.isEmpty ? _monthIndex(history.first.date) : _monthIndex(forecast.first.harvestDate),
    );
    double x(DateTime d) => (_monthIndex(d) - origin).toDouble();
    DateTime monthAt(double value) {
      final index = origin + value.round();
      return DateTime(index ~/ 12, index % 12 + 1);
    }

    final actualSpots = [for (final p in history) FlSpot(x(p.date), p.price)];
    final forecastSpots = [for (final f in forecast) FlSpot(x(f.harvestDate), f.wholesalePrice)];

    // Join the two lines so the forecast visibly continues the actual price.
    final bridged =
        actualSpots.isNotEmpty && forecastSpots.isNotEmpty && actualSpots.last.x < forecastSpots.first.x;
    if (bridged) forecastSpots.insert(0, actualSpots.last);

    final banded = forecast.where((f) => f.floorPrice != null && f.fairPrice != null).toList();
    final floorSpots = [for (final f in banded) FlSpot(x(f.harvestDate), f.floorPrice!)];
    final fairSpots = [for (final f in banded) FlSpot(x(f.harvestDate), f.fairPrice!)];
    final showBand = banded.length >= 2;

    final values = [
      ...actualSpots.map((s) => s.y),
      ...forecastSpots.map((s) => s.y),
      if (showBand) ...floorSpots.map((s) => s.y),
      if (showBand) ...fairSpots.map((s) => s.y),
    ];
    final lowest = values.reduce(math.min), highest = values.reduce(math.max);
    final pad = math.max((highest - lowest) * 0.12, highest * 0.05 + 1);
    final minY = math.max(0.0, lowest - pad);
    final maxY = highest + pad;

    final lastX = math.max(
      actualSpots.isEmpty ? 0.0 : actualSpots.last.x,
      forecastSpots.isEmpty ? 0.0 : forecastSpots.last.x,
    );
    final daysInMonth = DateUtils.getDaysInMonth(series.now.year, series.now.month);
    final todayX = x(series.thisMonth) + (series.now.day - 1) / daysInMonth;
    final showToday = todayX >= 0 && todayX <= lastX;
    final labelEvery = math.max(1, (lastX / 4).ceil()).toDouble();

    const actualBar = 0, forecastBar = 1, floorBar = 2, fairBar = 3;
    final bars = [
      LineChartBarData(
        spots: actualSpots,
        color: _actualColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: actualSpots.length == 1),
      ),
      LineChartBarData(
        spots: forecastSpots,
        color: _forecastColor,
        barWidth: 3,
        dashArray: const [7, 5],
        dotData: FlDotData(show: forecastSpots.length == 1),
      ),
      if (showBand) ...[
        LineChartBarData(spots: floorSpots, show: false),
        LineChartBarData(spots: fairSpots, show: false),
      ],
    ];

    final labelStyle = text.bodySmall?.copyWith(fontSize: 10, height: 1.1);
    final tooltipStyle = text.bodySmall!.copyWith(color: AppColors.white, height: 1.3);

    final chart = LineChart(
      LineChartData(
        minX: 0,
        maxX: lastX,
        minY: minY,
        maxY: maxY,
        lineBarsData: bars,
        betweenBarsData: [
          if (showBand)
            BetweenBarsData(
              fromIndex: floorBar,
              toIndex: fairBar,
              color: _bandColor.withValues(alpha: 0.16),
            ),
        ],
        extraLinesData: ExtraLinesData(
          verticalLines: [
            if (showToday)
              VerticalLine(
                x: todayX,
                color: AppColors.ink500,
                strokeWidth: 1.5,
                dashArray: const [3, 3],
                label: VerticalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  style: labelStyle?.copyWith(color: AppColors.ink500, fontWeight: FontWeight.w600),
                  labelResolver: (_) => l10n.pricesToday,
                ),
              ),
          ],
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.line200, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              minIncluded: false,
              maxIncluded: false,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(Fmt.amount(value.round()), style: labelStyle),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              interval: labelEvery,
              getTitlesWidget: (value, meta) {
                if (value != value.roundToDouble()) return const SizedBox.shrink();
                return SideTitleWidget(
                  meta: meta,
                  space: 6,
                  fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                  child: Text(Fmt.monthShort(monthAt(value), locale), style: labelStyle),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            maxContentWidth: 160,
            getTooltipColor: (_) => AppColors.forest900,
            getTooltipItems: (spots) => [
              for (final spot in spots)
                // The bridge point belongs to the actual line: say it once.
                if (spot.barIndex == forecastBar && bridged && spot.spotIndex == 0)
                  null
                else
                  LineTooltipItem(
                    '${Fmt.monthYear(monthAt(spot.x), locale)}\n'
                    '${Fmt.perKg(spot.y)}\n'
                    '${spot.barIndex == actualBar ? l10n.pricesLegendActual : l10n.pricesLegendForecast}',
                    tooltipStyle,
                  ),
            ],
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: l10n.pricesTrendTitle,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm, top: AppSpacing.sm),
              child: chart,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            _LegendItem(label: l10n.pricesLegendActual, color: _actualColor),
            _LegendItem(label: l10n.pricesLegendForecast, color: _forecastColor, dashed: true),
            if (showBand)
              _LegendItem(
                label: l10n.pricesLegendBand,
                color: _bandColor.withValues(alpha: 0.3),
                band: true,
              ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    this.dashed = false,
    this.band = false,
  });

  final String label;
  final Color color;
  final bool dashed;
  final bool band;

  @override
  Widget build(BuildContext context) {
    Widget dash(double width) => Container(width: width, height: 3, color: color);
    final Widget swatch = band
        ? Container(width: 22, height: 10, color: color)
        : dashed
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [dash(6), const SizedBox(width: 3), dash(6), const SizedBox(width: 3), dash(4)],
          )
        : dash(22);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}
