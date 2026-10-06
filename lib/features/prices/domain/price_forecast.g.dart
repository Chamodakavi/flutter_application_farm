// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceForecast _$PriceForecastFromJson(Map<String, dynamic> json) =>
    _PriceForecast(
      cropName: json['crop_name'] as String,
      year: asInt(json['year']),
      month: asInt(json['month']),
      wholesalePrice: asDouble(json['wholesale_price']),
      retailPrice: asDoubleOrNull(json['retail_price']),
      fairPrice: asDoubleOrNull(json['fair_price']),
      floorPrice: asDoubleOrNull(json['floor_price']),
      costPerKg: asDoubleOrNull(json['cost_per_kg']),
      profitPerKg: asDoubleOrNull(json['profit_per_kg']),
      harvestGoalMt: asDoubleOrNull(json['harvest_goal_mt']),
      allowedExtentHa: asDoubleOrNull(json['allowed_extent_ha']),
      growthCycleMonths: asIntOrNull(json['growth_cycle_months']),
      plantingYear: asIntOrNull(json['planting_year']),
      plantingMonth: asIntOrNull(json['planting_month']),
      rainfallMm: asDoubleOrNull(json['rainfall_mm']),
      dieselLkr: asDoubleOrNull(json['diesel_lkr']),
      transportIndex: asDoubleOrNull(json['transport_index']),
      weatherMultiplier: asDoubleOrNull(json['weather_multiplier']),
      baselineSupplyMt: asDoubleOrNull(json['baseline_supply_mt']),
      modelVersion: json['model_version'] == null
          ? ''
          : asString(json['model_version']),
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$PriceForecastToJson(_PriceForecast instance) =>
    <String, dynamic>{
      'crop_name': instance.cropName,
      'year': instance.year,
      'month': instance.month,
      'wholesale_price': instance.wholesalePrice,
      'retail_price': instance.retailPrice,
      'fair_price': instance.fairPrice,
      'floor_price': instance.floorPrice,
      'cost_per_kg': instance.costPerKg,
      'profit_per_kg': instance.profitPerKg,
      'harvest_goal_mt': instance.harvestGoalMt,
      'allowed_extent_ha': instance.allowedExtentHa,
      'growth_cycle_months': instance.growthCycleMonths,
      'planting_year': instance.plantingYear,
      'planting_month': instance.plantingMonth,
      'rainfall_mm': instance.rainfallMm,
      'diesel_lkr': instance.dieselLkr,
      'transport_index': instance.transportIndex,
      'weather_multiplier': instance.weatherMultiplier,
      'baseline_supply_mt': instance.baselineSupplyMt,
      'model_version': instance.modelVersion,
      'generated_at': instance.generatedAt?.toIso8601String(),
    };
