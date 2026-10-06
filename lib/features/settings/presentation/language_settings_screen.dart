import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

/// Settings → Language: the same three cards as the first-run screen
/// (spec §11.2). The choice applies immediately.
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selected = ref.watch(localeControllerProvider).languageCode;
    return AppScaffold(
      title: l10n.settingsLanguage,
      body: ListView(
        padding: AppSpacing.page,
        children: [
          Text(
            l10n.settingsLanguageHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink500),
          ),
          AppSpacing.gapLg,
          LanguageCards(selected: selected, onSelected: (code) => applyLocale(ref, code)),
        ],
      ),
    );
  }
}
