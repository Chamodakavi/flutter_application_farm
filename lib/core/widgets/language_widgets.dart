import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_service.dart';
import '../l10n/l10n_ext.dart';
import '../l10n/locale_provider.dart';
import '../notifications/push_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Applies a language choice: persists it, updates the push-token locale and
/// records the change for the evaluation.
Future<void> applyLocale(WidgetRef ref, String code) async {
  final before = ref.read(localeControllerProvider).languageCode;
  await ref.read(localeControllerProvider.notifier).set(code);
  if (before != code) {
    ref.read(analyticsProvider).track(AnalyticsEvents.languageChanged, {'from': before, 'to': code});
    await ref.read(pushServiceProvider).registerDevice();
  }
}

/// Globe icon that opens a quick language menu (auth screens' top-right).
class LanguageSwitcherButton extends ConsumerWidget {
  const LanguageSwitcherButton({super.key, this.color = AppColors.white});

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeControllerProvider).languageCode;
    return PopupMenuButton<String>(
      tooltip: context.l10n.languageSwitch,
      icon: Icon(Icons.language_rounded, color: color),
      onSelected: (code) => applyLocale(ref, code),
      itemBuilder: (_) => [
        for (final locale in AppLocales.all)
          PopupMenuItem(
            value: locale.languageCode,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocales.nativeName(locale.languageCode),
                    style: TextStyle(fontFamily: AppTypography.familyFor(locale)),
                  ),
                ),
                if (locale.languageCode == current)
                  const Icon(Icons.check_rounded, color: AppColors.green600, size: 18),
              ],
            ),
          ),
      ],
    );
  }
}

/// Three large radio cards — English, සිංහල, தமிழ் — each with a sample
/// sentence in its own script (first-run language screen and Settings).
class LanguageCards extends StatelessWidget {
  const LanguageCards({super.key, required this.selected, required this.onSelected});

  /// Language code currently highlighted.
  final String selected;
  final ValueChanged<String> onSelected;

  static const _samples = {
    'en': 'Plan before you plant.',
    'si': 'වගා කිරීමට පෙර සැලසුම් කරන්න.',
    'ta': 'நடுவதற்கு முன் திட்டமிடுங்கள்.',
  };

  @override
  Widget build(BuildContext context) => RadioGroup<String>(
    groupValue: selected,
    onChanged: (code) {
      if (code != null) onSelected(code);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final locale in AppLocales.all) ...[
          _LanguageCard(
            code: locale.languageCode,
            sample: _samples[locale.languageCode]!,
            selected: locale.languageCode == selected,
            onTap: () => onSelected(locale.languageCode),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    ),
  );
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.code,
    required this.sample,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String sample;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Locale(code);
    final family = AppTypography.familyFor(locale);
    final height = AppTypography.lineHeightFor(locale);
    return Material(
      color: selected ? AppColors.green100 : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
        side: BorderSide(
          color: selected ? AppColors.green600 : AppColors.line200,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocales.nativeName(code),
                      style: TextStyle(
                        fontFamily: family,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: height,
                        color: AppColors.forest900,
                      ),
                    ),
                    Text(
                      sample,
                      style: TextStyle(
                        fontFamily: family,
                        fontSize: 14,
                        height: height,
                        color: AppColors.ink500,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(value: code, activeColor: AppColors.green600),
            ],
          ),
        ),
      ),
    );
  }
}
