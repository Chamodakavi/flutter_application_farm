import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/domain/app_user.dart';

/// Opens [url] in the browser (web portal, privacy policy, terms).
Future<void> openExternalLink(BuildContext context, String url) async {
  final failed = context.l10n.aboutLinkFailed;
  var opened = false;
  try {
    opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    // No browser, or the platform refused the link.
  }
  if (!opened && context.mounted) context.showSnack(failed);
}

/// Confirm dialog, then sign out (spec §8.5). The router returns to Login by
/// itself once the session is gone. [onBusy] is called with true once the
/// user has confirmed and with false if signing out failed.
Future<void> confirmSignOut(
  BuildContext context,
  WidgetRef ref, {
  void Function(bool busy)? onBusy,
}) async {
  final l10n = context.l10n;
  final auth = ref.read(authControllerProvider);
  final confirmed = await ConfirmDialog.show(
    context,
    title: l10n.settingsSignOutConfirmTitle,
    message: l10n.settingsSignOutConfirmMessage,
    confirmLabel: l10n.settingsSignOut,
    destructive: true,
  );
  if (!confirmed) return;
  onBusy?.call(true);
  try {
    await auth.signOut();
  } catch (e) {
    onBusy?.call(false);
    if (context.mounted) context.showError(e);
  }
}

/// Localized name of a stored `u_type`. The English value is what is saved;
/// values the app does not know (set on the web) pass through unchanged.
String userTypeLabel(AppLocalizations l10n, String? type) {
  final value = type?.trim() ?? '';
  return switch (value.toLowerCase()) {
    'farmer' => l10n.settingsTypeFarmer,
    'buyer' => l10n.settingsTypeBuyer,
    'agricultural officer' => l10n.settingsTypeOfficer,
    _ => value,
  };
}

/// The stored value matching [type] from [UserTypes.all], ignoring case.
String? knownUserType(String? type) {
  final value = type?.trim().toLowerCase();
  for (final t in UserTypes.all) {
    if (t.toLowerCase() == value) return t;
  }
  return null;
}
