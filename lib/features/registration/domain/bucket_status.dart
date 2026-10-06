import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/app_status.dart';
import '../../../core/utils/json_utils.dart';

export '../../../core/utils/app_status.dart' show SurplusLevel;

part 'bucket_status.freezed.dart';
part 'bucket_status.g.dart';

/// One crop's "national bucket": quota vs. registered supply. Returned by the
/// `get_bucket_status()` RPC (spec §7.2).
@freezed
abstract class BucketStatus with _$BucketStatus {
  const BucketStatus._();

  const factory BucketStatus({
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(name: 'target_limit_mt', fromJson: asDouble) required double limitMt,
    @JsonKey(name: 'filled_mt', fromJson: asDouble) @Default(0) double filledMt,
    @JsonKey(name: 'remaining_mt', fromJson: asDouble) @Default(0) double remainingMt,
    @JsonKey(name: 'farmer_count', fromJson: asInt) @Default(0) int farmerCount,
    @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,
    @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,
    @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,
    @JsonKey(name: 'target_harvest_date') String? harvestDate,
    @JsonKey(name: 'planting_date') String? plantingDate,
    @JsonKey(fromJson: asIntOrNull) int? year,
    @JsonKey(fromJson: asIntOrNull) int? month,
  }) = _BucketStatus;

  factory BucketStatus.fromJson(Map<String, dynamic> json) => _$BucketStatusFromJson(json);

  /// 0–1; a crop with no limit counts as full.
  double get fillRatio => limitMt <= 0 ? 1 : (filledMt / limitMt).clamp(0, 1).toDouble();

  int get fillPercent => (fillRatio * 100).round();

  SurplusLevel get level => SurplusLevel.fromRatio(fillRatio);

  bool get isFull => level == SurplusLevel.full;

  /// Whether [amountMt] still fits in the remaining quota.
  bool fits(double amountMt) => amountMt <= remainingMt;

  /// First day of the target harvest month, when the RPC provides it.
  DateTime? get harvestMonth => (year == null || month == null) ? null : DateTime(year!, month!);
}
