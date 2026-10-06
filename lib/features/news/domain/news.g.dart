// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_News _$NewsFromJson(Map<String, dynamic> json) => _News(
  id: (json['n_id'] as num).toInt(),
  image: json['n_img'] as String?,
  title: json['n_title'] as String? ?? '',
  description: json['n_description'] as String? ?? '',
  type: json['n_type'] as String?,
  author: json['n_author'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$NewsToJson(_News instance) => <String, dynamic>{
  'n_id': instance.id,
  'n_img': instance.image,
  'n_title': instance.title,
  'n_description': instance.description,
  'n_type': instance.type,
  'n_author': instance.author,
  'created_at': instance.createdAt?.toIso8601String(),
};
