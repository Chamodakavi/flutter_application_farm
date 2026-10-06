/// Weather for one district, parsed from Open-Meteo (spec §15). Plain
/// immutable classes — no code generation.
library;

/// Coarse condition derived from a WMO `weather_code`.
enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  fog,
  drizzle,
  rain,
  showers,
  snow,
  thunderstorm,
  unknown;

  /// WMO 4677 codes as used by Open-Meteo. Unknown codes never throw.
  static WeatherCondition fromWmo(int? code) => switch (code) {
    0 || 1 => clear,
    2 => partlyCloudy,
    3 => cloudy,
    45 || 48 => fog,
    51 || 53 || 55 || 56 || 57 => drizzle,
    61 || 63 || 65 || 66 || 67 => rain,
    71 || 73 || 75 || 77 || 85 || 86 => snow,
    80 || 81 || 82 => showers,
    95 || 96 || 99 => thunderstorm,
    _ => unknown,
  };

  /// True for conditions that bring rain.
  bool get isWet => switch (this) {
    drizzle || rain || showers || thunderstorm => true,
    _ => false,
  };
}

/// Conditions right now.
class CurrentWeather {
  const CurrentWeather({
    required this.temperatureC,
    this.humidityPercent,
    this.windSpeedKmh,
    this.precipitationMm,
    this.weatherCode,
    this.time,
  });

  final double temperatureC;
  final int? humidityPercent;
  final double? windSpeedKmh;
  final double? precipitationMm;
  final int? weatherCode;

  /// Observation time as Sri Lanka wall-clock time.
  final DateTime? time;

  WeatherCondition get condition => WeatherCondition.fromWmo(weatherCode);
}

/// One day of the 7-day forecast.
class DailyForecast {
  const DailyForecast({
    required this.date,
    this.weatherCode,
    this.tempMaxC,
    this.tempMinC,
    this.rainProbability,
  });

  final DateTime date;
  final int? weatherCode;
  final double? tempMaxC;
  final double? tempMinC;

  /// Highest chance of rain during the day, 0–100.
  final int? rainProbability;

  WeatherCondition get condition => WeatherCondition.fromWmo(weatherCode);
}

/// Chance of rain for one hour.
class HourlyRain {
  const HourlyRain({required this.time, required this.probability});

  /// Start of the hour as Sri Lanka wall-clock time.
  final DateTime time;

  /// 0–100.
  final int probability;
}

class Weather {
  const Weather({required this.current, this.daily = const [], this.hourly = const []});

  /// Parses the `/v1/forecast` response. Only `current.temperature_2m` is
  /// mandatory; missing or short `daily` / `hourly` arrays give empty or
  /// partial lists instead of an error.
  factory Weather.fromOpenMeteo(Map<String, dynamic> json) {
    final current = _map(json['current']);
    final temperature = _double(current['temperature_2m']);
    if (temperature == null) {
      throw const FormatException('Open-Meteo: current.temperature_2m missing');
    }

    final daily = _map(json['daily']);
    final days = _list(daily['time']);
    final dayCodes = _list(daily['weather_code']);
    final dayMax = _list(daily['temperature_2m_max']);
    final dayMin = _list(daily['temperature_2m_min']);
    final dayRain = _list(daily['precipitation_probability_max']);

    final hourly = _map(json['hourly']);
    final hours = _list(hourly['time']);
    final hourRain = _list(hourly['precipitation_probability']);

    return Weather(
      current: CurrentWeather(
        temperatureC: temperature,
        humidityPercent: _int(current['relative_humidity_2m']),
        windSpeedKmh: _double(current['wind_speed_10m']),
        precipitationMm: _double(current['precipitation']),
        weatherCode: _int(current['weather_code']),
        time: _time(current['time']),
      ),
      daily: [
        for (var i = 0; i < days.length; i++)
          if (_time(days[i]) case final date?)
            DailyForecast(
              date: date,
              weatherCode: _int(_at(dayCodes, i)),
              tempMaxC: _double(_at(dayMax, i)),
              tempMinC: _double(_at(dayMin, i)),
              rainProbability: _percent(_at(dayRain, i)),
            ),
      ],
      hourly: [
        for (var i = 0; i < hours.length; i++)
          if (_time(hours[i]) case final time?)
            if (_percent(_at(hourRain, i)) case final probability?)
              HourlyRain(time: time, probability: probability),
      ],
    );
  }

  final CurrentWeather current;

  /// Up to 7 entries, starting today.
  final List<DailyForecast> daily;

  /// Hourly chance of rain, starting at midnight of the first day.
  final List<HourlyRain> hourly;

  /// Today's chance of rain (0–100): the daily maximum, else the highest of
  /// the first 24 hourly values, else null.
  int? get rainProbabilityToday {
    final today = daily.isEmpty ? null : daily.first.rainProbability;
    if (today != null) return today;
    if (hourly.isEmpty) return null;
    return hourly.take(24).map((h) => h.probability).reduce((a, b) => a > b ? a : b);
  }

  /// The next [hours] hourly values from [now] (Sri Lanka wall-clock time, see
  /// [colomboNow]). Falls back to the first [hours] values when the forecast
  /// does not reach [now] (a stale cache).
  List<HourlyRain> hourlyFrom(DateTime now, {int hours = 24}) {
    final start = DateTime(now.year, now.month, now.day, now.hour);
    final upcoming = hourly.where((h) => !h.time.isBefore(start)).take(hours).toList();
    return upcoming.isNotEmpty ? upcoming : hourly.take(hours).toList();
  }

  /// Open-Meteo is asked for `timezone=Asia/Colombo`, so its timestamps are
  /// Sri Lanka wall-clock times without an offset. This gives "now" in the same
  /// form, whatever the phone's time zone is.
  static DateTime colomboNow([DateTime? now]) {
    final t = (now ?? DateTime.now()).toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateTime(t.year, t.month, t.day, t.hour, t.minute);
  }

  static Map<String, dynamic> _map(Object? v) =>
      v is Map ? Map<String, dynamic>.from(v) : const <String, dynamic>{};

  static List<dynamic> _list(Object? v) => v is List ? v : const <dynamic>[];

  static Object? _at(List<dynamic> list, int i) => i < list.length ? list[i] : null;

  static double? _double(Object? v) =>
      v is num ? v.toDouble() : (v is String ? double.tryParse(v) : null);

  static int? _int(Object? v) => _double(v)?.round();

  static int? _percent(Object? v) => _int(v)?.clamp(0, 100);

  static DateTime? _time(Object? v) => v is String ? DateTime.tryParse(v) : null;
}

enum WeatherAdviceKind { avoidSpraying, irrigateEarly, goodFieldDay }

/// Rule-based field-work advice (spec §11.9). Rain is checked before heat:
/// spraying before rain wastes chemicals.
class WeatherAdvice {
  const WeatherAdvice(this.kind);

  /// Strictly above this chance of rain → avoid spraying.
  static const rainThresholdPercent = 60;

  /// Strictly above this temperature → irrigate early morning / evening.
  static const heatThresholdC = 33.0;

  factory WeatherAdvice.from(Weather weather) {
    if ((weather.rainProbabilityToday ?? 0) > rainThresholdPercent) {
      return const WeatherAdvice(WeatherAdviceKind.avoidSpraying);
    }
    if (weather.current.temperatureC > heatThresholdC) {
      return const WeatherAdvice(WeatherAdviceKind.irrigateEarly);
    }
    return const WeatherAdvice(WeatherAdviceKind.goodFieldDay);
  }

  final WeatherAdviceKind kind;

  @override
  bool operator ==(Object other) => other is WeatherAdvice && other.kind == kind;

  @override
  int get hashCode => kind.hashCode;

  @override
  String toString() => 'WeatherAdvice(${kind.name})';
}
