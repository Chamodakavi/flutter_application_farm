import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../domain/weather.dart';

/// Icon and localized name for a condition (spec §15).
extension WeatherConditionUi on WeatherCondition {
  IconData get icon => switch (this) {
    WeatherCondition.clear => Icons.wb_sunny_rounded,
    WeatherCondition.partlyCloudy => Icons.wb_cloudy_rounded,
    WeatherCondition.cloudy => Icons.cloud_rounded,
    WeatherCondition.fog => Icons.foggy,
    WeatherCondition.drizzle => Icons.grain_rounded,
    WeatherCondition.rain => Icons.water_drop_rounded,
    WeatherCondition.showers => Icons.umbrella_rounded,
    WeatherCondition.snow => Icons.ac_unit_rounded,
    WeatherCondition.thunderstorm => Icons.thunderstorm_rounded,
    WeatherCondition.unknown => Icons.wb_sunny_outlined,
  };

  String label(AppLocalizations l10n) => switch (this) {
    WeatherCondition.clear => l10n.weatherCondClear,
    WeatherCondition.partlyCloudy => l10n.weatherCondPartlyCloudy,
    WeatherCondition.cloudy => l10n.weatherCondCloudy,
    WeatherCondition.fog => l10n.weatherCondFog,
    WeatherCondition.drizzle => l10n.weatherCondDrizzle,
    WeatherCondition.rain => l10n.weatherCondRain,
    WeatherCondition.showers => l10n.weatherCondShowers,
    WeatherCondition.snow => l10n.weatherCondSnow,
    WeatherCondition.thunderstorm => l10n.weatherCondThunderstorm,
    WeatherCondition.unknown => l10n.weatherCondUnknown,
  };
}

/// Localized field-work advice: a short line for cards and a longer reason.
extension WeatherAdviceUi on WeatherAdvice {
  String title(AppLocalizations l10n) => switch (kind) {
    WeatherAdviceKind.avoidSpraying => l10n.weatherAdviceAvoidSpraying,
    WeatherAdviceKind.irrigateEarly => l10n.weatherAdviceIrrigate,
    WeatherAdviceKind.goodFieldDay => l10n.weatherAdviceGood,
  };

  String detail(AppLocalizations l10n) => switch (kind) {
    WeatherAdviceKind.avoidSpraying => l10n.weatherAdviceAvoidSprayingDetail,
    WeatherAdviceKind.irrigateEarly => l10n.weatherAdviceIrrigateDetail,
    WeatherAdviceKind.goodFieldDay => l10n.weatherAdviceGoodDetail,
  };

  IconData get icon => switch (kind) {
    WeatherAdviceKind.avoidSpraying => Icons.umbrella_rounded,
    WeatherAdviceKind.irrigateEarly => Icons.water_drop_rounded,
    WeatherAdviceKind.goodFieldDay => Icons.agriculture_rounded,
  };
}

/// `29°C`, rounded to a whole degree.
String formatTemperature(AppLocalizations l10n, double celsius) =>
    l10n.weatherTemp(celsius.round().toString());
