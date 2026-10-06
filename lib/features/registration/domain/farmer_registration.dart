import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'farmer_registration.freezed.dart';
part 'farmer_registration.g.dart';

/// A row of `farmer_registrations`: a locked-in harvest quota in MT. Written
/// only by the `register_harvest` RPC.
@freezed
abstract class FarmerRegistration with _$FarmerRegistration {
  const factory FarmerRegistration({
    required int id,
    @JsonKey(name: 'farmer_id') String? farmerId,
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(name: 'amount_mt', fromJson: asDouble) @Default(0) double amountMt,
    @JsonKey(name: 'registered_at') DateTime? registeredAt,
  }) = _FarmerRegistration;

  factory FarmerRegistration.fromJson(Map<String, dynamic> json) =>
      _$FarmerRegistrationFromJson(json);
}

/// A row of `crop_registrations` — drives the Approved / Pending badge on the
/// dashboard (spec §22.1).
@freezed
abstract class CropRegistration with _$CropRegistration {
  const factory CropRegistration({
    required int id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(name: 'planting_date') DateTime? plantingDate,
    @JsonKey(name: 'harvest_date') DateTime? harvestDate,
    @JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull) double? landSizeAcres,
    String? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CropRegistration;

  factory CropRegistration.fromJson(Map<String, dynamic> json) =>
      _$CropRegistrationFromJson(json);
}
