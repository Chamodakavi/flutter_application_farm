import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';

/// A titled white card holding [SettingsTile]s — used by Settings and the
/// More tab.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, AppSpacing.xs, AppSpacing.sm),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.ink500),
            ),
          ),
        SectionCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0) const Divider(height: 1, indent: 68, endIndent: AppSpacing.lg),
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Icon + label row with a chevron (spec §1.3: icon and label everywhere).
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.external = false,
    this.destructive = false,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;

  /// Opens outside the app (web portal, policies).
  final bool external;

  /// Red styling for "Sign out".
  final bool destructive;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = destructive ? AppColors.red600 : AppColors.green600;
    return ListTile(
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      onTap: loading ? null : onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: destructive ? AppColors.red100 : AppColors.green100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: color),
      ),
      title: Text(
        label,
        style: text.titleSmall?.copyWith(color: destructive ? AppColors.red600 : null),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!, style: text.bodySmall),
      trailing: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : destructive
          ? null
          : Icon(
              external ? Icons.open_in_new_rounded : Icons.chevron_right_rounded,
              size: external ? 20 : 24,
              color: AppColors.ink500,
            ),
    );
  }
}
