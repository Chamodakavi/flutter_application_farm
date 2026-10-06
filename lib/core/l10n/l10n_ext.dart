import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../errors/app_exception.dart';
import '../errors/error_mapper.dart';

export '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  /// Generated strings — no hard-coded user-facing text (spec §16.1).
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// `en`, `si` or `ta` — for `Fmt` date helpers.
  String get localeTag => Localizations.localeOf(this).languageCode;

  /// Localized text for anything a repository can throw.
  String errorMessage(Object error) => l10n.messageFor(mapError(error));

  void showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.maybeOf(this)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), action: action));
  }

  void showError(Object error) => showSnack(errorMessage(error));

  /// "Just now", "5 min ago", "3 h ago", "2 d ago", then a date.
  String relativeTime(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time.toLocal());
    if (diff.inMinutes < 1) return l10n.commonJustNow;
    if (diff.inHours < 1) return l10n.commonMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.commonHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.commonDaysAgo(diff.inDays);
    return MaterialLocalizations.of(this).formatShortDate(time.toLocal());
  }
}

extension AppExceptionMessage on AppLocalizations {
  String messageFor(AppException e) => switch (e) {
    NetworkException() => errorNetwork,
    PermissionFailure() => errorPermission,
    NotFoundFailure() => errorNotFound,
    ValidationFailure() => errorValidation,
    ConflictFailure(:final code) => switch (code) {
      'rate_limited' || 'chat_rate_limited' => errorRateLimited,
      _ => errorConflict,
    },
    AuthFailure(:final code) => switch (code) {
      'invalid_credentials' => authInvalidCredentials,
      'email_not_confirmed' => authEmailNotConfirmed,
      'user_already_exists' || 'email_exists' || 'phone_exists' => authUserExists,
      'weak_password' => authWeakPassword,
      'same_password' => authSamePassword,
      'otp_expired' => authOtpExpired,
      'invalid_otp' || 'otp_invalid' => authOtpInvalid,
      'over_request_rate_limit' ||
      'over_email_send_rate_limit' ||
      'over_sms_send_rate_limit' => authRateLimited,
      'session_expired' || 'session_not_found' => errorSessionExpired,
      'google_no_id_token' || 'google_failed' => authGoogleFailed,
      'wrong_password' => authWrongPassword,
      _ => errorUnknown,
    },
    UnknownFailure() => errorUnknown,
  };
}
