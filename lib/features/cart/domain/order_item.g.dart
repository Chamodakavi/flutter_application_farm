// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: (json['id'] as num).toInt(),
  orderId: asIntOrNull(json['order_id']),
  productId: asStringOrNull(json['product_id']),
  productName: json['product_name'] as String? ?? '',
  productImage: json['product_image'] as String?,
  productPrice: json['product_price'] == null
      ? 0
      : asDouble(json['product_price']),
  quantity: json['quantity'] == null ? 0 : asInt(json['quantity']),
  subtotal: asDoubleOrNull(json['subtotal']),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_image': instance.productImage,
      'product_price': instance.productPrice,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
      'created_at': instance.createdAt?.toIso8601String(),
    };

PlaceOrderSuccess _$PlaceOrderSuccessFromJson(Map<String, dynamic> json) =>
    PlaceOrderSuccess(
      orderId: asInt(json['order_id']),
      total: asDoubleOrNull(json['total']),
      shipping: asDoubleOrNull(json['shipping']),
      $type: json['status'] as String?,
    );

Map<String, dynamic> _$PlaceOrderSuccessToJson(PlaceOrderSuccess instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'total': instance.total,
      'shipping': instance.shipping,
      'status': instance.$type,
    };

PlaceOrderEmptyCart _$PlaceOrderEmptyCartFromJson(Map<String, dynamic> json) =>
    PlaceOrderEmptyCart($type: json['status'] as String?);

Map<String, dynamic> _$PlaceOrderEmptyCartToJson(
  PlaceOrderEmptyCart instance,
) => <String, dynamic>{'status': instance.$type};

PlaceOrderInsufficientStock _$PlaceOrderInsufficientStockFromJson(
  Map<String, dynamic> json,
) => PlaceOrderInsufficientStock(
  productId: asStringOrNull(json['product_id']),
  productName: json['product_name'] as String?,
  available: json['available'] == null ? 0 : asInt(json['available']),
  $type: json['status'] as String?,
);

Map<String, dynamic> _$PlaceOrderInsufficientStockToJson(
  PlaceOrderInsufficientStock instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'product_name': instance.productName,
  'available': instance.available,
  'status': instance.$type,
};

PlaceOrderUnknown _$PlaceOrderUnknownFromJson(Map<String, dynamic> json) =>
    PlaceOrderUnknown($type: json['status'] as String?);

Map<String, dynamic> _$PlaceOrderUnknownToJson(PlaceOrderUnknown instance) =>
    <String, dynamic>{'status': instance.$type};
