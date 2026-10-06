import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/weather.dart';

/// Chance of rain per hour as bars (0–100%). Hours above the "avoid
/// spraying" threshold are drawn in the full colour, the rest lighter.
class HourlyRainChart extends StatelessWidget {
  const HourlyRainChart({super.key, required this.hours, this.height = 168});

  final List<HourlyRain> hours;
  final double height;

  // Latin digits in every language, like the rest of the app's numbers.
  static final _clock = DateFormat('HH:mm', 'en_US');

  /// A label every [_labelEvery] bars keeps the axis readable on 320 dp.
  static const _labelEvery = 6;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final small = Theme.of(context).textTheme.bodySmall;

    return Semantics(
      label: l10n.weatherHourlyTitle,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Bars shrink with the card so 24 of them always fit.
            final slot = (constraints.maxWidth - 40) / (hours.isEmpty ? 1 : hours.length);
            final barWidth = (slot * 0.6).clamp(3.0, 12.0);
            return BarChart(
              BarChartData(
                minY: 0,
                maxY: 100,
                alignment: BarChartAlignment.spaceBetween,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.line200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 50,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(Fmt.percent(value), style: small),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= hours.length || i % _labelEvery != 0) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                          child: Text(_clock.format(hours[i].time), style: small),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.forest900,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                      l10n.weatherHourlyTooltip(
                        _clock.format(hours[group.x].time),
                        Fmt.percent(rod.toY),
                      ),
                      (small ?? const TextStyle()).copyWith(color: AppColors.white),
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < hours.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: hours[i].probability.toDouble(),
                          width: barWidth,
                          color: hours[i].probability > WeatherAdvice.rainThresholdPercent
                              ? AppColors.blue600
                              : AppColors.blue600.withValues(alpha: 0.4),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
