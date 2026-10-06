import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/district_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/weather.dart';
import 'controllers/weather_controller.dart';
import 'widgets/hourly_rain_chart.dart';
import 'widgets/weather_condition_ui.dart';

/// Current conditions, field-work advice, hourly rain and the 7-day forecast
/// for the user's district (spec §11.9, §15).
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final district = ref.watch(weatherDistrictProvider);
    final state = ref.watch(weatherProvider);
    final updatedAt = ref.watch(weatherUpdatedAtProvider);

    Future<void> refresh() async {
      try {
        await ref.read(weatherProvider.notifier).refresh();
      } catch (e) {
        if (context.mounted) context.showError(e);
      }
    }

    return AppScaffold(
      title: l10n.weatherTitle,
      subtitle: district.label(context.localeTag),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: AsyncValueView<Weather>(
          value: state,
          loading: const ShimmerList(itemCount: 4, itemHeight: 140),
          // Scrollable, so pull-to-refresh also works on the error state.
          error: (e) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [ErrorState(error: e, onRetry: () => ref.invalidate(weatherProvider))],
          ),
          data: (weather) =>
              _WeatherBody(weather: weather, district: district, updatedAt: updatedAt),
        ),
      ),
    );
  }
}

class _WeatherBody extends StatelessWidget {
  const _WeatherBody({required this.weather, required this.district, this.updatedAt});

  final Weather weather;
  final District district;
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final now = Weather.colomboNow();
    final hours = weather.hourlyFrom(now);
    final advice = WeatherAdvice.from(weather);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.page,
      children: [
        _CurrentCard(weather: weather, place: district.label(context.localeTag)),
        AppSpacing.gapMd,
        _AdviceCard(advice: advice),
        AppSpacing.gapMd,
        SectionCard(
          title: l10n.weatherHourlyTitle,
          child: hours.isEmpty
              ? Text(l10n.weatherHourlyEmpty, style: text.bodyMedium)
              : HourlyRainChart(hours: hours),
        ),
        AppSpacing.gapMd,
        SectionCard(
          title: l10n.weatherDailyTitle,
          child: weather.daily.isEmpty
              ? Text(l10n.weatherDailyEmpty, style: text.bodyMedium)
              : Column(
                  children: [
                    for (final (i, day) in weather.daily.indexed) ...[
                      if (i > 0) const Divider(height: AppSpacing.lg),
                      _DailyRow(day: day, isToday: DateUtils.isSameDay(day.date, now)),
                    ],
                  ],
                ),
        ),
        AppSpacing.gapMd,
        InfoNote(
          icon: Icons.place_outlined,
          text: l10n.weatherLocationHint,
          actionLabel: l10n.weatherChangeDistrict,
          onAction: () => context.push(Routes.settingsAccount),
        ),
        AppSpacing.gapMd,
        Text(
          [
            if (updatedAt != null) l10n.commonUpdatedAgo(context.relativeTime(updatedAt)),
            l10n.weatherSource,
          ].join(' · '),
          style: text.bodySmall,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapLg,
      ],
    );
  }
}

/// Big temperature with the condition, then humidity, wind and rain chance.
class _CurrentCard extends StatelessWidget {
  const _CurrentCard({required this.weather, required this.place});

  final Weather weather;
  final String place;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final current = weather.current;
    final condition = current.condition;

    return SectionCard(
      color: AppColors.weatherTint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                condition.icon,
                size: 56,
                color: condition.isWet ? AppColors.blue600 : AppColors.orange500,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatTemperature(l10n, current.temperatureC),
                      style: text.displaySmall?.copyWith(fontSize: 40, height: 1.1),
                    ),
                    Text(condition.label(l10n), style: text.titleSmall),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 14, color: AppColors.ink500),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(child: Text(place, style: text.bodySmall)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Metric(
                  icon: Icons.opacity_rounded,
                  label: l10n.weatherHumidity,
                  value: Fmt.percent(current.humidityPercent),
                ),
              ),
              Expanded(
                child: _Metric(
                  icon: Icons.air_rounded,
                  label: l10n.weatherWind,
                  value: current.windSpeedKmh == null
                      ? '—'
                      : l10n.weatherWindValue(current.windSpeedKmh!.round().toString()),
                ),
              ),
              Expanded(
                child: _Metric(
                  icon: Icons.umbrella_rounded,
                  label: l10n.weatherRainChance,
                  value: Fmt.percent(weather.rainProbabilityToday),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The rule-based advice with its reason, coloured by urgency.
class _AdviceCard extends StatelessWidget {
  const _AdviceCard({required this.advice});

  final WeatherAdvice advice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final (Color tint, Color color) = switch (advice.kind) {
      WeatherAdviceKind.avoidSpraying => (AppColors.weatherTint, AppColors.orange600),
      WeatherAdviceKind.irrigateEarly => (AppColors.blue100, AppColors.blue600),
      WeatherAdviceKind.goodFieldDay => (AppColors.green100, AppColors.green600),
    };

    return SectionCard(
      title: l10n.weatherAdviceTitle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            child: Icon(advice.icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(advice.title(l10n), style: text.titleSmall),
                const SizedBox(height: 2),
                Text(
                  advice.detail(l10n),
                  style: text.bodyMedium?.copyWith(color: AppColors.ink500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.forest900),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: text.titleSmall, textAlign: TextAlign.center),
          Text(label, style: text.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// One day: weekday, condition, high / low and the chance of rain.
class _DailyRow extends StatelessWidget {
  const _DailyRow({required this.day, required this.isToday});

  final DailyForecast day;
  final bool isToday;

  String _degrees(double? v) => v == null ? '—' : v.round().toString();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final condition = day.condition;
    final date = DateFormat('EEE d MMM', context.localeTag).format(day.date);

    return Row(
      children: [
        Icon(
          condition.icon,
          size: 28,
          color: condition.isWet ? AppColors.blue600 : AppColors.orange500,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isToday ? l10n.weatherToday : date, style: text.titleSmall),
              Text(condition.label(l10n), style: text.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              l10n.weatherHighLow(_degrees(day.tempMaxC), _degrees(day.tempMinC)),
              style: text.titleSmall,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop_outlined, size: 14, color: AppColors.blue600),
                const SizedBox(width: 2),
                Text(Fmt.percent(day.rainProbability), style: text.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
