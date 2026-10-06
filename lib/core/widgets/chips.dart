import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../utils/app_status.dart';

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.background, required this.foreground, this.icon});

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: background, borderRadius: AppRadii.pillBorder),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 14, color: foreground), const SizedBox(width: 4)],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground, height: 1.2),
          ),
        ),
      ],
    ),
  );
}

/// Maps an order / crop-registration / complaint status string from the
/// database to a coloured, localized chip.
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key, this.showIcon = false});

  /// Raw database value (`Pending`, `Approved`, …) — parsed tolerantly.
  final String? status;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final s = AppStatus.fromDb(status);
    return _Pill(
      label: s.label(context.l10n, status),
      background: s.color.withValues(alpha: 0.12),
      foreground: s.color,
      icon: showIcon ? s.icon : null,
    );
  }
}

/// Quota fill level chip: Available / Filling up / Almost full / Full.
class SurplusChip extends StatelessWidget {
  const SurplusChip(this.level, {super.key});

  final SurplusLevel level;

  @override
  Widget build(BuildContext context) => _Pill(
    label: level.label(context.l10n),
    background: level.color.withValues(alpha: 0.12),
    foreground: level.color,
  );
}

/// Cream pill for a product type, or black pill for a news type.
class TypeBadge extends StatelessWidget {
  const TypeBadge(this.label, {super.key, this.dark = false});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) => _Pill(
    label: label,
    background: dark ? AppColors.ink900 : AppColors.cream50,
    foreground: dark ? AppColors.white : AppColors.forest900,
  );
}

/// Generic tinted pill for one-off labels ("Cash on Delivery", "3 Records").
class TagChip extends StatelessWidget {
  const TagChip(this.label, {super.key, this.color = AppColors.green600, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => _Pill(
    label: label,
    background: color.withValues(alpha: 0.12),
    foreground: color,
    icon: icon,
  );
}
