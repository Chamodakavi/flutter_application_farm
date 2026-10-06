import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/app_status.dart';
import '../../../core/utils/json_utils.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// A row of `orders`, optionally with its `order_items` embedded
/// (`select('*, order_items(*)')`).
@freezed
abstract class Order with _$Order {
  const Order._();

  const factory Order({
    required int id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_phone') String? userPhone,
    @JsonKey(name: 'total_amount', fromJson: asDouble) @Default(0) double totalAmount,
    @JsonKey(name: 'shipping_amount', fromJson: asDouble) @Default(0) double shippingAmount,
    String? status,
    @JsonKey(name: 'admin_note') String? adminNote,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'order_items') @Default(<OrderItem>[]) List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  AppStatus get statusEnum => AppStatus.fromDb(status);

  /// Only pending orders can be cancelled by the farmer (spec §11.17).
  bool get canCancel => statusEnum == AppStatus.pending;

  double get itemsSubtotal => items.fold(0, (sum, i) => sum + i.lineTotal);
}
