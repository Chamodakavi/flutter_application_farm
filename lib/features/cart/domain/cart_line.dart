import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';
import '../../marketplace/domain/product.dart';

part 'cart_line.freezed.dart';

/// A `cart` row joined with its product. `cart.product_id` is `varchar`, so it
/// is kept as a string and matched against `'${product.id}'`.
@freezed
abstract class CartLine with _$CartLine {
  const CartLine._();

  const factory CartLine({
    required int id,
    required String productId,
    required int qty,
    required Product product,
    DateTime? createdAt,
  }) = _CartLine;

  /// Builds a line from a raw `cart` row and the product it points to.
  factory CartLine.fromRow(Map<String, dynamic> row, Product product) => CartLine(
    id: asInt(row['id']),
    productId: asString(row['product_id']),
    qty: asInt(row['qty']),
    product: product,
    createdAt: asDateOrNull(row['created_at']),
  );

  double get subtotal => product.price * qty;

  /// More in the cart than the shop currently has.
  bool get exceedsStock => qty > product.stock;
}

/// Display totals. Estimates only — `place_order` returns the real total.
@freezed
abstract class CartTotals with _$CartTotals {
  const CartTotals._();

  const factory CartTotals({@Default(0) double subtotal, @Default(0) double shipping}) =
      _CartTotals;

  double get total => subtotal + shipping;
}
