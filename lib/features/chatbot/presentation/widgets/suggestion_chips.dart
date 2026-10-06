import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

/// The four starter questions on the empty chat (spec §14.3); a tap sends it.
class SuggestionChips extends StatelessWidget {
  const SuggestionChips({super.key, required this.onSelected});

  /// Null while offline or while a reply is pending — the chips are disabled.
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final suggestions = [
      (Icons.eco_outlined, l10n.chatSuggestionCrop),
      (Icons.trending_up_rounded, l10n.chatSuggestionPrice),
      (Icons.storefront_outlined, l10n.chatSuggestionSeeds),
      (Icons.bug_report_outlined, l10n.chatSuggestionDisease),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (icon, text) in suggestions)
          _SuggestionChip(
            icon: icon,
            text: text,
            onTap: onSelected == null ? null : () => onSelected!(text),
          ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.icon, required this.text, required this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = enabled ? AppColors.forest900 : AppColors.ink500;
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
        side: BorderSide(color: enabled ? AppColors.green600 : AppColors.line200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.minTap),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: enabled ? AppColors.green600 : AppColors.ink500),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
