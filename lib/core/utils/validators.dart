import '../../l10n/app_localizations.dart';
import '../config/constants.dart';

/// Pure checks (unit-tested) plus `FormField` validators that return localized
/// messages.
abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final _phone = RegExp(r'^(?:\+94|0)?7\d{8}$');
  static final _mobileDigits = RegExp(r'^7\d{8}$');
  static final _letter = RegExp(r'[A-Za-z]');
  static final _digit = RegExp(r'\d');
  static final _amount = RegExp(r'^\d+(\.\d{1,2})?$');

  static bool isEmail(String? v) => v != null && _email.hasMatch(v.trim());

  /// Sri Lankan mobile number: `+947XXXXXXXX`, `07XXXXXXXX` or `7XXXXXXXX`.
  static bool isPhone(String? v) => v != null && _phone.hasMatch(_compact(v));

  /// The 9 digits typed after the fixed `+94` prefix (spec §8.9).
  static bool isMobileDigits(String? v) => v != null && _mobileDigits.hasMatch(_compact(v));

  /// Min 8 chars with at least one letter and one number (matches web).
  static bool isStrongPassword(String? v) =>
      v != null && v.length >= 8 && _letter.hasMatch(v) && _digit.hasMatch(v);

  /// Positive, at most two decimals, not above [max].
  static bool isAmount(String? v, {double max = AppConst.maxHarvestMt}) {
    if (v == null || !_amount.hasMatch(v.trim())) return false;
    final n = double.tryParse(v.trim());
    return n != null && n > 0 && n <= max;
  }

  /// Canonical `+947XXXXXXXX`, or null when [v] is not a valid mobile number.
  static String? normalizePhone(String? v) {
    if (!isPhone(v)) return null;
    final s = _compact(v!);
    return '+94${s.substring(s.length - 9)}';
  }

  static String _compact(String v) => v.replaceAll(RegExp(r'[\s-]'), '');

  // --- FormField validators -------------------------------------------------

  static String? Function(String?) required(AppLocalizations l10n) =>
      (v) => (v == null || v.trim().isEmpty) ? l10n.validationRequired : null;

  static String? Function(String?) email(AppLocalizations l10n) => (v) {
    if (v == null || v.trim().isEmpty) return l10n.validationRequired;
    return isEmail(v) ? null : l10n.validationEmail;
  };

  static String? Function(String?) password(AppLocalizations l10n) => (v) {
    if (v == null || v.isEmpty) return l10n.validationRequired;
    return isStrongPassword(v) ? null : l10n.validationPassword;
  };

  static String? Function(String?) confirmPassword(
    AppLocalizations l10n,
    String Function() original,
  ) => (v) {
    if (v == null || v.isEmpty) return l10n.validationRequired;
    return v == original() ? null : l10n.validationPasswordMismatch;
  };

  static String? Function(String?) phone(AppLocalizations l10n) => (v) {
    if (v == null || v.trim().isEmpty) return l10n.validationRequired;
    return isPhone(v) ? null : l10n.validationPhone;
  };

  static String? Function(String?) mobileDigits(AppLocalizations l10n) => (v) {
    if (v == null || v.trim().isEmpty) return l10n.validationRequired;
    return isMobileDigits(v) ? null : l10n.validationPhone;
  };

  static String? Function(String?) amount(
    AppLocalizations l10n, {
    double max = AppConst.maxHarvestMt,
  }) => (v) {
    if (v == null || v.trim().isEmpty) return l10n.validationRequired;
    return isAmount(v, max: max) ? null : l10n.validationAmount;
  };

  static String? Function(String?) maxLength(AppLocalizations l10n, int max) =>
      (v) => (v != null && v.length > max) ? l10n.validationTooLong(max) : null;
}
