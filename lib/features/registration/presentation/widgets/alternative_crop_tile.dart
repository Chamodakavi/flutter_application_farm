import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/register_result.dart';

/// A crop that still has room, suggested when a quota is exceeded: name, the
/// "why" line (room left · fair price) and a "Choose" button (spec §13.2).
class AlternativeCropTile extends StatelessWidget {
  const AlternativeCropTile({super.key, required this.crop, required this.onChoose});

  final AlternativeCrop crop;

  /// Null disables the button (while the server is still confirming).
  final VoidCallback? onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final room = Fmt.amount(crop.remainingMt);
    final why = crop.fairPrice == null
        ? l10n.registerAltWhyNoPrice(room)
        : l10n.registerAltWhy(room, Fmt.perKg(crop.fairPrice));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.green100.withValues(alpha: 0.5),
        borderRadius: AppRadii.inputBorder,
        border: Border.all(color: AppColors.line200),
      ),
      child: Row(
        children: [
          CropAvatar(crop.cropName, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CropLabels.of(context, crop.cropName), style: text.titleSmall),
                const SizedBox(height: 2),
                Text(why, style: text.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: PillButton(
              label: l10n.registerAltChoose,
              style: PillStyle.green,
              onPressed: onChoose,
            ),
          ),
        ],
      ),
    );
  }
}
