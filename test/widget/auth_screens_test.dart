import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:farmfriend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:farmfriend/features/auth/presentation/language_select_screen.dart';
import 'package:farmfriend/features/auth/presentation/login_screen.dart';
import 'package:farmfriend/features/auth/presentation/onboarding_screen.dart';
import 'package:farmfriend/features/auth/presentation/phone_login_screen.dart';
import 'package:farmfriend/features/auth/presentation/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_app.dart';

class _MockAuth extends Mock implements AuthController {}

void main() {
  late _MockAuth auth;

  setUp(() => auth = _MockAuth());

  Finder field(String label) => find.ancestor(
    of: find.text(label),
    matching: find.byType(Column),
  ).first;

  Future<void> enter(WidgetTester tester, String label, String value) async {
    await tester.enterText(
      find.descendant(of: field(label), matching: find.byType(TextFormField)).first,
      value,
    );
  }

  group('LoginScreen', () {
    testWidgets('TC_AUTH_02: wrong password shows the localized banner', (tester) async {
      when(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AppException.auth('invalid_credentials'));

      await pumpApp(
        tester,
        const LoginScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Email', 'farmer@example.com');
      await enter(tester, 'Password', 'wrong-pass1');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid login credentials'), findsOneWidget);
    });

    testWidgets('the same banner is translated in Sinhala', (tester) async {
      when(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AppException.auth('invalid_credentials'));

      await pumpApp(
        tester,
        const LoginScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
        locale: const Locale('si'),
      );
      await enter(tester, 'ඊමේල්', 'farmer@example.com');
      await enter(tester, 'මුරපදය', 'wrong-pass1');
      await tester.tap(find.text('පිවිසෙන්න'));
      await tester.pumpAndSettle();

      expect(find.text('පිවිසුම් තොරතුරු වැරදියි'), findsOneWidget);
    });

    testWidgets('validates before calling the server', (tester) async {
      await pumpApp(
        tester,
        const LoginScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Email', 'not-an-email');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(find.text('This field is required'), findsOneWidget);
      verifyNever(
        () => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('offers Google, phone and sign-up', (tester) async {
      await pumpApp(
        tester,
        const LoginScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with phone'), findsOneWidget);

      await tester.ensureVisible(find.text('Continue with phone'));
      await tester.tap(find.text('Continue with phone'));
      await tester.pumpAndSettle();
      expect(find.text(routeMarker(Routes.phoneLogin)), findsOneWidget);
    });
  });

  group('SignupScreen', () {
    testWidgets('requires matching passwords and accepting the terms', (tester) async {
      await pumpApp(
        tester,
        const SignupScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Full name', 'Nimal Perera');
      await enter(tester, 'Email', 'nimal@example.com');
      await enter(tester, 'Password', 'farm2026');
      await enter(tester, 'Confirm password', 'farm2027');
      await tester.ensureVisible(find.text('Create account'));
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(find.text('Please accept the terms to continue.'), findsOneWidget);
      verifyNever(
        () => auth.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('an existing email offers "Sign in instead"', (tester) async {
      when(
        () => auth.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AppException.auth('user_already_exists'));

      await pumpApp(
        tester,
        const SignupScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Full name', 'Nimal Perera');
      await enter(tester, 'Email', 'nimal@example.com');
      await enter(tester, 'Password', 'farm2026');
      await enter(tester, 'Confirm password', 'farm2026');
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.ensureVisible(find.text('Create account'));
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('This email is already registered. Sign in instead.'), findsOneWidget);
      expect(find.text('Sign in instead'), findsOneWidget);
    });

    testWidgets('email confirmation leads to "Check your email"', (tester) async {
      when(
        () => auth.signUp(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => false);

      await pumpApp(
        tester,
        const SignupScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Full name', 'Nimal Perera');
      await enter(tester, 'Email', 'nimal@example.com');
      await enter(tester, 'Password', 'farm2026');
      await enter(tester, 'Confirm password', 'farm2026');
      await tester.ensureVisible(find.byType(Checkbox));
      await tester.tap(find.byType(Checkbox));
      await tester.ensureVisible(find.text('Create account'));
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(
        find.text(routeMarker(Routes.checkEmailFor('nimal@example.com'))),
        findsOneWidget,
      );
    });
  });

  group('PhoneLoginScreen (TC_OTP_01)', () {
    testWidgets('rejects a number that is not 7XXXXXXXX', (tester) async {
      await pumpApp(
        tester,
        const PhoneLoginScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Mobile number', '112345678');
      await tester.tap(find.text('Send code'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Enter a valid mobile number'), findsOneWidget);
      verifyNever(() => auth.sendOtp(any()));
    });

    testWidgets('sends the code and opens the OTP screen', (tester) async {
      when(() => auth.sendOtp(any())).thenAnswer((_) async {});

      await pumpApp(
        tester,
        const PhoneLoginScreen(),
        overrides: [authControllerProvider.overrideWithValue(auth)],
      );
      await enter(tester, 'Mobile number', '771234567');
      await tester.tap(find.text('Send code'));
      await tester.pumpAndSettle();

      verify(() => auth.sendOtp('771234567')).called(1);
      expect(find.text(routeMarker(Routes.otpFor('771234567'))), findsOneWidget);
    });
  });

  testWidgets('language screen shows all three languages', (tester) async {
    await pumpApp(tester, const LanguageSelectScreen());
    expect(find.text('English'), findsOneWidget);
    expect(find.text('සිංහල'), findsOneWidget);
    expect(find.text('தமிழ்'), findsOneWidget);

    // The Continue button follows the highlighted language.
    await tester.tap(find.text('සිංහල'));
    await tester.pumpAndSettle();
    expect(find.text('ඉදිරියට'), findsOneWidget);
  });

  testWidgets('onboarding: three slides, then Get started', (tester) async {
    await pumpApp(tester, const OnboardingScreen());
    expect(find.text('Plan before you plant'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Fair prices, less waste'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Market, community & AgriBot'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('TC_L10N_01: auth screens do not overflow in Tamil at scale 1.3', (tester) async {
    for (final screen in const <Widget>[LoginScreen(), SignupScreen(), PhoneLoginScreen()]) {
      await pumpApp(
        tester,
        screen,
        overrides: [authControllerProvider.overrideWithValue(auth)],
        locale: const Locale('ta'),
        textScale: 1.3,
        surfaceSize: const Size(320, 640),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${screen.runtimeType}');
    }
  });
}
