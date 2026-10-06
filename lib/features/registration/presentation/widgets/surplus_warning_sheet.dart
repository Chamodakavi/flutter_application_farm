import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/bucket_rules.dart';
import '../../domain/register_result.dart';
import 'alternative_crop_tile.dart';

/// What the farmer decided on the surplus warning.
sealed class SurplusChoice {
  const SurplusChoice();
}

/// Switch to a suggested crop, keeping the amount.
class ChooseAlternative extends SurplusChoice {
  const ChooseAlternative(this.crop);
  final AlternativeCrop crop;
}

/// Register only what still fits.
class RegisterRemainder extends SurplusChoice {
  const RegisterRemainder(this.amountMt);
  final double amountMt;
}

/// What the sheet shows right now. It opens instantly from the cached bucket
/// with [confirming] true and is replaced by the RPC answer (spec §13.2).
class SurplusSheetState {
  const SurplusSheetState(this.surplus, {this.confirming = false});

  final RegisterSurplus surplus;
  final bool confirming;
}

/// "Quota exceeded" warning (spec §11.10): red header, gauge of filled vs.
/// limit, what is left, alternative crops and — when something still fits —
/// "Register remaining {x} MT".
class SurplusWarningSheet extends StatelessWidget {
  const SurplusWarningSheet({
    super.key,
    required this.surplus,
    required this.cropName,
    required this.requestedMt,
    this.thresholds = const SurplusThresholds(),
    this.confirming = false,
    this.onChoose,
    this.onRegisterRemaining,
  });

  final RegisterSurplus surplus;

  /// Database key of the crop that was asked for.
  final String cropName;
  final double requestedMt;
  final SurplusThresholds thresholds;

  /// The numbers come from the cache and the RPC has not answered yet:
  /// actions are disabled so nothing is registered twice.
  final bool confirming;
  final ValueChanged<AlternativeCrop>? onChoose;
  final ValueChanged<double>? onRegisterRemaining;

  /// Opens the sheet and follows [state] until the farmer decides. Resolves
  /// to null when the sheet is dismissed.
  static Future<SurplusChoice?> show(
    BuildContext context, {
    required ValueListenable<SurplusSheetState> state,
    required String cropName,
    required double requestedMt,
    SurplusThresholds thresholds = const SurplusThresholds(),
  }) => showAppBottomSheet<SurplusChoice>(
    context,
    builder: (sheetContext) => ValueListenableBuilder<SurplusSheetState>(
      valueListenable: state,
      builder: (_, value, _) => SurplusWarningSheet(
        surplus: value.surplus,
        cropName: cropName,
        requestedMt: requestedMt,
        thresholds: thresholds,
        confirming: value.confirming,
        onChoose: (crop) => Navigator.of(sheetContext).pop(ChooseAlternative(crop)),
        onRegisterRemaining: (amount) => Navigator.of(sheetContext).pop(RegisterRemainder(amount)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final crop = CropLabels.of(context, surplus.cropName ?? cropName);
    final ratio = surplus.limitMt <= 0
        ? 1.0
        : (surplus.filledMt / surplus.limitMt).clamp(0, 1).toDouble();
    final remainder = registrableRemainder(surplus.remainingMt);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.red100, borderRadius: AppRadii.inputBorder),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.red600),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.registerSurplusTitle(crop),
                    style: text.titleMedium?.copyWith(color: AppColors.red600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: QuotaGauge(ratio: ratio, level: thresholds.levelOfRatio(ratio), size: 180),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.quotaFilledOfLimit(Fmt.amount(surplus.filledMt), Fmt.amount(surplus.limitMt)),
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            remainder > 0
                ? l10n.registerSurplusBody(Fmt.amount(surplus.remainingMt))
                : l10n.registerSurplusBodyFull,
            style: text.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.registerSurplusRequested(Fmt.amount(requestedMt)),
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (confirming) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(child: Text(l10n.registerSurplusConfirming, style: text.bodySmall)),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.registerSurplusAlternatives, style: text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          if (surplus.alternatives.isEmpty)
            Text(l10n.registerSurplusNoAlternatives, style: text.bodyMedium)
          else
            for (final alternative in surplus.alternatives)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AlternativeCropTile(
                  crop: alternative,
                  onChoose: confirming || onChoose == null ? null : () => onChoose!(alternative),
                ),
              ),
          if (remainder > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            OnlineOnly(
              builder: (_, online) => SecondaryButton(
                label: l10n.registerRemainingCta(Fmt.amount(remainder)),
                icon: Icons.add_task_rounded,
                onPressed: confirming || !online || onRegisterRemaining == null
                    ? null
                    : () => onRegisterRemaining!(remainder),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(l10n.commonClose),
          ),
        ],
      ),
    );
  }
}
