import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

/// A row of `order_items` — a snapshot of the product at order time.
@freezed
abstract class OrderItem with _$OrderItem {
  const OrderItem._();

  const factory OrderItem({
    required int id,
    @JsonKey(name: 'order_id', fromJson: asIntOrNull) int? orderId,
    @JsonKey(name: 'product_id', fromJson: asStringOrNull) String? productId,
    @JsonKey(name: 'product_name') @Default('') String productName,
    @JsonKey(name: 'product_image') String? productImage,
    @JsonKey(name: 'product_price', fromJson: asDouble) @Default(0) double productPrice,
    @JsonKey(fromJson: asInt) @Default(0) int quantity,
    @JsonKey(fromJson: asDoubleOrNull) double? subtotal,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  double get lineTotal => subtotal ?? productPrice * quantity;
}

/// Outcome of the `place_order` RPC, keyed on `status` (spec §7.2).
@Freezed(unionKey: 'status', fallbackUnion: 'unknown')
sealed class PlaceOrderResult with _$PlaceOrderResult {
  @FreezedUnionValue('success')
  const factory PlaceOrderResult.success({
    @JsonKey(name: 'order_id', fromJson: asInt) required int orderId,
    @JsonKey(fromJson: asDoubleOrNull) double? total,
    @JsonKey(fromJson: asDoubleOrNull) double? shipping,
  }) = PlaceOrderSuccess;

  @FreezedUnionValue('empty_cart')
  const factory PlaceOrderResult.emptyCart() = PlaceOrderEmptyCart;

  @FreezedUnionValue('insufficient_stock')
  const factory PlaceOrderResult.insufficientStock({
    @JsonKey(name: 'product_id', fromJson: asStringOrNull) String? productId,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(fromJson: asInt) @Default(0) int available,
  }) = PlaceOrderInsufficientStock;

  const factory PlaceOrderResult.unknown() = PlaceOrderUnknown;

  factory PlaceOrderResult.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderResultFromJson(json);
}

/// Outcome of the `cancel_order` RPC.
enum CancelOrderResult {
  success,
  notFound,
  notCancellable,
  unknown;

  static CancelOrderResult fromJson(Object? json) {
    final status = json is Map ? json['status']?.toString() : json?.toString();
    return switch (status) {
      'success' => success,
      'not_found' => notFound,
      'not_cancellable' => notCancellable,
      _ => unknown,
    };
  }
}
