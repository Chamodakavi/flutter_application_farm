// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceOverview _$PriceOverviewFromJson(Map<String, dynamic> json) =>
    _PriceOverview(
      cropName: json['crop_name'] as String,
      wholesalePrice: asDoubleOrNull(json['wholesale_price']),
      retailPrice: asDoubleOrNull(json['retail_price']),
      fairPrice: asDoubleOrNull(json['fair_price']),
      costPerKg: asDoubleOrNull(json['cost_per_kg']),
      prevPrice: asDoubleOrNull(json['prev_price']),
      changePct: asDoubleOrNull(json['change_pct']),
      modelVersion: json['model_version'] as String?,
      generatedAt: json['generated_at'] == null
          ? null
          : DateTime.parse(json['generated_at'] as String),
    );

Map<String, dynamic> _$PriceOverviewToJson(_PriceOverview instance) =>
    <String, dynamic>{
      'crop_name': instance.cropName,
      'wholesale_price': instance.wholesalePrice,
      'retail_price': instance.retailPrice,
      'fair_price': instance.fairPrice,
      'cost_per_kg': instance.costPerKg,
      'prev_price': instance.prevPrice,
      'change_pct': instance.changePct,
      'model_version': instance.modelVersion,
      'generated_at': instance.generatedAt?.toIso8601String(),
    };
