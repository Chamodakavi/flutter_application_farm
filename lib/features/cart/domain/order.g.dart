// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String?,
  userName: json['user_name'] as String?,
  userEmail: json['user_email'] as String?,
  userPhone: json['user_phone'] as String?,
  totalAmount: json['total_amount'] == null
      ? 0
      : asDouble(json['total_amount']),
  shippingAmount: json['shipping_amount'] == null
      ? 0
      : asDouble(json['shipping_amount']),
  status: json['status'] as String?,
  adminNote: json['admin_note'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  items:
      (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderItem>[],
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'user_name': instance.userName,
  'user_email': instance.userEmail,
  'user_phone': instance.userPhone,
  'total_amount': instance.totalAmount,
  'shipping_amount': instance.shippingAmount,
  'status': instance.status,
  'admin_note': instance.adminNote,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'order_items': instance.items,
};
