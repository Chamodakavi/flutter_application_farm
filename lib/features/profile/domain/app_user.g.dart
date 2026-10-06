// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  name: json['u_name'] as String?,
  surname: json['u_surname'] as String?,
  email: json['u_email'] as String?,
  phone: json['u_tel'] as String?,
  district: json['u_district'] as String?,
  userType: json['u_type'] as String?,
  notify: json['u_notify'] as bool? ?? true,
  avatarUrl: json['u_avatar'] as String?,
  role: json['u_role'] as String? ?? 'farmer',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'u_name': instance.name,
  'u_surname': instance.surname,
  'u_email': instance.email,
  'u_tel': instance.phone,
  'u_district': instance.district,
  'u_type': instance.userType,
  'u_notify': instance.notify,
  'u_avatar': instance.avatarUrl,
  'u_role': instance.role,
  'created_at': instance.createdAt?.toIso8601String(),
};
