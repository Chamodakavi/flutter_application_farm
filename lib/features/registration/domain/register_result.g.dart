// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlternativeCrop _$AlternativeCropFromJson(Map<String, dynamic> json) =>
    _AlternativeCrop(
      cropName: json['crop_name'] as String,
      remainingMt: json['remaining_mt'] == null
          ? 0
          : asDouble(json['remaining_mt']),
      fairPrice: asDoubleOrNull(json['target_fair_price']),
    );

Map<String, dynamic> _$AlternativeCropToJson(_AlternativeCrop instance) =>
    <String, dynamic>{
      'crop_name': instance.cropName,
      'remaining_mt': instance.remainingMt,
      'target_fair_price': instance.fairPrice,
    };

RegisterSuccess _$RegisterSuccessFromJson(Map<String, dynamic> json) =>
    RegisterSuccess(
      registrationId: asIntOrNull(json['registration_id']),
      cropName: json['crop_name'] as String?,
      remainingMt: asDoubleOrNull(json['remaining_mt']),
      $type: json['status'] as String?,
    );

Map<String, dynamic> _$RegisterSuccessToJson(RegisterSuccess instance) =>
    <String, dynamic>{
      'registration_id': instance.registrationId,
      'crop_name': instance.cropName,
      'remaining_mt': instance.remainingMt,
      'status': instance.$type,
    };

RegisterSurplus _$RegisterSurplusFromJson(Map<String, dynamic> json) =>
    RegisterSurplus(
      cropName: json['crop_name'] as String?,
      limitMt: json['limit_mt'] == null ? 0 : asDouble(json['limit_mt']),
      filledMt: json['filled_mt'] == null ? 0 : asDouble(json['filled_mt']),
      remainingMt: json['remaining_mt'] == null
          ? 0
          : asDouble(json['remaining_mt']),
      alternatives:
          (json['alternatives'] as List<dynamic>?)
              ?.map((e) => AlternativeCrop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AlternativeCrop>[],
      $type: json['status'] as String?,
    );

Map<String, dynamic> _$RegisterSurplusToJson(RegisterSurplus instance) =>
    <String, dynamic>{
      'crop_name': instance.cropName,
      'limit_mt': instance.limitMt,
      'filled_mt': instance.filledMt,
      'remaining_mt': instance.remainingMt,
      'alternatives': instance.alternatives,
      'status': instance.$type,
    };

RegisterNoTarget _$RegisterNoTargetFromJson(Map<String, dynamic> json) =>
    RegisterNoTarget($type: json['status'] as String?);

Map<String, dynamic> _$RegisterNoTargetToJson(RegisterNoTarget instance) =>
    <String, dynamic>{'status': instance.$type};

RegisterInvalid _$RegisterInvalidFromJson(Map<String, dynamic> json) =>
    RegisterInvalid($type: json['status'] as String?);

Map<String, dynamic> _$RegisterInvalidToJson(RegisterInvalid instance) =>
    <String, dynamic>{'status': instance.$type};

RegisterUnknown _$RegisterUnknownFromJson(Map<String, dynamic> json) =>
    RegisterUnknown($type: json['status'] as String?);

Map<String, dynamic> _$RegisterUnknownToJson(RegisterUnknown instance) =>
    <String, dynamic>{'status': instance.$type};
