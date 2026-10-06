import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/widgets.dart';

/// First-run language choice (spec §11.2). The title is shown in all three
/// scripts at once, so it is deliberately not a localized string.
class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  late String _selected = ref.read(localeControllerProvider).languageCode;
  bool _saving = false;

  Future<void> _continue() async {
    setState(() => _saving = true);
    // Persisting the choice is what lets the router guard leave this screen,
    // so save it even when the highlighted language is already the active one.
    await ref.read(localeControllerProvider.notifier).set(_selected);
    await applyLocale(ref, _selected);
    if (!mounted) return;
    context.go(ref.read(onboardingDoneProvider) ? Routes.login : Routes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    const titles = [
      (Locale('en'), 'Choose language'),
      (Locale('si'), 'භාෂාව තෝරන්න'),
      (Locale('ta'), 'மொழியைத் தேர்ந்தெடுக்கவும்'),
    ];
    return Scaffold(
      backgroundColor: AppColors.cream50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    const AppLogo(size: 56, showName: false, color: AppColors.green600),
                    const SizedBox(height: AppSpacing.xl),
                    for (final (locale, title) in titles)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTypography.familyFor(locale),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: AppTypography.lineHeightFor(locale),
                          color: AppColors.forest900,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxl),
                    LanguageCards(
                      selected: _selected,
                      onSelected: (code) => setState(() => _selected = code),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.sm,
                AppSpacing.xxl,
                AppSpacing.xl,
              ),
              // The label follows the highlighted language so the user can read it.
              child: Localizations.override(
                context: context,
                locale: Locale(_selected),
                child: Builder(
                  builder: (context) => PrimaryButton(
                    label: context.l10n.commonContinue,
                    onPressed: _continue,
                    loading: _saving,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
