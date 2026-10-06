import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_providers.dart';
import '../../../auth/data/auth_repository.dart';

/// How the signed-in account can sign in — decides what Settings →
/// Credentials offers (spec §11.26, §8.9).
class CredentialsInfo {
  const CredentialsInfo({
    required this.provider,
    required this.hasPassword,
    this.phone,
    this.email,
  });

  /// `email`, `google` or `phone`.
  final String provider;

  /// An email + password identity exists, so "change password" makes sense.
  final bool hasPassword;

  /// `+947XXXXXXXX` for phone accounts.
  final String? phone;
  final String? email;

  bool get isGoogle => provider == 'google';
  bool get isPhone => provider == 'phone';
}

/// Re-evaluated on auth events, so the screen updates after a password or
/// email is added.
final credentialsInfoProvider = Provider.autoDispose<CredentialsInfo>((ref) {
  ref.watch(currentUserProvider);
  final auth = ref.watch(authRepositoryProvider);
  final user = auth.currentUser;
  final phone = user?.phone;
  final email = user?.email;
  return CredentialsInfo(
    provider: auth.provider,
    hasPassword: auth.hasPassword,
    phone: (phone == null || phone.isEmpty) ? null : (phone.startsWith('+') ? phone : '+$phone'),
    email: (email == null || email.isEmpty) ? null : email,
  );
});
