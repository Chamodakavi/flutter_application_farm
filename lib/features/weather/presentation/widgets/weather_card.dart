import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/weather.dart';
import '../controllers/weather_controller.dart';
import 'weather_condition_ui.dart';

/// Weather stat card for the dashboard grid; opens the Weather screen.
///
/// Self-contained: it loads the forecast itself and shows `—` when that
/// fails, so a weather problem never blanks the dashboard (spec §11.8).
class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(weatherProvider);
    final weather = state.value;

    return StatCard(
      title: l10n.weatherTitle,
      value: weather == null ? '—' : formatTemperature(l10n, weather.current.temperatureC),
      caption: weather != null
          ? WeatherAdvice.from(weather).title(l10n)
          : (state.hasError ? l10n.weatherCardUnavailable : null),
      icon: weather?.current.condition.icon ?? Icons.wb_sunny_rounded,
      iconColor: AppColors.orange500,
      tint: AppColors.weatherTint,
      loading: weather == null && state.isLoading,
      onTap: () => context.push(Routes.weather),
    );
  }
}
