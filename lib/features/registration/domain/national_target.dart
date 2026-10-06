import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'national_target.freezed.dart';
part 'national_target.g.dart';

/// A row of `national_targets`: an admin-approved quota for one crop.
@freezed
abstract class NationalTarget with _$NationalTarget {
  const factory NationalTarget({
    required int id,
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(name: 'target_limit_mt', fromJson: asDouble) required double targetLimitMt,
    @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,
    int? year,
    int? month,
    @JsonKey(name: 'target_harvest_date') String? targetHarvestDate,
    @JsonKey(name: 'planting_date') String? plantingDate,
    @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,
    // Column name is truncated in the ERD — confirm (spec §6.1).
    @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _NationalTarget;

  factory NationalTarget.fromJson(Map<String, dynamic> json) => _$NationalTargetFromJson(json);
}
