import 'package:farmfriend/features/weather/domain/weather.dart';
import 'package:flutter_test/flutter_test.dart';

import 'weather_sample.dart';

Weather _weather({required double temp, int? rainToday, List<int> hourly = const []}) => Weather(
  current: CurrentWeather(temperatureC: temp),
  daily: [
    if (rainToday != null) DailyForecast(date: DateTime(2026, 10, 5), rainProbability: rainToday),
  ],
  hourly: [
    for (final (i, p) in hourly.indexed)
      HourlyRain(time: DateTime(2026, 10, 5, i), probability: p),
  ],
);

void main() {
  group('WeatherAdvice.from', () {
    test('rain above 60% → avoid spraying', () {
      expect(
        WeatherAdvice.from(_weather(temp: 27, rainToday: 61)).kind,
        WeatherAdviceKind.avoidSpraying,
      );
      expect(
        WeatherAdvice.from(_weather(temp: 27, rainToday: 100)).kind,
        WeatherAdviceKind.avoidSpraying,
      );
    });

    test('exactly 60% rain is not above the threshold', () {
      expect(
        WeatherAdvice.from(_weather(temp: 27, rainToday: 60)).kind,
        WeatherAdviceKind.goodFieldDay,
      );
    });

    test('temperature above 33 °C → irrigate early morning / evening', () {
      expect(
        WeatherAdvice.from(_weather(temp: 33.1, rainToday: 10)).kind,
        WeatherAdviceKind.irrigateEarly,
      );
      expect(
        WeatherAdvice.from(_weather(temp: 38, rainToday: 60)).kind,
        WeatherAdviceKind.irrigateEarly,
      );
    });

    test('exactly 33 °C is not above the threshold', () {
      expect(
        WeatherAdvice.from(_weather(temp: 33, rainToday: 60)).kind,
        WeatherAdviceKind.goodFieldDay,
      );
    });

    test('rain wins over heat', () {
      expect(
        WeatherAdvice.from(_weather(temp: 36, rainToday: 75)).kind,
        WeatherAdviceKind.avoidSpraying,
      );
    });

    test('mild and dry → good day for field work', () {
      expect(
        WeatherAdvice.from(_weather(temp: 29, rainToday: 20)),
        const WeatherAdvice(WeatherAdviceKind.goodFieldDay),
      );
    });

    test('falls back to hourly values when the daily maximum is missing', () {
      expect(
        WeatherAdvice.from(_weather(temp: 27, hourly: [10, 85, 30])).kind,
        WeatherAdviceKind.avoidSpraying,
      );
    });

    test('no rain data at all is treated as dry', () {
      expect(WeatherAdvice.from(_weather(temp: 27)).kind, WeatherAdviceKind.goodFieldDay);
      expect(WeatherAdvice.from(_weather(temp: 35)).kind, WeatherAdviceKind.irrigateEarly);
    });
  });

  group('WeatherCondition.fromWmo', () {
    const expected = {
      0: WeatherCondition.clear,
      1: WeatherCondition.clear,
      2: WeatherCondition.partlyCloudy,
      3: WeatherCondition.cloudy,
      45: WeatherCondition.fog,
      48: WeatherCondition.fog,
      51: WeatherCondition.drizzle,
      53: WeatherCondition.drizzle,
      55: WeatherCondition.drizzle,
      56: WeatherCondition.drizzle,
      57: WeatherCondition.drizzle,
      61: WeatherCondition.rain,
      63: WeatherCondition.rain,
      65: WeatherCondition.rain,
      66: WeatherCondition.rain,
      67: WeatherCondition.rain,
      71: WeatherCondition.snow,
      73: WeatherCondition.snow,
      75: WeatherCondition.snow,
      77: WeatherCondition.snow,
      80: WeatherCondition.showers,
      81: WeatherCondition.showers,
      82: WeatherCondition.showers,
      85: WeatherCondition.snow,
      86: WeatherCondition.snow,
      95: WeatherCondition.thunderstorm,
      96: WeatherCondition.thunderstorm,
      99: WeatherCondition.thunderstorm,
    };

    test('maps every WMO code Open-Meteo documents', () {
      for (final entry in expected.entries) {
        expect(WeatherCondition.fromWmo(entry.key), entry.value, reason: 'code ${entry.key}');
      }
    });

    test('unknown or missing codes never throw', () {
      expect(WeatherCondition.fromWmo(null), WeatherCondition.unknown);
      expect(WeatherCondition.fromWmo(4), WeatherCondition.unknown);
      expect(WeatherCondition.fromWmo(-1), WeatherCondition.unknown);
      expect(WeatherCondition.fromWmo(1000), WeatherCondition.unknown);
    });

    test('isWet marks the rainy conditions', () {
      final wet = WeatherCondition.values.where((c) => c.isWet).toSet();
      expect(wet, {
        WeatherCondition.drizzle,
        WeatherCondition.rain,
        WeatherCondition.showers,
        WeatherCondition.thunderstorm,
      });
    });
  });

  group('Weather.fromOpenMeteo', () {
    test('parses a realistic payload', () {
      final w = Weather.fromOpenMeteo(sampleOpenMeteo());

      expect(w.current.temperatureC, 29.4);
      expect(w.current.humidityPercent, 74);
      expect(w.current.windSpeedKmh, 11.6);
      expect(w.current.precipitationMm, 0.1);
      expect(w.current.weatherCode, 2);
      expect(w.current.condition, WeatherCondition.partlyCloudy);
      expect(w.current.time, DateTime(2026, 10, 5, 14, 15));

      expect(w.daily, hasLength(7));
      expect(w.daily.first.date, DateTime(2026, 10, 5));
      expect(w.daily.first.tempMaxC, 30.1);
      expect(w.daily.first.tempMinC, 21.3);
      expect(w.daily.first.rainProbability, 35);
      expect(w.daily[1].condition, WeatherCondition.rain);
      expect(w.daily[3].rainProbability, isNull, reason: 'null entries stay null');
      expect(w.daily.last.date, DateTime(2026, 10, 11));

      expect(w.hourly, hasLength(168));
      expect(w.hourly.first.time, DateTime(2026, 10, 5));
      expect(w.hourly[15].probability, (15 * 7) % 101);
      expect(w.rainProbabilityToday, 35);
    });

    test('missing optional arrays do not throw', () {
      final json = sampleOpenMeteo()
        ..remove('daily')
        ..remove('hourly');
      final w = Weather.fromOpenMeteo(json);
      expect(w.current.temperatureC, 29.4);
      expect(w.daily, isEmpty);
      expect(w.hourly, isEmpty);
      expect(w.rainProbabilityToday, isNull);
      expect(w.hourlyFrom(DateTime(2026, 10, 5, 9)), isEmpty);
      expect(WeatherAdvice.from(w).kind, WeatherAdviceKind.goodFieldDay);
    });

    test('tolerates short arrays, nulls and numbers sent as text', () {
      final w = Weather.fromOpenMeteo({
        'current': {'temperature_2m': '31.5', 'weather_code': 95.0},
        'daily': {
          'time': ['2026-10-05', '2026-10-06', 'not-a-date'],
          'weather_code': [3],
          'temperature_2m_max': [30, null],
          'precipitation_probability_max': [140, null, 20],
        },
        'hourly': {
          'time': ['2026-10-05T00:00', '2026-10-05T01:00', '2026-10-05T02:00'],
          'precipitation_probability': [10, null],
        },
      });
      expect(w.current.temperatureC, 31.5);
      expect(w.current.condition, WeatherCondition.thunderstorm);
      expect(w.current.humidityPercent, isNull);
      expect(w.daily, hasLength(2), reason: 'the unparseable date is skipped');
      expect(w.daily.first.rainProbability, 100, reason: 'clamped to 0–100');
      expect(w.daily.first.tempMinC, isNull);
      expect(w.daily[1].weatherCode, isNull);
      expect(w.hourly.map((h) => h.probability), [10]);
    });

    test('a payload without the current temperature is rejected', () {
      expect(() => Weather.fromOpenMeteo({'daily': <String, dynamic>{}}), throwsFormatException);
      expect(
        () => Weather.fromOpenMeteo({'current': <String, dynamic>{'weather_code': 1}}),
        throwsFormatException,
      );
    });
  });

  group('Weather.hourlyFrom', () {
    final w = Weather.fromOpenMeteo(sampleOpenMeteo());

    test('returns the next 24 hours starting at the current hour', () {
      final next = w.hourlyFrom(DateTime(2026, 10, 5, 14, 40));
      expect(next, hasLength(24));
      expect(next.first.time, DateTime(2026, 10, 5, 14));
      expect(next.last.time, DateTime(2026, 10, 6, 13));
    });

    test('falls back to the first hours when the forecast is older than now', () {
      final next = w.hourlyFrom(DateTime(2027, 1, 1));
      expect(next, hasLength(24));
      expect(next.first.time, DateTime(2026, 10, 5));
    });

    test('colomboNow is UTC + 5:30 whatever the device zone', () {
      expect(
        Weather.colomboNow(DateTime.utc(2026, 10, 5, 20, 45)),
        DateTime(2026, 10, 6, 2, 15),
      );
    });
  });
}
