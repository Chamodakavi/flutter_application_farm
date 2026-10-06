// End-to-end smoke test against a STAGING Supabase project (spec §19).
//
// Never point this at production: it signs in and navigates with a real
// account. Run on an emulator or device with a dedicated test user:
//
//   flutter test integration_test/app_flow_test.dart \
//     --dart-define-from-file=env/dev.json \
//     --dart-define=TEST_EMAIL=farmer.test@example.com \
//     --dart-define=TEST_PASSWORD=********
//
// The test user must already have a complete profile (name + phone). Without
// TEST_EMAIL / TEST_PASSWORD the test is skipped.
import 'package:farmfriend/bootstrap.dart';
import 'package:farmfriend/core/config/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _email = String.fromEnvironment('TEST_EMAIL');
const _password = String.fromEnvironment('TEST_PASSWORD');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final configured = Env.isConfigured && _email.isNotEmpty && _password.isNotEmpty;

  /// Pumps until [finder] matches or [timeout] passes.
  Future<void> waitFor(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 250));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Timed out waiting for $finder');
  }

  testWidgets(
    'TC_AUTH_01: sign in, land on Home, visit every tab',
    (tester) async {
      await bootstrap();

      // First run: language → onboarding → login.
      await waitFor(
        tester,
        find.byWidgetPredicate(
          (w) => w is Text && (w.data == 'English' || w.data == 'Sign in' || w.data == 'Skip'),
        ),
      );
      if (find.text('English').evaluate().isNotEmpty) {
        await tester.tap(find.text('English'));
        await tester.pump();
        await tester.tap(find.text('Continue'));
        await waitFor(tester, find.text('Skip'));
      }
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
      }
      await waitFor(tester, find.text('Sign in'));

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), _email);
      await tester.enterText(fields.at(1), _password);
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));

      // The router guard opens the dashboard once the profile has loaded.
      await waitFor(tester, find.textContaining('Welcome back'));

      // Bottom navigation: every tab opens without an error screen.
      for (final tab in ['Market', 'Register', 'Community', 'More', 'Home']) {
        await tester.tap(
          find.descendant(of: find.byType(NavigationBar), matching: find.text(tab)),
        );
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Something went wrong'), findsNothing, reason: 'tab $tab');
      }
    },
    skip: !configured,
  );
}
