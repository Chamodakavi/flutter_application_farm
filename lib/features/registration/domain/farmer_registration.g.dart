// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FarmerRegistration _$FarmerRegistrationFromJson(Map<String, dynamic> json) =>
    _FarmerRegistration(
      id: (json['id'] as num).toInt(),
      farmerId: json['farmer_id'] as String?,
      cropName: json['crop_name'] as String,
      amountMt: json['amount_mt'] == null ? 0 : asDouble(json['amount_mt']),
      registeredAt: json['registered_at'] == null
          ? null
          : DateTime.parse(json['registered_at'] as String),
    );

Map<String, dynamic> _$FarmerRegistrationToJson(_FarmerRegistration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmer_id': instance.farmerId,
      'crop_name': instance.cropName,
      'amount_mt': instance.amountMt,
      'registered_at': instance.registeredAt?.toIso8601String(),
    };

_CropRegistration _$CropRegistrationFromJson(Map<String, dynamic> json) =>
    _CropRegistration(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String?,
      cropName: json['crop_name'] as String,
      plantingDate: json['planting_date'] == null
          ? null
          : DateTime.parse(json['planting_date'] as String),
      harvestDate: json['harvest_date'] == null
          ? null
          : DateTime.parse(json['harvest_date'] as String),
      landSizeAcres: asDoubleOrNull(json['land_size_acres']),
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CropRegistrationToJson(_CropRegistration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'crop_name': instance.cropName,
      'planting_date': instance.plantingDate?.toIso8601String(),
      'harvest_date': instance.harvestDate?.toIso8601String(),
      'land_size_acres': instance.landSizeAcres,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };
