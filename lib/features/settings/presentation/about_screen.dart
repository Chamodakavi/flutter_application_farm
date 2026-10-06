import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_provider.dart';
import '../../../core/config/env.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/settings_actions.dart';
import 'widgets/settings_tiles.dart';

/// Settings → About (spec §11.26): version, web portal, privacy policy,
/// terms, credits and licences. The policy links are the ones the store
/// listing needs (spec §20.5).
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const privacyUrl = '${Env.webAppUrl}/privacy';
  static const termsUrl = '${Env.webAppUrl}/terms';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    // `0.0.0` means the platform could not report a version.
    final installed = ref.watch(appVersionProvider).value;
    final version = installed == '0.0.0' ? null : installed;

    return AppScaffold(
      title: l10n.settingsAbout,
      body: ListView(
        padding: AppSpacing.page,
        children: [
          SectionCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 40, color: AppColors.forest900),
                AppSpacing.gapSm,
                Text(
                  l10n.aboutTagline,
                  style: text.bodyMedium?.copyWith(color: AppColors.ink500),
                  textAlign: TextAlign.center,
                ),
                if (version != null) ...[
                  AppSpacing.gapXs,
                  Text(l10n.aboutVersion(version), style: text.bodySmall),
                ],
              ],
            ),
          ),
          AppSpacing.gapLg,
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.public_rounded,
                label: l10n.aboutWebPortal,
                external: true,
                onTap: () => openExternalLink(context, Env.webAppUrl),
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: l10n.aboutPrivacy,
                external: true,
                onTap: () => openExternalLink(context, privacyUrl),
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                label: l10n.aboutTerms,
                external: true,
                onTap: () => openExternalLink(context, termsUrl),
              ),
              SettingsTile(
                icon: Icons.article_outlined,
                label: l10n.aboutLicences,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appName,
                  applicationVersion: version,
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,
          SectionCard(
            title: l10n.aboutCreditsTitle,
            child: Text(l10n.aboutCredits, style: text.bodyMedium),
          ),
        ],
      ),
    );
  }
}
