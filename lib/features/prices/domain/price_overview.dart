import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'price_overview.freezed.dart';
part 'price_overview.g.dart';

/// One row of the `crop_price_overview` view: the price of a crop this month
/// and the change against last month.
@freezed
abstract class PriceOverview with _$PriceOverview {
  const PriceOverview._();

  const factory PriceOverview({
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,
    @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? retailPrice,
    @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? fairPrice,
    @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? costPerKg,
    @JsonKey(name: 'prev_price', fromJson: asDoubleOrNull) double? prevPrice,
    @JsonKey(name: 'change_pct', fromJson: asDoubleOrNull) double? changePct,
    @JsonKey(name: 'model_version') String? modelVersion,
    @JsonKey(name: 'generated_at') DateTime? generatedAt,
  }) = _PriceOverview;

  factory PriceOverview.fromJson(Map<String, dynamic> json) => _$PriceOverviewFromJson(json);

  /// Change vs. last month in percent; computed when the view omits it.
  double? get change {
    if (changePct != null) return changePct;
    if (wholesalePrice == null || prevPrice == null || prevPrice == 0) return null;
    return (wholesalePrice! - prevPrice!) / prevPrice! * 100;
  }

  double? get marginPerKg =>
      (wholesalePrice == null || costPerKg == null) ? null : wholesalePrice! - costPerKg!;

  bool get aboveFair =>
      wholesalePrice != null && fairPrice != null && wholesalePrice! >= fairPrice!;
}
