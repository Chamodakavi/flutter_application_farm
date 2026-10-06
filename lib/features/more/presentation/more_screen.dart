import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/l10n/district_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/domain/app_user.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../../settings/presentation/widgets/settings_actions.dart';
import '../../settings/presentation/widgets/settings_tiles.dart';

/// Tab 5 (spec §11.27, §9.1): profile header, every destination that has no
/// tab of its own, and Sign out.
class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  bool _signingOut = false;

  Future<void> _signOut() => confirmSignOut(
    context,
    ref,
    onBusy: (busy) {
      if (mounted) setState(() => _signingOut = busy);
    },
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider).value;

    SettingsTile link(IconData icon, String label, String route) =>
        SettingsTile(icon: icon, label: label, onTap: () => context.push(route));

    return AppScaffold(
      appBar: const FarmAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          kFabClearance,
        ),
        children: [
          _ProfileHeader(profile: profile, onTap: () => context.push(Routes.settings)),
          AppSpacing.gapXl,
          SettingsGroup(
            title: l10n.moreGroupFarming,
            children: [
              link(Icons.newspaper_rounded, l10n.moreNews, Routes.news),
              link(Icons.show_chart_rounded, l10n.morePrices, Routes.prices),
              link(Icons.calculate_outlined, l10n.morePlanner, Routes.planner),
              link(Icons.pie_chart_outline_rounded, l10n.moreOutlook, Routes.outlook),
            ],
          ),
          AppSpacing.gapXl,
          SettingsGroup(
            title: l10n.moreGroupActivity,
            children: [
              link(Icons.receipt_long_outlined, l10n.moreOrders, Routes.orders),
              link(Icons.eco_outlined, l10n.moreQuotas, Routes.myQuotas),
              link(Icons.support_agent_rounded, l10n.moreSupport, Routes.support),
              link(Icons.notifications_none_rounded, l10n.moreNotifications, Routes.notifications),
            ],
          ),
          AppSpacing.gapXl,
          SettingsGroup(
            title: l10n.moreGroupApp,
            children: [
              link(Icons.settings_outlined, l10n.settingsTitle, Routes.settings),
              link(Icons.language_rounded, l10n.settingsLanguage, Routes.settingsLanguage),
              SettingsTile(
                icon: Icons.public_rounded,
                label: l10n.aboutWebPortal,
                external: true,
                onTap: () => openExternalLink(context, Env.webAppUrl),
              ),
              link(Icons.info_outline_rounded, l10n.settingsAbout, Routes.settingsAbout),
            ],
          ),
          AppSpacing.gapXl,
          SettingsGroup(
            children: [
              SettingsTile(
                icon: Icons.logout_rounded,
                label: l10n.settingsSignOut,
                destructive: true,
                loading: _signingOut,
                onTap: _signOut,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Avatar, name, localized district and type; opens Settings.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile, required this.onTap});

  final AppUser? profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final name = profile?.displayName ?? '';
    final details = [
      Districts.label(context, profile?.district),
      userTypeLabel(l10n, profile?.userType),
    ].where((s) => s.isNotEmpty).join(' · ');

    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          AvatarCircle(
            url: profile?.avatarUrl,
            name: name.isNotEmpty ? name : profile?.email,
            radius: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name.isNotEmpty ? name : l10n.moreProfileNoName,
                  style: text.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  details.isNotEmpty ? details : l10n.moreProfileHint,
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right_rounded, color: AppColors.ink500),
        ],
      ),
    );
  }
}
