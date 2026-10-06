import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/notification_settings_body.dart';

/// `/settings/notifications` — the Notifications tab of Settings as its own
/// page (spec §11.26).
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: context.l10n.settingsTabNotifications,
    body: const SingleChildScrollView(
      padding: AppSpacing.page,
      child: NotificationSettingsBody(),
    ),
  );
}
