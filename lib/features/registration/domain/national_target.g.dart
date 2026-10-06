// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'national_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NationalTarget _$NationalTargetFromJson(Map<String, dynamic> json) =>
    _NationalTarget(
      id: (json['id'] as num).toInt(),
      cropName: json['crop_name'] as String,
      targetLimitMt: asDouble(json['target_limit_mt']),
      allowedExtentHa: asDoubleOrNull(json['allowed_extent_ha']),
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      targetHarvestDate: json['target_harvest_date'] as String?,
      plantingDate: json['planting_date'] as String?,
      fairPrice: asDoubleOrNull(json['target_fair_price']),
      wholesalePrice: asDoubleOrNull(json['estimated_wholesale_price']),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$NationalTargetToJson(_NationalTarget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crop_name': instance.cropName,
      'target_limit_mt': instance.targetLimitMt,
      'allowed_extent_ha': instance.allowedExtentHa,
      'year': instance.year,
      'month': instance.month,
      'target_harvest_date': instance.targetHarvestDate,
      'planting_date': instance.plantingDate,
      'target_fair_price': instance.fairPrice,
      'estimated_wholesale_price': instance.wholesalePrice,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
