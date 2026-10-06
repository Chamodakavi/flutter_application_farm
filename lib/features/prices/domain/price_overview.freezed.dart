// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceOverview {

@JsonKey(name: 'crop_name') String get cropName;@JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull) double? get wholesalePrice;@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? get retailPrice;@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? get fairPrice;@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? get costPerKg;@JsonKey(name: 'prev_price', fromJson: asDoubleOrNull) double? get prevPrice;@JsonKey(name: 'change_pct', fromJson: asDoubleOrNull) double? get changePct;@JsonKey(name: 'model_version') String? get modelVersion;@JsonKey(name: 'generated_at') DateTime? get generatedAt;
/// Create a copy of PriceOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceOverviewCopyWith<PriceOverview> get copyWith => _$PriceOverviewCopyWithImpl<PriceOverview>(this as PriceOverview, _$identity);

  /// Serializes this PriceOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceOverview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceOverview&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.wholesalePrice, _this.wholesalePrice) || other.wholesalePrice == _this.wholesalePrice)&&(identical(other.retailPrice, _this.retailPrice) || other.retailPrice == _this.retailPrice)&&(identical(other.fairPrice, _this.fairPrice) || other.fairPrice == _this.fairPrice)&&(identical(other.costPerKg, _this.costPerKg) || other.costPerKg == _this.costPerKg)&&(identical(other.prevPrice, _this.prevPrice) || other.prevPrice == _this.prevPrice)&&(identical(other.changePct, _this.changePct) || other.changePct == _this.changePct)&&(identical(other.modelVersion, _this.modelVersion) || other.modelVersion == _this.modelVersion)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceOverview;
  return Object.hash(runtimeType,_this.cropName,_this.wholesalePrice,_this.retailPrice,_this.fairPrice,_this.costPerKg,_this.prevPrice,_this.changePct,_this.modelVersion,_this.generatedAt);
}

@override
String toString() {
  final _this = this as PriceOverview;
  return 'PriceOverview(cropName: ${_this.cropName}, wholesalePrice: ${_this.wholesalePrice}, retailPrice: ${_this.retailPrice}, fairPrice: ${_this.fairPrice}, costPerKg: ${_this.costPerKg}, prevPrice: ${_this.prevPrice}, changePct: ${_this.changePct}, modelVersion: ${_this.modelVersion}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $PriceOverviewCopyWith<$Res>  {
  factory $PriceOverviewCopyWith(PriceOverview value, $Res Function(PriceOverview) _then) = _$PriceOverviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? retailPrice,@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? costPerKg,@JsonKey(name: 'prev_price', fromJson: asDoubleOrNull) double? prevPrice,@JsonKey(name: 'change_pct', fromJson: asDoubleOrNull) double? changePct,@JsonKey(name: 'model_version') String? modelVersion,@JsonKey(name: 'generated_at') DateTime? generatedAt
});




}
/// @nodoc
class _$PriceOverviewCopyWithImpl<$Res>
    implements $PriceOverviewCopyWith<$Res> {
  _$PriceOverviewCopyWithImpl(this._self, this._then);

  final PriceOverview _self;
  final $Res Function(PriceOverview) _then;

/// Create a copy of PriceOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cropName = null,Object? wholesalePrice = freezed,Object? retailPrice = freezed,Object? fairPrice = freezed,Object? costPerKg = freezed,Object? prevPrice = freezed,Object? changePct = freezed,Object? modelVersion = freezed,Object? generatedAt = freezed,}) {
  return _then(PriceOverview(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,wholesalePrice: freezed == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double?,retailPrice: freezed == retailPrice ? _self.retailPrice : retailPrice // ignore: cast_nullable_to_non_nullable
as double?,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,costPerKg: freezed == costPerKg ? _self.costPerKg : costPerKg // ignore: cast_nullable_to_non_nullable
as double?,prevPrice: freezed == prevPrice ? _self.prevPrice : prevPrice // ignore: cast_nullable_to_non_nullable
as double?,changePct: freezed == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double?,modelVersion: freezed == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceOverview].
extension PriceOverviewPatterns on PriceOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceOverview value)  $default,){
final _that = this;
switch (_that) {
case _PriceOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceOverview value)?  $default,){
final _that = this;
switch (_that) {
case _PriceOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull)  double? retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull)  double? costPerKg, @JsonKey(name: 'prev_price', fromJson: asDoubleOrNull)  double? prevPrice, @JsonKey(name: 'change_pct', fromJson: asDoubleOrNull)  double? changePct, @JsonKey(name: 'model_version')  String? modelVersion, @JsonKey(name: 'generated_at')  DateTime? generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceOverview() when $default != null:
return $default(_that.cropName,_that.wholesalePrice,_that.retailPrice,_that.fairPrice,_that.costPerKg,_that.prevPrice,_that.changePct,_that.modelVersion,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull)  double? retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull)  double? costPerKg, @JsonKey(name: 'prev_price', fromJson: asDoubleOrNull)  double? prevPrice, @JsonKey(name: 'change_pct', fromJson: asDoubleOrNull)  double? changePct, @JsonKey(name: 'model_version')  String? modelVersion, @JsonKey(name: 'generated_at')  DateTime? generatedAt)  $default,) {final _that = this;
switch (_that) {
case _PriceOverview():
return $default(_that.cropName,_that.wholesalePrice,_that.retailPrice,_that.fairPrice,_that.costPerKg,_that.prevPrice,_that.changePct,_that.modelVersion,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull)  double? wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull)  double? retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull)  double? costPerKg, @JsonKey(name: 'prev_price', fromJson: asDoubleOrNull)  double? prevPrice, @JsonKey(name: 'change_pct', fromJson: asDoubleOrNull)  double? changePct, @JsonKey(name: 'model_version')  String? modelVersion, @JsonKey(name: 'generated_at')  DateTime? generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PriceOverview() when $default != null:
return $default(_that.cropName,_that.wholesalePrice,_that.retailPrice,_that.fairPrice,_that.costPerKg,_that.prevPrice,_that.changePct,_that.modelVersion,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceOverview extends PriceOverview {
  const _PriceOverview({@JsonKey(name: 'crop_name') required this.cropName, @JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull) this.wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) this.retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) this.fairPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) this.costPerKg, @JsonKey(name: 'prev_price', fromJson: asDoubleOrNull) this.prevPrice, @JsonKey(name: 'change_pct', fromJson: asDoubleOrNull) this.changePct, @JsonKey(name: 'model_version') this.modelVersion, @JsonKey(name: 'generated_at') this.generatedAt}): super._();
  factory _PriceOverview.fromJson(Map<String, dynamic> json) => _$PriceOverviewFromJson(json);

@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull) final  double? wholesalePrice;
@override@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) final  double? retailPrice;
@override@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) final  double? fairPrice;
@override@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) final  double? costPerKg;
@override@JsonKey(name: 'prev_price', fromJson: asDoubleOrNull) final  double? prevPrice;
@override@JsonKey(name: 'change_pct', fromJson: asDoubleOrNull) final  double? changePct;
@override@JsonKey(name: 'model_version') final  String? modelVersion;
@override@JsonKey(name: 'generated_at') final  DateTime? generatedAt;

/// Create a copy of PriceOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceOverviewCopyWith<_PriceOverview> get copyWith => __$PriceOverviewCopyWithImpl<_PriceOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceOverview&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.wholesalePrice, wholesalePrice) || other.wholesalePrice == wholesalePrice)&&(identical(other.retailPrice, retailPrice) || other.retailPrice == retailPrice)&&(identical(other.fairPrice, fairPrice) || other.fairPrice == fairPrice)&&(identical(other.costPerKg, costPerKg) || other.costPerKg == costPerKg)&&(identical(other.prevPrice, prevPrice) || other.prevPrice == prevPrice)&&(identical(other.changePct, changePct) || other.changePct == changePct)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cropName,wholesalePrice,retailPrice,fairPrice,costPerKg,prevPrice,changePct,modelVersion,generatedAt);
}

@override
String toString() {
    return 'PriceOverview(cropName: $cropName, wholesalePrice: $wholesalePrice, retailPrice: $retailPrice, fairPrice: $fairPrice, costPerKg: $costPerKg, prevPrice: $prevPrice, changePct: $changePct, modelVersion: $modelVersion, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$PriceOverviewCopyWith<$Res> implements $PriceOverviewCopyWith<$Res> {
  factory _$PriceOverviewCopyWith(_PriceOverview value, $Res Function(_PriceOverview) _then) = __$PriceOverviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'wholesale_price', fromJson: asDoubleOrNull) double? wholesalePrice,@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? retailPrice,@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? costPerKg,@JsonKey(name: 'prev_price', fromJson: asDoubleOrNull) double? prevPrice,@JsonKey(name: 'change_pct', fromJson: asDoubleOrNull) double? changePct,@JsonKey(name: 'model_version') String? modelVersion,@JsonKey(name: 'generated_at') DateTime? generatedAt
});




}
/// @nodoc
class __$PriceOverviewCopyWithImpl<$Res>
    implements _$PriceOverviewCopyWith<$Res> {
  __$PriceOverviewCopyWithImpl(this._self, this._then);

  final _PriceOverview _self;
  final $Res Function(_PriceOverview) _then;

/// Create a copy of PriceOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cropName = null,Object? wholesalePrice = freezed,Object? retailPrice = freezed,Object? fairPrice = freezed,Object? costPerKg = freezed,Object? prevPrice = freezed,Object? changePct = freezed,Object? modelVersion = freezed,Object? generatedAt = freezed,}) {
  return _then(_PriceOverview(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,wholesalePrice: freezed == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double?,retailPrice: freezed == retailPrice ? _self.retailPrice : retailPrice // ignore: cast_nullable_to_non_nullable
as double?,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,costPerKg: freezed == costPerKg ? _self.costPerKg : costPerKg // ignore: cast_nullable_to_non_nullable
as double?,prevPrice: freezed == prevPrice ? _self.prevPrice : prevPrice // ignore: cast_nullable_to_non_nullable
as double?,changePct: freezed == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double?,modelVersion: freezed == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
