// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'national_target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NationalTarget {

 int get id;@JsonKey(name: 'crop_name') String get cropName;@JsonKey(name: 'target_limit_mt', fromJson: asDouble) double get targetLimitMt;@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? get allowedExtentHa; int? get year; int? get month;@JsonKey(name: 'target_harvest_date') String? get targetHarvestDate;@JsonKey(name: 'planting_date') String? get plantingDate;@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? get fairPrice;@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? get wholesalePrice;@JsonKey(name: 'expires_at') DateTime? get expiresAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of NationalTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NationalTargetCopyWith<NationalTarget> get copyWith => _$NationalTargetCopyWithImpl<NationalTarget>(this as NationalTarget, _$identity);

  /// Serializes this NationalTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NationalTarget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NationalTarget&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.targetLimitMt, _this.targetLimitMt) || other.targetLimitMt == _this.targetLimitMt)&&(identical(other.allowedExtentHa, _this.allowedExtentHa) || other.allowedExtentHa == _this.allowedExtentHa)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.targetHarvestDate, _this.targetHarvestDate) || other.targetHarvestDate == _this.targetHarvestDate)&&(identical(other.plantingDate, _this.plantingDate) || other.plantingDate == _this.plantingDate)&&(identical(other.fairPrice, _this.fairPrice) || other.fairPrice == _this.fairPrice)&&(identical(other.wholesalePrice, _this.wholesalePrice) || other.wholesalePrice == _this.wholesalePrice)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NationalTarget;
  return Object.hash(runtimeType,_this.id,_this.cropName,_this.targetLimitMt,_this.allowedExtentHa,_this.year,_this.month,_this.targetHarvestDate,_this.plantingDate,_this.fairPrice,_this.wholesalePrice,_this.expiresAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as NationalTarget;
  return 'NationalTarget(id: ${_this.id}, cropName: ${_this.cropName}, targetLimitMt: ${_this.targetLimitMt}, allowedExtentHa: ${_this.allowedExtentHa}, year: ${_this.year}, month: ${_this.month}, targetHarvestDate: ${_this.targetHarvestDate}, plantingDate: ${_this.plantingDate}, fairPrice: ${_this.fairPrice}, wholesalePrice: ${_this.wholesalePrice}, expiresAt: ${_this.expiresAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $NationalTargetCopyWith<$Res>  {
  factory $NationalTargetCopyWith(NationalTarget value, $Res Function(NationalTarget) _then) = _$NationalTargetCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'target_limit_mt', fromJson: asDouble) double targetLimitMt,@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa, int? year, int? month,@JsonKey(name: 'target_harvest_date') String? targetHarvestDate,@JsonKey(name: 'planting_date') String? plantingDate,@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$NationalTargetCopyWithImpl<$Res>
    implements $NationalTargetCopyWith<$Res> {
  _$NationalTargetCopyWithImpl(this._self, this._then);

  final NationalTarget _self;
  final $Res Function(NationalTarget) _then;

/// Create a copy of NationalTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cropName = null,Object? targetLimitMt = null,Object? allowedExtentHa = freezed,Object? year = freezed,Object? month = freezed,Object? targetHarvestDate = freezed,Object? plantingDate = freezed,Object? fairPrice = freezed,Object? wholesalePrice = freezed,Object? expiresAt = freezed,Object? updatedAt = freezed,}) {
  return _then(NationalTarget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,targetLimitMt: null == targetLimitMt ? _self.targetLimitMt : targetLimitMt // ignore: cast_nullable_to_non_nullable
as double,allowedExtentHa: freezed == allowedExtentHa ? _self.allowedExtentHa : allowedExtentHa // ignore: cast_nullable_to_non_nullable
as double?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,targetHarvestDate: freezed == targetHarvestDate ? _self.targetHarvestDate : targetHarvestDate // ignore: cast_nullable_to_non_nullable
as String?,plantingDate: freezed == plantingDate ? _self.plantingDate : plantingDate // ignore: cast_nullable_to_non_nullable
as String?,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,wholesalePrice: freezed == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NationalTarget].
extension NationalTargetPatterns on NationalTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NationalTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NationalTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NationalTarget value)  $default,){
final _that = this;
switch (_that) {
case _NationalTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NationalTarget value)?  $default,){
final _that = this;
switch (_that) {
case _NationalTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble)  double targetLimitMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa,  int? year,  int? month, @JsonKey(name: 'target_harvest_date')  String? targetHarvestDate, @JsonKey(name: 'planting_date')  String? plantingDate, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NationalTarget() when $default != null:
return $default(_that.id,_that.cropName,_that.targetLimitMt,_that.allowedExtentHa,_that.year,_that.month,_that.targetHarvestDate,_that.plantingDate,_that.fairPrice,_that.wholesalePrice,_that.expiresAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble)  double targetLimitMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa,  int? year,  int? month, @JsonKey(name: 'target_harvest_date')  String? targetHarvestDate, @JsonKey(name: 'planting_date')  String? plantingDate, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NationalTarget():
return $default(_that.id,_that.cropName,_that.targetLimitMt,_that.allowedExtentHa,_that.year,_that.month,_that.targetHarvestDate,_that.plantingDate,_that.fairPrice,_that.wholesalePrice,_that.expiresAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble)  double targetLimitMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa,  int? year,  int? month, @JsonKey(name: 'target_harvest_date')  String? targetHarvestDate, @JsonKey(name: 'planting_date')  String? plantingDate, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'expires_at')  DateTime? expiresAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NationalTarget() when $default != null:
return $default(_that.id,_that.cropName,_that.targetLimitMt,_that.allowedExtentHa,_that.year,_that.month,_that.targetHarvestDate,_that.plantingDate,_that.fairPrice,_that.wholesalePrice,_that.expiresAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NationalTarget implements NationalTarget {
  const _NationalTarget({required this.id, @JsonKey(name: 'crop_name') required this.cropName, @JsonKey(name: 'target_limit_mt', fromJson: asDouble) required this.targetLimitMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) this.allowedExtentHa, this.year, this.month, @JsonKey(name: 'target_harvest_date') this.targetHarvestDate, @JsonKey(name: 'planting_date') this.plantingDate, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) this.fairPrice, @JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) this.wholesalePrice, @JsonKey(name: 'expires_at') this.expiresAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _NationalTarget.fromJson(Map<String, dynamic> json) => _$NationalTargetFromJson(json);

@override final  int id;
@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(name: 'target_limit_mt', fromJson: asDouble) final  double targetLimitMt;
@override@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) final  double? allowedExtentHa;
@override final  int? year;
@override final  int? month;
@override@JsonKey(name: 'target_harvest_date') final  String? targetHarvestDate;
@override@JsonKey(name: 'planting_date') final  String? plantingDate;
@override@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) final  double? fairPrice;
@override@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) final  double? wholesalePrice;
@override@JsonKey(name: 'expires_at') final  DateTime? expiresAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of NationalTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NationalTargetCopyWith<_NationalTarget> get copyWith => __$NationalTargetCopyWithImpl<_NationalTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NationalTargetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NationalTarget&&(identical(other.id, id) || other.id == id)&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.targetLimitMt, targetLimitMt) || other.targetLimitMt == targetLimitMt)&&(identical(other.allowedExtentHa, allowedExtentHa) || other.allowedExtentHa == allowedExtentHa)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.targetHarvestDate, targetHarvestDate) || other.targetHarvestDate == targetHarvestDate)&&(identical(other.plantingDate, plantingDate) || other.plantingDate == plantingDate)&&(identical(other.fairPrice, fairPrice) || other.fairPrice == fairPrice)&&(identical(other.wholesalePrice, wholesalePrice) || other.wholesalePrice == wholesalePrice)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,cropName,targetLimitMt,allowedExtentHa,year,month,targetHarvestDate,plantingDate,fairPrice,wholesalePrice,expiresAt,updatedAt);
}

@override
String toString() {
    return 'NationalTarget(id: $id, cropName: $cropName, targetLimitMt: $targetLimitMt, allowedExtentHa: $allowedExtentHa, year: $year, month: $month, targetHarvestDate: $targetHarvestDate, plantingDate: $plantingDate, fairPrice: $fairPrice, wholesalePrice: $wholesalePrice, expiresAt: $expiresAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NationalTargetCopyWith<$Res> implements $NationalTargetCopyWith<$Res> {
  factory _$NationalTargetCopyWith(_NationalTarget value, $Res Function(_NationalTarget) _then) = __$NationalTargetCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'target_limit_mt', fromJson: asDouble) double targetLimitMt,@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa, int? year, int? month,@JsonKey(name: 'target_harvest_date') String? targetHarvestDate,@JsonKey(name: 'planting_date') String? plantingDate,@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'estimated_wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,@JsonKey(name: 'expires_at') DateTime? expiresAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$NationalTargetCopyWithImpl<$Res>
    implements _$NationalTargetCopyWith<$Res> {
  __$NationalTargetCopyWithImpl(this._self, this._then);

  final _NationalTarget _self;
  final $Res Function(_NationalTarget) _then;

/// Create a copy of NationalTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cropName = null,Object? targetLimitMt = null,Object? allowedExtentHa = freezed,Object? year = freezed,Object? month = freezed,Object? targetHarvestDate = freezed,Object? plantingDate = freezed,Object? fairPrice = freezed,Object? wholesalePrice = freezed,Object? expiresAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_NationalTarget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,targetLimitMt: null == targetLimitMt ? _self.targetLimitMt : targetLimitMt // ignore: cast_nullable_to_non_nullable
as double,allowedExtentHa: freezed == allowedExtentHa ? _self.allowedExtentHa : allowedExtentHa // ignore: cast_nullable_to_non_nullable
as double?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,targetHarvestDate: freezed == targetHarvestDate ? _self.targetHarvestDate : targetHarvestDate // ignore: cast_nullable_to_non_nullable
as String?,plantingDate: freezed == plantingDate ? _self.plantingDate : plantingDate // ignore: cast_nullable_to_non_nullable
as String?,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,wholesalePrice: freezed == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
