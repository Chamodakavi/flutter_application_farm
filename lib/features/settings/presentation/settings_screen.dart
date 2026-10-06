import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/account_settings_body.dart';
import 'widgets/credentials_body.dart';
import 'widgets/notification_settings_body.dart';
import 'widgets/settings_actions.dart';
import 'widgets/settings_tiles.dart';

/// Settings (spec §11.26): Account · Notifications · Credentials tabs like
/// the web, with Language, About, feedback and Sign out listed below the
/// selected tab.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 3, vsync: this)..addListener(_onTab);
  final _scroll = ScrollController();
  int _index = 0;
  bool _signingOut = false;

  void _onTab() {
    if (_tabs.index == _index) return;
    setState(() => _index = _tabs.index);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _scroll.dispose();
    super.dispose();
  }

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
    // Each body is written once and is also served by its own route
    // (/settings/account and so on). All three stay alive so a half-filled
    // form survives a tab switch.
    const bodies = [AccountSettingsBody(), NotificationSettingsBody(), CredentialsBody()];

    return AppScaffold(
      title: l10n.settingsTitle,
      body: Column(
        children: [
          Material(
            color: AppColors.white,
            child: TabBar(
              controller: _tabs,
              // All three stay on screen; long labels shrink instead of
              // scrolling out of view (see _SettingsTab).
              labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              tabs: [
                _SettingsTab(icon: Icons.person_outline_rounded, label: l10n.settingsTabAccount),
                _SettingsTab(
                  icon: Icons.notifications_none_rounded,
                  label: l10n.settingsTabNotifications,
                ),
                _SettingsTab(icon: Icons.lock_outline_rounded, label: l10n.settingsTabCredentials),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              padding: AppSpacing.page,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, body) in bodies.indexed)
                    Visibility(visible: i == _index, maintainState: true, child: body),
                  AppSpacing.gapXl,
                  SettingsGroup(
                    title: l10n.settingsGeneral,
                    children: [
                      SettingsTile(
                        icon: Icons.language_rounded,
                        label: l10n.settingsLanguage,
                        onTap: () => context.push(Routes.settingsLanguage),
                      ),
                      SettingsTile(
                        icon: Icons.info_outline_rounded,
                        label: l10n.settingsAbout,
                        onTap: () => context.push(Routes.settingsAbout),
                      ),
                      SettingsTile(
                        icon: Icons.rate_review_outlined,
                        label: l10n.settingsFeedback,
                        onTap: () => FeedbackSheet.show(context),
                      ),
                    ],
                  ),
                  AppSpacing.gapLg,
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
                  AppSpacing.gapLg,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon above the label. The label scales down to fit a third of the screen,
/// so Sinhala and Tamil names are never cut off on small phones.
class _SettingsTab extends StatelessWidget {
  const _SettingsTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Tab(
    height: 64,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 2),
        Flexible(
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)),
        ),
      ],
    ),
  );
}
