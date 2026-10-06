// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BucketStatus _$BucketStatusFromJson(Map<String, dynamic> json) =>
    _BucketStatus(
      cropName: json['crop_name'] as String,
      limitMt: asDouble(json['target_limit_mt']),
      filledMt: json['filled_mt'] == null ? 0 : asDouble(json['filled_mt']),
      remainingMt: json['remaining_mt'] == null
          ? 0
          : asDouble(json['remaining_mt']),
      farmerCount: json['farmer_count'] == null
          ? 0
          : asInt(json['farmer_count']),
      fairPrice: asDoubleOrNull(json['target_fair_price']),
      wholesalePrice: asDoubleOrNull(json['estimated_wholesale_price']),
      allowedExtentHa: asDoubleOrNull(json['allowed_extent_ha']),
      harvestDate: json['target_harvest_date'] as String?,
      plantingDate: json['planting_date'] as String?,
      year: asIntOrNull(json['year']),
      month: asIntOrNull(json['month']),
    );

Map<String, dynamic> _$BucketStatusToJson(_BucketStatus instance) =>
    <String, dynamic>{
      'crop_name': instance.cropName,
      'target_limit_mt': instance.limitMt,
      'filled_mt': instance.filledMt,
      'remaining_mt': instance.remainingMt,
      'farmer_count': instance.farmerCount,
      'target_fair_price': instance.fairPrice,
      'estimated_wholesale_price': instance.wholesalePrice,
      'allowed_extent_ha': instance.allowedExtentHa,
      'target_harvest_date': instance.harvestDate,
      'planting_date': instance.plantingDate,
      'year': instance.year,
      'month': instance.month,
    };
