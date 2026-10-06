import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/notifications/local_notifications.dart';
import '../../../../core/notifications/push_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

/// Settings → Notifications (spec §11.26, §17.2): the server-side master
/// switch `users.u_notify`, per-type switches kept on this phone, and the OS
/// permission prompt. Not scrollable by itself.
class NotificationSettingsBody extends ConsumerStatefulWidget {
  const NotificationSettingsBody({super.key});

  @override
  ConsumerState<NotificationSettingsBody> createState() => _NotificationSettingsBodyState();
}

class _NotificationSettingsBodyState extends ConsumerState<NotificationSettingsBody> {
  bool _requesting = false;

  Future<void> _setMaster(bool value) async {
    try {
      await ref.read(profileProvider.notifier).setNotify(value);
    } catch (e) {
      if (mounted) context.showError(e);
    }
  }

  Future<void> _enablePush() async {
    final l10n = context.l10n;
    setState(() => _requesting = true);
    try {
      final granted = await ref.read(pushServiceProvider).requestPermission(force: true);
      if (mounted) context.showSnack(granted ? l10n.settingsPushEnabled : l10n.settingsPushDenied);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(profileProvider).value;
    final prefs = ref.watch(notificationPrefsProvider);
    final online = ref.watch(isOnlineProvider);
    final master = profile?.notify ?? true;
    final local = ref.read(notificationPrefsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: _SwitchRow(
            icon: Icons.notifications_active_outlined,
            title: l10n.settingsNotifyMaster,
            subtitle: l10n.settingsNotifyMasterHint,
            value: master,
            // Saved on the server, so it needs a connection and a profile.
            onChanged: profile != null && online ? _setMaster : null,
          ),
        ),
        AppSpacing.gapLg,
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, AppSpacing.xs, AppSpacing.sm),
          child: Text(
            l10n.settingsNotifyDeviceTitle,
            style: text.labelMedium?.copyWith(color: AppColors.ink500),
          ),
        ),
        SectionCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SwitchRow(
                icon: Icons.local_shipping_outlined,
                title: l10n.settingsNotifyOrders,
                subtitle: l10n.settingsNotifyOrdersHint,
                value: master && prefs.orders,
                onChanged: master ? local.setOrders : null,
              ),
              const Divider(height: 1, indent: 68, endIndent: AppSpacing.lg),
              _SwitchRow(
                icon: Icons.forum_outlined,
                title: l10n.settingsNotifyCommunity,
                subtitle: l10n.settingsNotifyCommunityHint,
                value: master && prefs.community,
                onChanged: master ? local.setCommunity : null,
              ),
              const Divider(height: 1, indent: 68, endIndent: AppSpacing.lg),
              _SwitchRow(
                icon: Icons.campaign_outlined,
                title: l10n.settingsNotifyNews,
                subtitle: l10n.settingsNotifyNewsHint,
                value: master && prefs.news,
                onChanged: master ? local.setNews : null,
              ),
            ],
          ),
        ),
        AppSpacing.gapLg,
        SectionCard(
          title: l10n.settingsPushTitle,
          subtitle: l10n.settingsPushHint,
          child: SecondaryButton(
            label: l10n.settingsEnablePush,
            icon: Icons.notifications_outlined,
            loading: _requesting,
            onPressed: _enablePush,
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      secondary: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: AppColors.green100, shape: BoxShape.circle),
        child: Icon(icon, size: 22, color: AppColors.green600),
      ),
      title: Text(title, style: text.titleSmall),
      subtitle: Text(subtitle, style: text.bodySmall),
      value: value,
      onChanged: onChanged,
    );
  }
}
