import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/l10n/locale_provider.dart';
import 'package:farmfriend/core/notifications/push_service.dart';
import 'package:farmfriend/features/settings/presentation/about_screen.dart';
import 'package:farmfriend/features/settings/presentation/language_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_app.dart';

class _MockAnalytics extends Mock implements AnalyticsService {}

class _MockPush extends Mock implements PushService {}

void main() {
  group('LanguageSettingsScreen', () {
    testWidgets('picking a language applies it immediately', (tester) async {
      final analytics = _MockAnalytics();
      final push = _MockPush();
      when(push.registerDevice).thenAnswer((_) async {});

      await pumpApp(
        tester,
        const LanguageSettingsScreen(),
        overrides: [
          analyticsProvider.overrideWithValue(analytics),
          pushServiceProvider.overrideWithValue(push),
        ],
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(LanguageSettingsScreen)),
      );

      expect(find.text('English'), findsOneWidget);
      expect(find.text('සිංහල'), findsOneWidget);
      expect(find.text('தமிழ்'), findsOneWidget);
      expect(container.read(localeControllerProvider), const Locale('en'));

      await tester.tap(find.text('தமிழ்'));
      await tester.pump();

      // No "Save" step: the app locale has already changed.
      expect(container.read(localeControllerProvider), const Locale('ta'));
      verify(
        () => analytics.track(AnalyticsEvents.languageChanged, {'from': 'en', 'to': 'ta'}),
      ).called(1);
      // The push token row carries the language for server-sent alerts.
      verify(push.registerDevice).called(1);
    });
  });

  group('AboutScreen', () {
    testWidgets('shows the version, links, licences and credits', (tester) async {
      await pumpApp(
        tester,
        const AboutScreen(),
        overrides: [appVersionProvider.overrideWith((ref) async => '1.2.3')],
      );
      await tester.pump();

      expect(find.text('Version 1.2.3'), findsOneWidget);
      expect(find.text('Open web portal'), findsOneWidget);
      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Terms of use'), findsOneWidget);
      expect(find.text('Open-source licences'), findsOneWidget);
      expect(find.textContaining('Horizon Campus research team'), findsOneWidget);
    });

    testWidgets('hides the version when the platform cannot report one', (tester) async {
      await pumpApp(
        tester,
        const AboutScreen(),
        overrides: [appVersionProvider.overrideWith((ref) async => '0.0.0')],
      );
      await tester.pump();

      expect(find.textContaining('Version'), findsNothing);
      expect(find.text('Open web portal'), findsOneWidget);
    });

    test('policy links live under the web portal', () {
      expect(AboutScreen.privacyUrl, endsWith('/privacy'));
      expect(AboutScreen.termsUrl, endsWith('/terms'));
      expect(Uri.parse(AboutScreen.privacyUrl).scheme, 'https');
    });

    testWidgets('no overflow in Tamil at 320 dp and text scale 1.3', (tester) async {
      await pumpApp(
        tester,
        const AboutScreen(),
        overrides: [appVersionProvider.overrideWith((ref) async => '1.2.3')],
        locale: const Locale('ta'),
        textScale: 1.3,
        surfaceSize: const Size(320, 1600),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
