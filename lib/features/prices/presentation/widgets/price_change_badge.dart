import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/utils/formatters.dart';

/// Change vs. last month: ▲ 8.2% green, ▼ 5.1% red, — grey (spec §11.29).
class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({super.key, required this.changePct, this.compact = false});

  /// Change vs. last month in percent; null shows a neutral dash.
  final double? changePct;

  /// Plain coloured text without the tinted pill — for tight rows.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pct = changePct;
    // Anything that would print as 0.0% counts as "no change".
    final flat = pct == null || pct.abs() < 0.05;
    final up = !flat && pct > 0;

    final color = flat ? AppColors.ink500 : (up ? AppColors.green600 : AppColors.red600);
    final label = pct == null
        ? '—'
        : flat
        ? '— ${Fmt.percent(0)}'
        : '${up ? '▲' : '▼'} ${Fmt.percent(pct)}';
    final spoken = pct == null || flat
        ? l10n.pricesChangeFlat
        : up
        ? l10n.pricesChangeUp(Fmt.percent(pct))
        : l10n.pricesChangeDown(Fmt.percent(pct));

    final text = Text(
      label,
      maxLines: 1,
      semanticsLabel: spoken,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, height: 1.2),
    );
    if (compact) return text;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.pillBorder,
      ),
      child: text,
    );
  }
}
