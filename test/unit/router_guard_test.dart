import 'package:farmfriend/core/config/app_config_provider.dart';
import 'package:farmfriend/core/router/app_router.dart';
import 'package:farmfriend/core/router/routes.dart';
import 'package:flutter_test/flutter_test.dart';

/// Decision table for the router guard (spec §8.2, §11.33).
void main() {
  GuardState state({
    AppGate gate = AppGate.open,
    bool languageChosen = true,
    bool signedIn = false,
    bool recoveringPassword = false,
    bool profileLoaded = false,
    bool profileFailed = false,
    bool profileComplete = false,
  }) => GuardState(
    gate: gate,
    languageChosen: languageChosen,
    signedIn: signedIn,
    recoveringPassword: recoveringPassword,
    profileLoaded: profileLoaded,
    profileFailed: profileFailed,
    profileComplete: profileComplete,
  );

  final ready = state(signedIn: true, profileLoaded: true, profileComplete: true);

  test('first run goes to language selection', () {
    final s = state(languageChosen: false);
    expect(guardRedirect(s, Routes.splash), Routes.language);
    expect(guardRedirect(s, Routes.language), isNull);
    expect(guardRedirect(s, Routes.home), Routes.language);
  });

  test('signed out: public routes stay, everything else goes to login', () {
    final s = state();
    for (final public in [
      Routes.splash,
      Routes.onboarding,
      Routes.login,
      Routes.phoneLogin,
      Routes.otp,
      Routes.signup,
      Routes.forgot,
      Routes.reset,
    ]) {
      expect(guardRedirect(s, public), isNull, reason: public);
    }
    for (final private in [Routes.home, Routes.cart, Routes.register, Routes.settings]) {
      expect(guardRedirect(s, private), Routes.login, reason: private);
    }
  });

  test('TC_AUTH_01: valid login with a complete profile lands on Home', () {
    expect(guardRedirect(ready, Routes.login), Routes.home);
    expect(guardRedirect(ready, Routes.splash), Routes.home);
    expect(guardRedirect(ready, Routes.completeProfile), Routes.home);
    expect(guardRedirect(ready, Routes.home), isNull);
    expect(guardRedirect(ready, Routes.cart), isNull);
  });

  test('signed in while the profile loads: stay put', () {
    final s = state(signedIn: true);
    expect(guardRedirect(s, Routes.splash), isNull);
    expect(guardRedirect(s, Routes.login), isNull);
    expect(guardRedirect(s, Routes.home), isNull);
  });

  test('profile failed to load: splash offers retry / sign out', () {
    final s = state(signedIn: true, profileFailed: true);
    expect(guardRedirect(s, Routes.login), Routes.splash);
    expect(guardRedirect(s, Routes.home), Routes.splash);
    expect(guardRedirect(s, Routes.splash), isNull);
  });

  test('incomplete profile is gated on Complete Profile', () {
    final s = state(signedIn: true, profileLoaded: true);
    expect(guardRedirect(s, Routes.home), Routes.completeProfile);
    expect(guardRedirect(s, Routes.login), Routes.completeProfile);
    expect(guardRedirect(s, Routes.completeProfile), isNull);
  });

  test('password recovery keeps the user on Reset', () {
    final s = state(
      signedIn: true,
      recoveringPassword: true,
      profileLoaded: true,
      profileComplete: true,
    );
    expect(guardRedirect(s, Routes.home), Routes.reset);
    expect(guardRedirect(s, Routes.reset), isNull);
  });

  test('maintenance and forced update override everything', () {
    final maintenance = state(
      gate: AppGate.maintenance,
      signedIn: true,
      profileLoaded: true,
      profileComplete: true,
    );
    expect(guardRedirect(maintenance, Routes.home), Routes.maintenance);
    expect(guardRedirect(maintenance, Routes.maintenance), isNull);

    final update = state(gate: AppGate.updateRequired);
    expect(guardRedirect(update, Routes.login), Routes.updateRequired);
    expect(guardRedirect(update, Routes.updateRequired), isNull);

    // Once the gate reopens, the blocking screens send the user back in.
    expect(guardRedirect(ready, Routes.maintenance), Routes.splash);
    expect(guardRedirect(ready, Routes.updateRequired), Routes.splash);
  });
}
