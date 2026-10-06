import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// A row of `products` (marketplace item).
@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required int id,
    @Default('') String name,
    String? weight,
    @JsonKey(fromJson: asDouble) @Default(0) double price,
    String? type,
    @JsonKey(fromJson: asInt) @Default(0) int stock, // varchar in the database
    String? image,
    String? category,
    @JsonKey(fromJson: asStringList) @Default(<String>[]) List<String> images,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  bool get inStock => stock > 0;

  /// Main image first, then the extra images without duplicates.
  List<String> get gallery => [
    if (image != null && image!.isNotEmpty) image!,
    ...images.where((i) => i.isNotEmpty && i != image),
  ];
}
