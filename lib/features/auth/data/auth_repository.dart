import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/env.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/supabase/supabase_providers.dart';

/// Thrown when the user backs out of the Google account picker. The UI stays
/// silent for this one (spec §11.5).
class SignInCancelled implements Exception {
  const SignInCancelled();
}

/// Email/password, Google and phone-OTP sign-in on Supabase Auth (spec §8).
class AuthRepository {
  AuthRepository(this._db);

  final SupabaseClient _db;
  bool _googleReady = false;

  static const _hasPasswordKey = 'has_password';

  GoTrueClient get _auth => _db.auth;

  User? get currentUser => _auth.currentUser;

  // --- Email & password ------------------------------------------------------

  Future<void> signInWithPassword({required String email, required String password}) =>
      guard(() => _auth.signInWithPassword(email: email.trim(), password: password));

  /// Returns true when the account is signed in straight away, false when the
  /// user must first confirm their email.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) => guard(() async {
    final res = await _auth.signUp(
      email: email.trim(),
      password: password,
      data: {'full_name': name.trim()},
      emailRedirectTo: DeepLinks.loginCallback,
    );
    // With "Confirm email" on, GoTrue answers an existing address with a user
    // that has no identities instead of an error.
    if (res.session == null && (res.user?.identities?.isEmpty ?? false)) {
      throw const AppException.auth('user_already_exists');
    }
    return res.session != null;
  });

  Future<void> sendPasswordReset(String email) => guard(
    () => _auth.resetPasswordForEmail(email.trim(), redirectTo: DeepLinks.resetPassword),
  );

  /// Sets a new password for the current (recovery or signed-in) session.
  Future<void> updatePassword(String newPassword) => guard(
    () => _auth.updateUser(
      UserAttributes(password: newPassword, data: const {_hasPasswordKey: true}),
    ),
  );

  /// Settings → Credentials: verifies the current password first.
  Future<void> changePassword({required String current, required String newPassword}) async {
    final email = currentUser?.email;
    if (email == null || email.isEmpty) throw const AppException.auth('session_expired');
    try {
      await _auth.signInWithPassword(email: email, password: current);
    } catch (e) {
      final failure = mapError(e);
      if (failure is AuthFailure && failure.code == 'invalid_credentials') {
        throw const AppException.auth('wrong_password');
      }
      throw failure;
    }
    await updatePassword(newPassword);
  }

  /// "Set a password" for Google accounts and "Add email & password" for
  /// phone accounts.
  Future<void> setEmailAndPassword({String? email, required String password}) => guard(
    () => _auth.updateUser(
      UserAttributes(
        email: (email == null || email.trim().isEmpty) ? null : email.trim(),
        password: password,
        data: const {_hasPasswordKey: true},
      ),
    ),
  );

  // --- Google ----------------------------------------------------------------

  /// Native Google Sign-In → Supabase `signInWithIdToken`; no client secret in
  /// the app (spec §8.4). Falls back to the browser flow when the native
  /// client IDs are not configured. There is no separate "sign up with
  /// Google": Supabase creates the account on first sign-in.
  Future<void> signInWithGoogle() async {
    final google = GoogleSignIn.instance;
    final native = Env.googleWebClientId.isNotEmpty && !kIsWeb;
    try {
      if (!native) {
        await _auth.signInWithOAuth(OAuthProvider.google, redirectTo: DeepLinks.loginCallback);
        return;
      }
      if (!_googleReady) {
        await google.initialize(
          serverClientId: Env.googleWebClientId,
          clientId: defaultTargetPlatform == TargetPlatform.iOS && Env.googleIosClientId.isNotEmpty
              ? Env.googleIosClientId
              : null,
        );
        _googleReady = true;
      }
      final account = await google.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw const AppException.auth('google_no_id_token');
      await _auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) throw const SignInCancelled();
      throw const AppException.auth('google_failed');
    } catch (e) {
      if (e is SignInCancelled) rethrow;
      throw mapError(e);
    }
  }

  // --- Phone + SMS OTP (spec §8.9) -------------------------------------------

  /// [digits] is the 9-digit number after the fixed `+94` prefix.
  Future<void> sendOtp(String digits) => guard(() => _auth.signInWithOtp(phone: '+94$digits'));

  Future<void> verifyOtp({required String digits, required String code}) => guard(
    () => _auth.verifyOTP(type: OtpType.sms, phone: '+94$digits', token: code),
  );

  // --- Account ---------------------------------------------------------------

  /// How this account signs in: `email`, `google` or `phone`.
  String get provider => currentUser?.appMetadata['provider']?.toString() ?? 'email';

  /// True when an email + password identity exists (so "change password" makes
  /// sense).
  ///
  /// Supabase keeps `providers` as `[google]` / `[phone]` after such an
  /// account sets a password, so the app also records it in user metadata.
  bool get hasPassword {
    if (currentUser?.userMetadata?[_hasPasswordKey] == true) return true;
    final providers = currentUser?.appMetadata['providers'];
    if (providers is List) return providers.contains('email');
    return provider == 'email';
  }

  Future<void> signOut() async {
    if (_googleReady) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}
    }
    try {
      await _auth.signOut();
    } catch (_) {
      // Offline or already-expired session: still drop it on this device.
      await _auth.signOut(scope: SignOutScope.local);
    }
  }

  /// Deletes the account server-side (store requirement, spec §8.8).
  Future<void> deleteAccount() => guard(() => _db.functions.invoke(EdgeFn.deleteAccount));
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(supabaseClientProvider)),
);
