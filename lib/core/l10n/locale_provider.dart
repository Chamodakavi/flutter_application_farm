import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../cache/hive_boxes.dart';

/// Languages the app ships with (spec §16).
abstract final class AppLocales {
  static const en = Locale('en');
  static const si = Locale('si');
  static const ta = Locale('ta');
  static const all = [en, si, ta];

  /// Names shown in their own script.
  static String nativeName(String code) => switch (code) {
    'si' => 'සිංහල',
    'ta' => 'தமிழ்',
    _ => 'English',
  };
}

/// The chosen app language, persisted in Hive (spec §16.4).
class LocaleController extends Notifier<Locale> {
  Box<dynamic>? get _prefs =>
      Hive.isBoxOpen(HiveBoxes.prefs) ? Hive.box<dynamic>(HiveBoxes.prefs) : null;

  @override
  Locale build() {
    final code = _prefs?.get(PrefKeys.locale) as String?;
    return Locale(code ?? 'en');
  }

  /// False until the user has picked a language on first run.
  bool get hasUserChoice => _prefs?.containsKey(PrefKeys.locale) ?? true;

  Future<void> set(String code) async {
    await _prefs?.put(PrefKeys.locale, code);
    state = Locale(code);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

/// Whether the three onboarding slides were completed or skipped.
class OnboardingController extends Notifier<bool> {
  Box<dynamic>? get _prefs =>
      Hive.isBoxOpen(HiveBoxes.prefs) ? Hive.box<dynamic>(HiveBoxes.prefs) : null;

  @override
  bool build() => _prefs?.get(PrefKeys.onboardingDone) == true;

  Future<void> complete() async {
    await _prefs?.put(PrefKeys.onboardingDone, true);
    state = true;
  }
}

final onboardingDoneProvider = NotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);
