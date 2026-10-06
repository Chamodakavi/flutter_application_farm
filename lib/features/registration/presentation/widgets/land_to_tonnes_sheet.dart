import 'package:flutter/material.dart';

import '../../../../core/l10n/crop_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../prices/domain/price_forecast.dart';
import '../../../prices/domain/profit_plan.dart';

/// Tonnes the model expects from [landHa] hectares, rounded to one decimal
/// (spec §13.8). Null when the forecast row has no yield.
double? estimateTonnes(PriceForecast forecast, double landHa) {
  final yieldPerHa = forecast.yieldMtPerHa;
  if (yieldPerHa == null || landHa <= 0) return null;
  return Fmt.round(landHa * yieldPerHa, 1);
}

/// "Don't know the tonnage?" helper: land size in acres or hectares → MT,
/// using the model's yield for the crop's target harvest month.
class LandToTonnesSheet extends StatefulWidget {
  const LandToTonnesSheet({super.key, required this.forecast});

  /// Forecast row of the selected crop for its target harvest month.
  final PriceForecast forecast;

  /// Resolves to the estimated MT when the farmer taps "Use … MT".
  static Future<double?> show(BuildContext context, {required PriceForecast forecast}) =>
      showAppBottomSheet<double>(
        context,
        title: context.l10n.registerLandTitle,
        builder: (_) => LandToTonnesSheet(forecast: forecast),
      );

  @override
  State<LandToTonnesSheet> createState() => _LandToTonnesSheetState();
}

class _LandToTonnesSheetState extends State<LandToTonnesSheet> {
  final _land = TextEditingController();
  LandUnit _unit = LandUnit.acres;

  @override
  void dispose() {
    _land.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final forecast = widget.forecast;
    final size = double.tryParse(_land.text.trim());
    final estimate = size == null ? null : estimateTonnes(forecast, _unit.toHa(size));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.registerLandBody(
              CropLabels.of(context, forecast.cropName),
              Fmt.monthYear(forecast.harvestDate, context.localeTag),
            ),
            style: text.bodyMedium?.copyWith(color: AppColors.ink500),
          ),
          const SizedBox(height: AppSpacing.lg),
          LandUnitToggle(value: _unit, onChanged: (unit) => setState(() => _unit = unit)),
          const SizedBox(height: AppSpacing.md),
          AppTextField.number(
            label: l10n.registerLandSize,
            controller: _land,
            decimal: true,
            hint: l10n.plannerLandHint,
            prefixIcon: Icons.straighten_rounded,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.green100,
              borderRadius: AppRadii.inputBorder,
            ),
            child: Column(
              children: [
                Text(l10n.registerLandEstimate, style: text.labelMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(Fmt.mt(estimate), style: text.displaySmall),
                if (forecast.yieldMtPerHa != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.registerLandYield(Fmt.amount(forecast.yieldMtPerHa)),
                    style: text.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: estimate == null
                ? l10n.registerLandUseDisabled
                : l10n.registerLandUse(Fmt.amount(estimate)),
            onPressed: (estimate == null || estimate <= 0)
                ? null
                : () => Navigator.of(context).pop(estimate),
          ),
        ],
      ),
    );
  }
}

/// Acres / hectares switch (acres first — farmers usually think in acres).
class LandUnitToggle extends StatelessWidget {
  const LandUnitToggle({super.key, required this.value, required this.onChanged});

  final LandUnit value;
  final ValueChanged<LandUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<LandUnit>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: LandUnit.acres, label: Text(l10n.plannerAcres)),
        ButtonSegment(value: LandUnit.hectares, label: Text(l10n.plannerHectares)),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(AppSpacing.minTap, AppSpacing.minTap)),
      ),
    );
  }
}
