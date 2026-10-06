import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/account_settings_body.dart';

/// `/settings/account` — the Account tab of Settings as its own page
/// (spec §11.26).
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: context.l10n.settingsTabAccount,
    body: const SingleChildScrollView(
      padding: AppSpacing.page,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: AccountSettingsBody(),
    ),
  );
}
