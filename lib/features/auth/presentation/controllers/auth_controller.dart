import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/cache/hive_boxes.dart';
import '../../../../core/notifications/push_service.dart';
import '../../../../core/supabase/supabase_providers.dart';
import '../../../profile/data/profile_repository.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../data/auth_repository.dart';

/// True between a password-recovery deep link and the new password being
/// saved; the router keeps the user on the Reset screen meanwhile.
class PasswordRecoveryController extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;
  void finish() => state = false;
}

final passwordRecoveryProvider = NotifierProvider<PasswordRecoveryController, bool>(
  PasswordRecoveryController.new,
);

/// Auth actions used by the screens. Each method throws an `AppException` (or
/// `SignInCancelled`) on failure; navigation happens in the router guard once
/// the session and profile change.
class AuthController {
  AuthController(this._ref);

  final Ref _ref;

  AuthRepository get _repo => _ref.read(authRepositoryProvider);

  Future<void> signInWithPassword({required String email, required String password}) async {
    await _repo.signInWithPassword(email: email, password: password);
    await _afterSignIn();
  }

  /// Returns true when signed in immediately, false when the "check your
  /// email" screen should be shown.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final signedIn = await _repo.signUp(name: name, email: email, password: password);
    if (signedIn) await _afterSignIn();
    return signedIn;
  }

  Future<void> signInWithGoogle() async {
    await _repo.signInWithGoogle();
    // The browser fallback finishes later through the deep link; the profile
    // provider then loads (and creates) the row by itself.
    if (_repo.currentUser != null) await _afterSignIn();
  }

  Future<void> sendOtp(String digits) => _repo.sendOtp(digits);

  Future<void> verifyOtp({required String digits, required String code}) async {
    await _repo.verifyOtp(digits: digits, code: code);
    await _afterSignIn();
  }

  Future<void> sendPasswordReset(String email) => _repo.sendPasswordReset(email);

  /// Reset screen: saves the new password, then signs out so the user logs in
  /// with it (spec §8.1: Reset → Login).
  Future<void> completePasswordReset(String newPassword) async {
    await _repo.updatePassword(newPassword);
    await signOut();
    _ref.read(passwordRecoveryProvider.notifier).finish();
  }

  /// Makes sure the `users` row exists before the router reads the profile
  /// (spec §8.6), then registers this device for push.
  Future<void> _afterSignIn() async {
    try {
      await _ref.read(profileRepositoryProvider).ensureProfileRow();
    } catch (_) {
      // The profile fetch repairs a missing row; do not fail the sign-in.
    }
    _ref.invalidate(profileProvider);
    unawaited(_ref.read(pushServiceProvider).registerDevice());
  }

  /// Device token → Google → Supabase → local user data (spec §8.5).
  Future<void> signOut() async {
    final uid = _ref.read(supabaseClientProvider).auth.currentUser?.id;
    await _ref.read(analyticsProvider).flush();
    await _ref.read(pushServiceProvider).unregisterDevice();
    await _repo.signOut();
    if (uid != null) await HiveBoxes.clearUserData(uid);
  }

  Future<void> deleteAccount() async {
    final uid = _ref.read(supabaseClientProvider).auth.currentUser?.id;
    await _ref.read(pushServiceProvider).unregisterDevice();
    await _repo.deleteAccount();
    await _repo.signOut();
    if (uid != null) await HiveBoxes.clearUserData(uid);
  }
}

final authControllerProvider = Provider<AuthController>(AuthController.new);
