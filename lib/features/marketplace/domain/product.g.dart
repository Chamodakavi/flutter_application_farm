// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  weight: json['weight'] as String?,
  price: json['price'] == null ? 0 : asDouble(json['price']),
  type: json['type'] as String?,
  stock: json['stock'] == null ? 0 : asInt(json['stock']),
  image: json['image'] as String?,
  category: json['category'] as String?,
  images: json['images'] == null
      ? const <String>[]
      : asStringList(json['images']),
  description: json['description'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'weight': instance.weight,
  'price': instance.price,
  'type': instance.type,
  'stock': instance.stock,
  'image': instance.image,
  'category': instance.category,
  'images': instance.images,
  'description': instance.description,
  'created_at': instance.createdAt?.toIso8601String(),
};
