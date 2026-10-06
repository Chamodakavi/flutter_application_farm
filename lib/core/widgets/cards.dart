import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// Soft card shadow matching the web (`0 2 8 rgba(0,0,0,.04)`).
const kCardShadow = [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))];

/// White rounded card with an optional header row.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color = AppColors.white,
    this.onTap,
  });

  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final hasHeader = title != null || trailing != null;
    final content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) Text(title!, style: text.titleMedium),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: text.bodySmall),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(child: trailing!),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          child,
        ],
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.cardBorder,
        border: Border.all(color: AppColors.line200),
        boxShadow: kCardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: AppRadii.cardBorder,
        clipBehavior: Clip.antiAlias,
        child: onTap == null ? content : InkWell(onTap: onTap, child: content),
      ),
    );
  }
}

/// Dark forest card with a pill label, title, text and action buttons — the
/// dashboard welcome hero.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    this.pillLabel,
    required this.title,
    this.text,
    this.actions = const [],
  });

  final String? pillLabel;
  final String title;
  final String? text;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(color: AppColors.forest900, borderRadius: AppRadii.heroBorder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pillLabel != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(color: AppColors.amber200, borderRadius: AppRadii.pillBorder),
              child: Text(
                pillLabel!,
                style: theme.labelSmall?.copyWith(color: AppColors.forest900),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(title, style: theme.displaySmall?.copyWith(color: AppColors.white)),
          if (text != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(text!, style: theme.bodyMedium?.copyWith(color: Colors.white70)),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Wrap(spacing: AppSpacing.md, runSpacing: AppSpacing.sm, children: actions),
          ],
        ],
      ),
    );
  }
}

/// Dashboard stat: title, big value, caption and an icon in a tinted circle.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.caption,
    required this.icon,
    this.tint = AppColors.white,
    this.iconColor = AppColors.green600,
    this.onTap,
    this.loading = false,
  });

  final String title;
  final String value;
  final String? caption;
  final IconData icon;
  final Color tint;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SectionCard(
      color: tint,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title, style: text.labelMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (loading)
            const SizedBox(
              height: 28,
              width: 28,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          else
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(value, style: text.displaySmall),
            ),
          if (caption != null) ...[
            const SizedBox(height: 2),
            Text(caption!, style: text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

/// Tinted tile with an icon circle, title and subtitle — dashboard shortcuts.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.tint = AppColors.green100,
    this.iconColor = AppColors.green600,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color tint;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: tint,
      borderRadius: AppRadii.cardBorder,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum InfoNoteTone { info, success, warning, danger }

/// Tinted note with an icon ("These quotas are locked in…").
class InfoNote extends StatelessWidget {
  const InfoNote({
    super.key,
    required this.text,
    this.icon,
    this.tone = InfoNoteTone.info,
    this.actionLabel,
    this.onAction,
  });

  final String text;
  final IconData? icon;
  final InfoNoteTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData defaultIcon) = switch (tone) {
      InfoNoteTone.info => (AppColors.blue100, AppColors.blue600, Icons.lightbulb_outline_rounded),
      InfoNoteTone.success => (
        AppColors.green100,
        AppColors.green600,
        Icons.check_circle_outline_rounded,
      ),
      InfoNoteTone.warning => (
        AppColors.weatherTint,
        AppColors.orange600,
        Icons.warning_amber_rounded,
      ),
      InfoNoteTone.danger => (AppColors.red100, AppColors.red600, Icons.error_outline_rounded),
    };
    final style = Theme.of(context).textTheme.bodyMedium;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.inputBorder),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? defaultIcon, color: fg, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: style),
                if (actionLabel != null && onAction != null)
                  InkWell(
                    onTap: onAction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Text(
                        actionLabel!,
                        style: style?.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: fg,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
