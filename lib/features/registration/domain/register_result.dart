import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/json_utils.dart';

part 'register_result.freezed.dart';
part 'register_result.g.dart';

/// A crop with room left, suggested by the server when a quota is exceeded.
@freezed
abstract class AlternativeCrop with _$AlternativeCrop {
  const factory AlternativeCrop({
    @JsonKey(name: 'crop_name') required String cropName,
    @JsonKey(name: 'remaining_mt', fromJson: asDouble) @Default(0) double remainingMt,
    @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,
  }) = _AlternativeCrop;

  factory AlternativeCrop.fromJson(Map<String, dynamic> json) => _$AlternativeCropFromJson(json);
}

/// Outcome of the `register_harvest` RPC, keyed on its `status` field
/// (spec §7.2, §13.1). The server is the source of truth for the quota check.
@Freezed(unionKey: 'status', fallbackUnion: 'unknown')
sealed class RegisterResult with _$RegisterResult {
  @FreezedUnionValue('success')
  const factory RegisterResult.success({
    @JsonKey(name: 'registration_id', fromJson: asIntOrNull) int? registrationId,
    @JsonKey(name: 'crop_name') String? cropName,
    @JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull) double? remainingMt,
  }) = RegisterSuccess;

  @FreezedUnionValue('surplus_warning')
  const factory RegisterResult.surplus({
    @JsonKey(name: 'crop_name') String? cropName,
    @JsonKey(name: 'limit_mt', fromJson: asDouble) @Default(0) double limitMt,
    @JsonKey(name: 'filled_mt', fromJson: asDouble) @Default(0) double filledMt,
    @JsonKey(name: 'remaining_mt', fromJson: asDouble) @Default(0) double remainingMt,
    @Default(<AlternativeCrop>[]) List<AlternativeCrop> alternatives,
  }) = RegisterSurplus;

  @FreezedUnionValue('no_target')
  const factory RegisterResult.noTarget() = RegisterNoTarget;

  @FreezedUnionValue('invalid_amount')
  const factory RegisterResult.invalid() = RegisterInvalid;

  /// A status this app version doesn't know.
  const factory RegisterResult.unknown() = RegisterUnknown;

  factory RegisterResult.fromJson(Map<String, dynamic> json) => _$RegisterResultFromJson(json);
}
