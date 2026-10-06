// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bucket_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BucketStatus {

@JsonKey(name: 'crop_name') String get cropName;@JsonKey(name: 'target_limit_mt', fromJson: asDouble) double get limitMt;@JsonKey(name: 'filled_mt', fromJson: asDouble) double get filledMt;@JsonKey(name: 'remaining_mt', fromJson: asDouble) double get remainingMt;@JsonKey(name: 'farmer_count', fromJson: asInt) int get farmerCount;@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? get fairPrice;@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? get wholesalePrice;@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? get allowedExtentHa;@JsonKey(name: 'target_harvest_date') String? get harvestDate;@JsonKey(name: 'planting_date') String? get plantingDate;@JsonKey(fromJson: asIntOrNull) int? get year;@JsonKey(fromJson: asIntOrNull) int? get month;
/// Create a copy of BucketStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BucketStatusCopyWith<BucketStatus> get copyWith => _$BucketStatusCopyWithImpl<BucketStatus>(this as BucketStatus, _$identity);

  /// Serializes this BucketStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BucketStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BucketStatus&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.limitMt, _this.limitMt) || other.limitMt == _this.limitMt)&&(identical(other.filledMt, _this.filledMt) || other.filledMt == _this.filledMt)&&(identical(other.remainingMt, _this.remainingMt) || other.remainingMt == _this.remainingMt)&&(identical(other.farmerCount, _this.farmerCount) || other.farmerCount == _this.farmerCount)&&(identical(other.fairPrice, _this.fairPrice) || other.fairPrice == _this.fairPrice)&&(identical(other.wholesalePrice, _this.wholesalePrice) || other.wholesalePrice == _this.wholesalePrice)&&(identical(other.allowedExtentHa, _this.allowedExtentHa) || other.allowedExtentHa == _this.allowedExtentHa)&&(identical(other.harvestDate, _this.harvestDate) || other.harvestDate == _this.harvestDate)&&(identical(other.plantingDate, _this.plantingDate) || other.plantingDate == _this.plantingDate)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BucketStatus;
  return Object.hash(runtimeType,_this.cropName,_this.limitMt,_this.filledMt,_this.remainingMt,_this.farmerCount,_this.fairPrice,_this.wholesalePrice,_this.allowedExtentHa,_this.harvestDate,_this.plantingDate,_this.year,_this.month);
}

@override
String toString() {
  final _this = this as BucketStatus;
  return 'BucketStatus(cropName: ${_this.cropName}, limitMt: ${_this.limitMt}, filledMt: ${_this.filledMt}, remainingMt: ${_this.remainingMt}, farmerCount: ${_this.farmerCount}, fairPrice: ${_this.fairPrice}, wholesalePrice: ${_this.wholesalePrice}, allowedExtentHa: ${_this.allowedExtentHa}, harvestDate: ${_this.harvestDate}, plantingDate: ${_this.plantingDate}, year: ${_this.year}, month: ${_this.month})';
}


}

/// @nodoc
abstract mixin class $BucketStatusCopyWith<$Res>  {
  factory $BucketStatusCopyWith(BucketStatus value, $Res Function(BucketStatus) _then) = _$BucketStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'target_limit_mt', fromJson: asDouble) double limitMt,@JsonKey(name: 'filled_mt', fromJson: asDouble) double filledMt,@JsonKey(name: 'remaining_mt', fromJson: asDouble) double remainingMt,@JsonKey(name: 'farmer_count', fromJson: asInt) int farmerCount,@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,@JsonKey(name: 'target_harvest_date') String? harvestDate,@JsonKey(name: 'planting_date') String? plantingDate,@JsonKey(fromJson: asIntOrNull) int? year,@JsonKey(fromJson: asIntOrNull) int? month
});




}
/// @nodoc
class _$BucketStatusCopyWithImpl<$Res>
    implements $BucketStatusCopyWith<$Res> {
  _$BucketStatusCopyWithImpl(this._self, this._then);

  final BucketStatus _self;
  final $Res Function(BucketStatus) _then;

/// Create a copy of BucketStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cropName = null,Object? limitMt = null,Object? filledMt = null,Object? remainingMt = null,Object? farmerCount = null,Object? fairPrice = freezed,Object? wholesalePrice = freezed,Object? allowedExtentHa = freezed,Object? harvestDate = freezed,Object? plantingDate = freezed,Object? year = freezed,Object? month = freezed,}) {
  return _then(BucketStatus(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,limitMt: null == limitMt ? _self.limitMt : limitMt // ignore: cast_nullable_to_non_nullable
as double,filledMt: null == filledMt ? _self.filledMt : filledMt // ignore: cast_nullable_to_non_nullable
as double,remainingMt: null == remainingMt ? _self.remainingMt : remainingMt // ignore: cast_nullable_to_non_nullable
as double,farmerCount: null == farmerCount ? _self.farmerCount : farmerCount // ignore: cast_nullable_to_non_nullable
as int,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,wholesalePrice: freezed == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double?,allowedExtentHa: freezed == allowedExtentHa ? _self.allowedExtentHa : allowedExtentHa // ignore: cast_nullable_to_non_nullable
as double?,harvestDate: freezed == harvestDate ? _self.harvestDate : harvestDate // ignore: cast_nullable_to_non_nullable
as String?,plantingDate: freezed == plantingDate ? _self.plantingDate : plantingDate // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BucketStatus].
extension BucketStatusPatterns on BucketStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BucketStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BucketStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BucketStatus value)  $default,){
final _that = this;
switch (_that) {
case _BucketStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BucketStatus value)?  $default,){
final _that = this;
switch (_that) {
case _BucketStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble)  double limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble)  double filledMt, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt, @JsonKey(name: 'farmer_count', fromJson: asInt)  int farmerCount, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa, @JsonKey(name: 'target_harvest_date')  String? harvestDate, @JsonKey(name: 'planting_date')  String? plantingDate, @JsonKey(fromJson: asIntOrNull)  int? year, @JsonKey(fromJson: asIntOrNull)  int? month)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BucketStatus() when $default != null:
return $default(_that.cropName,_that.limitMt,_that.filledMt,_that.remainingMt,_that.farmerCount,_that.fairPrice,_that.wholesalePrice,_that.allowedExtentHa,_that.harvestDate,_that.plantingDate,_that.year,_that.month);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble)  double limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble)  double filledMt, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt, @JsonKey(name: 'farmer_count', fromJson: asInt)  int farmerCount, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa, @JsonKey(name: 'target_harvest_date')  String? harvestDate, @JsonKey(name: 'planting_date')  String? plantingDate, @JsonKey(fromJson: asIntOrNull)  int? year, @JsonKey(fromJson: asIntOrNull)  int? month)  $default,) {final _that = this;
switch (_that) {
case _BucketStatus():
return $default(_that.cropName,_that.limitMt,_that.filledMt,_that.remainingMt,_that.farmerCount,_that.fairPrice,_that.wholesalePrice,_that.allowedExtentHa,_that.harvestDate,_that.plantingDate,_that.year,_that.month);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble)  double limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble)  double filledMt, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt, @JsonKey(name: 'farmer_count', fromJson: asInt)  int farmerCount, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa, @JsonKey(name: 'target_harvest_date')  String? harvestDate, @JsonKey(name: 'planting_date')  String? plantingDate, @JsonKey(fromJson: asIntOrNull)  int? year, @JsonKey(fromJson: asIntOrNull)  int? month)?  $default,) {final _that = this;
switch (_that) {
case _BucketStatus() when $default != null:
return $default(_that.cropName,_that.limitMt,_that.filledMt,_that.remainingMt,_that.farmerCount,_that.fairPrice,_that.wholesalePrice,_that.allowedExtentHa,_that.harvestDate,_that.plantingDate,_that.year,_that.month);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BucketStatus extends BucketStatus {
  const _BucketStatus({@JsonKey(name: 'crop_name') required this.cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble) required this.limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble) this.filledMt = 0, @JsonKey(name: 'remaining_mt', fromJson: asDouble) this.remainingMt = 0, @JsonKey(name: 'farmer_count', fromJson: asInt) this.farmerCount = 0, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) this.fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) this.wholesalePrice, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) this.allowedExtentHa, @JsonKey(name: 'target_harvest_date') this.harvestDate, @JsonKey(name: 'planting_date') this.plantingDate, @JsonKey(fromJson: asIntOrNull) this.year, @JsonKey(fromJson: asIntOrNull) this.month}): super._();
  factory _BucketStatus.fromJson(Map<String, dynamic> json) => _$BucketStatusFromJson(json);

@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(name: 'target_limit_mt', fromJson: asDouble) final  double limitMt;
@override@JsonKey(name: 'filled_mt', fromJson: asDouble) final  double filledMt;
@override@JsonKey(name: 'remaining_mt', fromJson: asDouble) final  double remainingMt;
@override@JsonKey(name: 'farmer_count', fromJson: asInt) final  int farmerCount;
@override@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) final  double? fairPrice;
@override@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) final  double? wholesalePrice;
@override@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) final  double? allowedExtentHa;
@override@JsonKey(name: 'target_harvest_date') final  String? harvestDate;
@override@JsonKey(name: 'planting_date') final  String? plantingDate;
@override@JsonKey(fromJson: asIntOrNull) final  int? year;
@override@JsonKey(fromJson: asIntOrNull) final  int? month;

/// Create a copy of BucketStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BucketStatusCopyWith<_BucketStatus> get copyWith => __$BucketStatusCopyWithImpl<_BucketStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BucketStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BucketStatus&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.limitMt, limitMt) || other.limitMt == limitMt)&&(identical(other.filledMt, filledMt) || other.filledMt == filledMt)&&(identical(other.remainingMt, remainingMt) || other.remainingMt == remainingMt)&&(identical(other.farmerCount, farmerCount) || other.farmerCount == farmerCount)&&(identical(other.fairPrice, fairPrice) || other.fairPrice == fairPrice)&&(identical(other.wholesalePrice, wholesalePrice) || other.wholesalePrice == wholesalePrice)&&(identical(other.allowedExtentHa, allowedExtentHa) || other.allowedExtentHa == allowedExtentHa)&&(identical(other.harvestDate, harvestDate) || other.harvestDate == harvestDate)&&(identical(other.plantingDate, plantingDate) || other.plantingDate == plantingDate)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cropName,limitMt,filledMt,remainingMt,farmerCount,fairPrice,wholesalePrice,allowedExtentHa,harvestDate,plantingDate,year,month);
}

@override
String toString() {
    return 'BucketStatus(cropName: $cropName, limitMt: $limitMt, filledMt: $filledMt, remainingMt: $remainingMt, farmerCount: $farmerCount, fairPrice: $fairPrice, wholesalePrice: $wholesalePrice, allowedExtentHa: $allowedExtentHa, harvestDate: $harvestDate, plantingDate: $plantingDate, year: $year, month: $month)';
}


}

/// @nodoc
abstract mixin class _$BucketStatusCopyWith<$Res> implements $BucketStatusCopyWith<$Res> {
  factory _$BucketStatusCopyWith(_BucketStatus value, $Res Function(_BucketStatus) _then) = __$BucketStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'target_limit_mt', fromJson: asDouble) double limitMt,@JsonKey(name: 'filled_mt', fromJson: asDouble) double filledMt,@JsonKey(name: 'remaining_mt', fromJson: asDouble) double remainingMt,@JsonKey(name: 'farmer_count', fromJson: asInt) int farmerCount,@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,@JsonKey(name: 'target_harvest_date') String? harvestDate,@JsonKey(name: 'planting_date') String? plantingDate,@JsonKey(fromJson: asIntOrNull) int? year,@JsonKey(fromJson: asIntOrNull) int? month
});




}
/// @nodoc
class __$BucketStatusCopyWithImpl<$Res>
    implements _$BucketStatusCopyWith<$Res> {
  __$BucketStatusCopyWithImpl(this._self, this._then);

  final _BucketStatus _self;
  final $Res Function(_BucketStatus) _then;

/// Create a copy of BucketStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cropName = null,Object? limitMt = null,Object? filledMt = null,Object? remainingMt = null,Object? farmerCount = null,Object? fairPrice = freezed,Object? wholesalePrice = freezed,Object? allowedExtentHa = freezed,Object? harvestDate = freezed,Object? plantingDate = freezed,Object? year = freezed,Object? month = freezed,}) {
  return _then(_BucketStatus(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,limitMt: null == limitMt ? _self.limitMt : limitMt // ignore: cast_nullable_to_non_nullable
as double,filledMt: null == filledMt ? _self.filledMt : filledMt // ignore: cast_nullable_to_non_nullable
as double,remainingMt: null == remainingMt ? _self.remainingMt : remainingMt // ignore: cast_nullable_to_non_nullable
as double,farmerCount: null == farmerCount ? _self.farmerCount : farmerCount // ignore: cast_nullable_to_non_nullable
as int,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,wholesalePrice: freezed == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double?,allowedExtentHa: freezed == allowedExtentHa ? _self.allowedExtentHa : allowedExtentHa // ignore: cast_nullable_to_non_nullable
as double?,harvestDate: freezed == harvestDate ? _self.harvestDate : harvestDate // ignore: cast_nullable_to_non_nullable
as String?,plantingDate: freezed == plantingDate ? _self.plantingDate : plantingDate // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
