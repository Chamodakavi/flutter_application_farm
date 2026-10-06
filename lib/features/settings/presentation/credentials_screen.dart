import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import 'widgets/credentials_body.dart';

/// `/settings/credentials` — the Credentials tab of Settings as its own page
/// (spec §11.26).
class CredentialsScreen extends StatelessWidget {
  const CredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: context.l10n.settingsTabCredentials,
    body: const SingleChildScrollView(
      padding: AppSpacing.page,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: CredentialsBody(),
    ),
  );
}
