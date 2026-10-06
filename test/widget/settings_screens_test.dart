import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/settings/presentation/controllers/credentials_controller.dart';
import 'package:farmfriend/features/settings/presentation/credentials_screen.dart';
import 'package:farmfriend/features/settings/presentation/notification_settings_screen.dart';
import 'package:farmfriend/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import 'settings_test_fakes.dart';

void main() {
  const emailAccount = CredentialsInfo(
    provider: 'email',
    hasPassword: true,
    email: 'nimal@example.com',
  );

  group('SettingsScreen', () {
    Future<void> pumpSettings(
      WidgetTester tester, {
      Locale locale = const Locale('en'),
      double textScale = 1.0,
      Size surfaceSize = const Size(390, 844),
    }) async {
      await pumpApp(
        tester,
        const SettingsScreen(),
        overrides: [
          profileProvider.overrideWith(() => FakeProfileController(testFarmer)),
          credentialsInfoProvider.overrideWithValue(emailAccount),
        ],
        locale: locale,
        textScale: textScale,
        surfaceSize: surfaceSize,
      );
      await tester.pump();
    }

    testWidgets('has the three tabs and switches between their bodies', (tester) async {
      await pumpSettings(tester);

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Credentials'), findsOneWidget);
      expect(find.text('Update Profile'), findsOneWidget);
      expect(find.text('Allow notifications'), findsNothing);

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();
      expect(find.text('Allow notifications'), findsOneWidget);
      expect(find.text('Update Profile'), findsNothing);

      await tester.tap(find.text('Credentials'));
      await tester.pumpAndSettle();
      expect(find.text('Current password *'), findsOneWidget);
    });

    testWidgets('lists Language, About, feedback and Sign out; Language opens its page', (
      tester,
    ) async {
      await pumpSettings(tester, surfaceSize: const Size(390, 2000));

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Give feedback'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker(Routes.settingsLanguage)), findsOneWidget);
    });

    testWidgets('Sign out asks for confirmation first', (tester) async {
      await pumpSettings(tester, surfaceSize: const Size(390, 2000));

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(find.text('Sign out?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Sign out?'), findsNothing);
      expect(find.text('Settings'), findsOneWidget, reason: 'still on Settings');
    });

    for (final code in ['si', 'ta']) {
      testWidgets('no overflow in $code at 320 dp and text scale 1.3', (tester) async {
        await pumpSettings(
          tester,
          locale: Locale(code),
          textScale: 1.3,
          surfaceSize: const Size(320, 640),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('NotificationSettingsScreen', () {
    testWidgets('the master switch updates u_notify through the profile controller', (
      tester,
    ) async {
      final fake = FakeProfileController(testFarmer);
      await pumpApp(
        tester,
        const NotificationSettingsScreen(),
        overrides: [profileProvider.overrideWith(() => fake)],
      );
      await tester.pump();

      expect(find.text('Order updates'), findsOneWidget);
      expect(find.text('Community replies'), findsOneWidget);
      expect(find.text('News alerts'), findsOneWidget);
      expect(find.text('Enable push notifications'), findsOneWidget);

      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(4));
      expect(tester.widget<Switch>(switches.first).value, isTrue);

      await tester.tap(switches.first);
      await tester.pump();

      expect(fake.notifyChanges, [false]);
      // With the master switch off the per-type switches are off and locked.
      expect(tester.widget<Switch>(switches.at(1)).value, isFalse);
      expect(tester.widget<Switch>(switches.at(1)).onChanged, isNull);
    });
  });

  group('CredentialsScreen', () {
    Future<void> pumpCredentials(WidgetTester tester, CredentialsInfo info) => pumpApp(
      tester,
      const CredentialsScreen(),
      overrides: [credentialsInfoProvider.overrideWithValue(info)],
    );

    testWidgets('password account: change password with current, new and confirm', (tester) async {
      await pumpCredentials(tester, emailAccount);

      expect(find.text('Change password'), findsOneWidget);
      // Required fields carry a red asterisk after the label.
      expect(find.text('Current password *'), findsOneWidget);
      expect(find.text('New password *'), findsOneWidget);
      expect(find.text('Confirm new password *'), findsOneWidget);
      expect(find.textContaining('Google'), findsNothing);

      // Weak and mismatching passwords are caught before any network call.
      await tester.enterText(find.byType(TextFormField).at(0), 'old-pass1');
      await tester.enterText(find.byType(TextFormField).at(1), 'short');
      await tester.enterText(find.byType(TextFormField).at(2), 'different1');
      await tester.tap(find.text('Update password'));
      await tester.pump();
      expect(find.text('Use at least 8 characters with a letter and a number'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Google-only account: explains and offers to set a password', (tester) async {
      await pumpCredentials(
        tester,
        const CredentialsInfo(provider: 'google', hasPassword: false, email: 'n@example.com'),
      );

      expect(find.textContaining('You signed in with Google'), findsOneWidget);
      expect(find.text('Set a password'), findsWidgets);
      expect(find.text('Current password *'), findsNothing);
      expect(find.text('New password *'), findsOneWidget);
    });

    testWidgets('phone account: shows the number and offers email & password', (tester) async {
      await pumpCredentials(
        tester,
        const CredentialsInfo(provider: 'phone', hasPassword: false, phone: '+94771234567'),
      );

      expect(find.text('Signed in with phone +94771234567'), findsOneWidget);
      expect(find.text('Add email & password'), findsWidgets);
      expect(find.text('Email *'), findsOneWidget);
      expect(find.text('Current password *'), findsNothing);
    });

    testWidgets('phone account that already added a password can change it', (tester) async {
      await pumpCredentials(
        tester,
        const CredentialsInfo(
          provider: 'phone',
          hasPassword: true,
          phone: '+94771234567',
          email: 'n@example.com',
        ),
      );

      expect(find.text('Signed in with phone +94771234567'), findsOneWidget);
      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Current password *'), findsOneWidget);
    });
  });
}
