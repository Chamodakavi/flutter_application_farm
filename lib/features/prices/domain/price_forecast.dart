import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'price_forecast.freezed.dart';
part 'price_forecast.g.dart';

/// One row of `crop_price_forecasts`: the output of the ML model for one crop
/// and one harvest month. The app only reads these rows (spec §7.7).
@freezed
abstract class PriceForecast with _$PriceForecast {
  const PriceForecast._();

  const factory PriceForecast({
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(fromJson: asInt) required int year,
    @JsonKey(fromJson: asInt) required int month, // harvest month
    @JsonKey(name: 'wholesale_price', fromJson: asDouble) required double wholesalePrice,
    @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? retailPrice,
    @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? fairPrice,
    @JsonKey(name: 'floor_price', fromJson: asDoubleOrNull) double? floorPrice,
    @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? costPerKg,
    @JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull) double? profitPerKg,
    @JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull) double? harvestGoalMt,
    @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,
    @JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull) int? growthCycleMonths,
    @JsonKey(name: 'planting_year', fromJson: asIntOrNull) int? plantingYear,
    @JsonKey(name: 'planting_month', fromJson: asIntOrNull) int? plantingMonth,
    @JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull) double? rainfallMm,
    @JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull) double? dieselLkr,
    @JsonKey(name: 'transport_index', fromJson: asDoubleOrNull) double? transportIndex,
    @JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull) double? weatherMultiplier,
    @JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull) double? baselineSupplyMt,
    @JsonKey(name: 'model_version', fromJson: asString) @Default('') String modelVersion,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
  }) = _PriceForecast;

  factory PriceForecast.fromJson(Map<String, dynamic> json) => _$PriceForecastFromJson(json);

  DateTime get harvestDate => DateTime(year, month);

  DateTime? get plantingDate => plantingYear == null || plantingMonth == null
      ? null
      : DateTime(plantingYear!, plantingMonth!);

  /// MT per hectare implied by the model (quota divided by allowed extent).
  double? get yieldMtPerHa => (harvestGoalMt != null && (allowedExtentHa ?? 0) > 0)
      ? harvestGoalMt! / allowedExtentHa!
      : null;

  /// Wholesale minus production cost, per kg.
  double? get marginPerKg => costPerKg == null ? null : wholesalePrice - costPerKg!;

  bool get aboveFair => fairPrice != null && wholesalePrice >= fairPrice!;

  bool get weatherShock => (weatherMultiplier ?? 1) > 1;

  bool isFor(int y, int m) => year == y && month == m;
}
