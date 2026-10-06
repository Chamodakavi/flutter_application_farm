import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';

/// Shown after an email sign-up that needs confirmation (spec §11.5).
class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key, this.email});

  final String? email;

  Future<void> _openEmailApp(BuildContext context) async {
    final opened = await launchUrl(Uri(scheme: 'mailto'), mode: LaunchMode.externalApplication)
        .catchError((_) => false);
    if (!opened && context.mounted) context.showSnack(context.l10n.errorUnknown);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      title: l10n.authCheckEmailTitle,
      children: [
        const Icon(Icons.mark_email_unread_outlined, size: 56, color: AppColors.green600),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authCheckEmailBody(email ?? ''),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: l10n.authOpenEmailApp,
          icon: Icons.open_in_new_rounded,
          onPressed: () => _openEmailApp(context),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(label: l10n.authBackToLogin, onPressed: () => context.go(Routes.login)),
      ],
    );
  }
}
