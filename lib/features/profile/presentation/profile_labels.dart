import '../../../l10n/app_localizations.dart';
import '../domain/app_user.dart';

/// Localized label for a stored `users.u_type` value. The database keeps the
/// English value; unknown values (added on the web later) pass through.
String userTypeLabel(AppLocalizations l10n, String? value) {
  final v = value?.trim().toLowerCase();
  if (v == UserTypes.farmer.toLowerCase()) return l10n.profileTypeFarmer;
  if (v == UserTypes.buyer.toLowerCase()) return l10n.profileTypeBuyer;
  if (v == UserTypes.officer.toLowerCase()) return l10n.profileTypeOfficer;
  return value ?? '';
}
