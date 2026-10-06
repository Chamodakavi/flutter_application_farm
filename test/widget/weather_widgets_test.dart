import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/l10n/district_labels.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/weather/data/weather_repository.dart';
import 'package:farmfriend/features/weather/domain/weather.dart';
import 'package:farmfriend/features/weather/presentation/weather_screen.dart';
import 'package:farmfriend/features/weather/presentation/widgets/hourly_rain_chart.dart';
import 'package:farmfriend/features/weather/presentation/widgets/weather_card.dart';
import 'package:farmfriend/features/weather/presentation/widgets/weather_condition_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../unit/weather_sample.dart';
import 'settings_test_fakes.dart';

/// Answers with [weather], or fails like an offline phone when it is null.
class _FakeWeatherRepository implements WeatherRepository {
  _FakeWeatherRepository([this.weather]);

  final Weather? weather;
  final requested = <String>[];
  var forced = 0;

  @override
  Future<Weather> fetch(District district, {bool forceRefresh = false}) async {
    requested.add(district.key);
    if (forceRefresh) forced++;
    final w = weather;
    if (w == null) throw const AppException.network('offline');
    return w;
  }

  @override
  DateTime? savedAt(District district) => null;
}

void main() {
  List<Override> overridesFor(_FakeWeatherRepository repo) => [
    profileProvider.overrideWith(() => FakeProfileController(testFarmer)),
    weatherRepositoryProvider.overrideWithValue(repo),
  ];

  // The dashboard puts the card in a two-column grid.
  const card = Scaffold(
    body: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: 170, child: WeatherCard()),
    ),
  );

  group('WeatherCard', () {
    testWidgets('renders — instead of throwing when the repository fails', (tester) async {
      await pumpApp(tester, card, overrides: overridesFor(_FakeWeatherRepository()));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Weather'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('Weather unavailable'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows the temperature and the advice for the profile district', (tester) async {
      final repo = _FakeWeatherRepository(Weather.fromOpenMeteo(sampleOpenMeteo()));
      await pumpApp(tester, card, overrides: overridesFor(repo));
      await tester.pump();

      expect(find.text('29°C'), findsOneWidget);
      expect(find.text('Good day for field work'), findsOneWidget);
      expect(repo.requested, contains('Kandy'));
    });

    testWidgets('shows the spraying warning when rain is likely', (tester) async {
      final repo = _FakeWeatherRepository(
        Weather.fromOpenMeteo(sampleOpenMeteo(dailyRain: const [85, 20, 20, 20, 20, 20, 20])),
      );
      await pumpApp(tester, card, overrides: overridesFor(repo));
      await tester.pump();

      expect(find.text('Avoid spraying today'), findsOneWidget);
    });

    testWidgets('opens the Weather screen on tap, also after a failure', (tester) async {
      await pumpApp(tester, card, overrides: overridesFor(_FakeWeatherRepository()));
      await tester.pump();

      await tester.tap(find.byType(WeatherCard));
      await tester.pumpAndSettle();

      expect(find.text(routeMarker(Routes.weather)), findsOneWidget);
    });

    testWidgets('fits a narrow grid cell in Tamil at text scale 1.3', (tester) async {
      final repo = _FakeWeatherRepository(
        Weather.fromOpenMeteo(sampleOpenMeteo(temperature: 34.6, dailyRain: const [10])),
      );
      await pumpApp(
        tester,
        const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 136, child: WeatherCard()),
          ),
        ),
        overrides: overridesFor(repo),
        locale: const Locale('ta'),
        textScale: 1.3,
        surfaceSize: const Size(320, 640),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('35°C'), findsOneWidget);
    });
  });

  group('WeatherScreen', () {
    testWidgets('shows current conditions, advice, the chart and 7 days', (tester) async {
      final repo = _FakeWeatherRepository(Weather.fromOpenMeteo(sampleOpenMeteo()));
      await pumpApp(
        tester,
        const WeatherScreen(),
        overrides: overridesFor(repo),
        surfaceSize: const Size(390, 2200),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Kandy'), findsWidgets);
      expect(find.text('29°C'), findsOneWidget);
      expect(find.text('Partly cloudy'), findsWidgets);
      expect(find.text('Humidity'), findsOneWidget);
      expect(find.text('74%'), findsOneWidget);
      expect(find.text('12 km/h'), findsOneWidget);
      expect(find.text('Field work advice'), findsOneWidget);
      expect(find.text('Good day for field work'), findsOneWidget);
      expect(find.byType(HourlyRainChart), findsOneWidget);
      expect(find.text('7-day forecast'), findsOneWidget);
      expect(find.text('30° / 21°'), findsOneWidget);
      expect(find.byIcon(Icons.water_drop_outlined), findsNWidgets(7));
    });

    testWidgets('shows an error with Retry when nothing can be loaded', (tester) async {
      final repo = _FakeWeatherRepository();
      await pumpApp(tester, const WeatherScreen(), overrides: overridesFor(repo));
      await tester.pump();

      expect(find.textContaining('No internet connection'), findsOneWidget);
      final before = repo.requested.length;

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump();

      expect(repo.requested.length, before + 1);
    });

    testWidgets('pull-to-refresh skips the cache', (tester) async {
      final repo = _FakeWeatherRepository(Weather.fromOpenMeteo(sampleOpenMeteo()));
      await pumpApp(tester, const WeatherScreen(), overrides: overridesFor(repo));
      await tester.pump();

      await tester.fling(find.text('29°C'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(repo.forced, 1);
    });

    for (final code in ['si', 'ta']) {
      testWidgets('no overflow in $code at 320 dp and text scale 1.3', (tester) async {
        final repo = _FakeWeatherRepository(
          Weather.fromOpenMeteo(sampleOpenMeteo(hourlyRain: (h) => h.isEven ? 100 : 0)),
        );
        await pumpApp(
          tester,
          const WeatherScreen(),
          overrides: overridesFor(repo),
          locale: Locale(code),
          textScale: 1.3,
          surfaceSize: const Size(320, 3200),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
        expect(find.byType(HourlyRainChart), findsOneWidget);
      });
    }

    testWidgets('a forecast without daily or hourly data still renders', (tester) async {
      final json = sampleOpenMeteo()
        ..remove('daily')
        ..remove('hourly');
      final repo = _FakeWeatherRepository(Weather.fromOpenMeteo(json));
      await pumpApp(
        tester,
        const WeatherScreen(),
        overrides: overridesFor(repo),
        surfaceSize: const Size(390, 1600),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(HourlyRainChart), findsNothing);
      expect(find.text('Hourly rain data is not available right now.'), findsOneWidget);
      expect(find.text('The 7-day forecast is not available right now.'), findsOneWidget);
    });
  });

  test('every condition has an icon', () {
    for (final condition in WeatherCondition.values) {
      expect(condition.icon, isA<IconData>(), reason: condition.name);
    }
    expect(WeatherCondition.thunderstorm.icon, Icons.thunderstorm_rounded);
    expect(WeatherCondition.clear.icon, Icons.wb_sunny_rounded);
  });
}
