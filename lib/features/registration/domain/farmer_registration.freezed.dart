// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farmer_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmerRegistration {

 int get id;@JsonKey(name: 'farmer_id') String? get farmerId;@JsonKey(name: 'crop_name') String get cropName;@JsonKey(name: 'amount_mt', fromJson: asDouble) double get amountMt;@JsonKey(name: 'registered_at') DateTime? get registeredAt;
/// Create a copy of FarmerRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmerRegistrationCopyWith<FarmerRegistration> get copyWith => _$FarmerRegistrationCopyWithImpl<FarmerRegistration>(this as FarmerRegistration, _$identity);

  /// Serializes this FarmerRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmerRegistration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmerRegistration&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.farmerId, _this.farmerId) || other.farmerId == _this.farmerId)&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.amountMt, _this.amountMt) || other.amountMt == _this.amountMt)&&(identical(other.registeredAt, _this.registeredAt) || other.registeredAt == _this.registeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmerRegistration;
  return Object.hash(runtimeType,_this.id,_this.farmerId,_this.cropName,_this.amountMt,_this.registeredAt);
}

@override
String toString() {
  final _this = this as FarmerRegistration;
  return 'FarmerRegistration(id: ${_this.id}, farmerId: ${_this.farmerId}, cropName: ${_this.cropName}, amountMt: ${_this.amountMt}, registeredAt: ${_this.registeredAt})';
}


}

/// @nodoc
abstract mixin class $FarmerRegistrationCopyWith<$Res>  {
  factory $FarmerRegistrationCopyWith(FarmerRegistration value, $Res Function(FarmerRegistration) _then) = _$FarmerRegistrationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'farmer_id') String? farmerId,@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'amount_mt', fromJson: asDouble) double amountMt,@JsonKey(name: 'registered_at') DateTime? registeredAt
});




}
/// @nodoc
class _$FarmerRegistrationCopyWithImpl<$Res>
    implements $FarmerRegistrationCopyWith<$Res> {
  _$FarmerRegistrationCopyWithImpl(this._self, this._then);

  final FarmerRegistration _self;
  final $Res Function(FarmerRegistration) _then;

/// Create a copy of FarmerRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmerId = freezed,Object? cropName = null,Object? amountMt = null,Object? registeredAt = freezed,}) {
  return _then(FarmerRegistration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,farmerId: freezed == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String?,cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,amountMt: null == amountMt ? _self.amountMt : amountMt // ignore: cast_nullable_to_non_nullable
as double,registeredAt: freezed == registeredAt ? _self.registeredAt : registeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmerRegistration].
extension FarmerRegistrationPatterns on FarmerRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmerRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmerRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmerRegistration value)  $default,){
final _that = this;
switch (_that) {
case _FarmerRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmerRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _FarmerRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'farmer_id')  String? farmerId, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'amount_mt', fromJson: asDouble)  double amountMt, @JsonKey(name: 'registered_at')  DateTime? registeredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmerRegistration() when $default != null:
return $default(_that.id,_that.farmerId,_that.cropName,_that.amountMt,_that.registeredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'farmer_id')  String? farmerId, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'amount_mt', fromJson: asDouble)  double amountMt, @JsonKey(name: 'registered_at')  DateTime? registeredAt)  $default,) {final _that = this;
switch (_that) {
case _FarmerRegistration():
return $default(_that.id,_that.farmerId,_that.cropName,_that.amountMt,_that.registeredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'farmer_id')  String? farmerId, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'amount_mt', fromJson: asDouble)  double amountMt, @JsonKey(name: 'registered_at')  DateTime? registeredAt)?  $default,) {final _that = this;
switch (_that) {
case _FarmerRegistration() when $default != null:
return $default(_that.id,_that.farmerId,_that.cropName,_that.amountMt,_that.registeredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmerRegistration implements FarmerRegistration {
  const _FarmerRegistration({required this.id, @JsonKey(name: 'farmer_id') this.farmerId, @JsonKey(name: 'crop_name') required this.cropName, @JsonKey(name: 'amount_mt', fromJson: asDouble) this.amountMt = 0, @JsonKey(name: 'registered_at') this.registeredAt});
  factory _FarmerRegistration.fromJson(Map<String, dynamic> json) => _$FarmerRegistrationFromJson(json);

@override final  int id;
@override@JsonKey(name: 'farmer_id') final  String? farmerId;
@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(name: 'amount_mt', fromJson: asDouble) final  double amountMt;
@override@JsonKey(name: 'registered_at') final  DateTime? registeredAt;

/// Create a copy of FarmerRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmerRegistrationCopyWith<_FarmerRegistration> get copyWith => __$FarmerRegistrationCopyWithImpl<_FarmerRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmerRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmerRegistration&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.amountMt, amountMt) || other.amountMt == amountMt)&&(identical(other.registeredAt, registeredAt) || other.registeredAt == registeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,farmerId,cropName,amountMt,registeredAt);
}

@override
String toString() {
    return 'FarmerRegistration(id: $id, farmerId: $farmerId, cropName: $cropName, amountMt: $amountMt, registeredAt: $registeredAt)';
}


}

/// @nodoc
abstract mixin class _$FarmerRegistrationCopyWith<$Res> implements $FarmerRegistrationCopyWith<$Res> {
  factory _$FarmerRegistrationCopyWith(_FarmerRegistration value, $Res Function(_FarmerRegistration) _then) = __$FarmerRegistrationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'farmer_id') String? farmerId,@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'amount_mt', fromJson: asDouble) double amountMt,@JsonKey(name: 'registered_at') DateTime? registeredAt
});




}
/// @nodoc
class __$FarmerRegistrationCopyWithImpl<$Res>
    implements _$FarmerRegistrationCopyWith<$Res> {
  __$FarmerRegistrationCopyWithImpl(this._self, this._then);

  final _FarmerRegistration _self;
  final $Res Function(_FarmerRegistration) _then;

/// Create a copy of FarmerRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmerId = freezed,Object? cropName = null,Object? amountMt = null,Object? registeredAt = freezed,}) {
  return _then(_FarmerRegistration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,farmerId: freezed == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String?,cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,amountMt: null == amountMt ? _self.amountMt : amountMt // ignore: cast_nullable_to_non_nullable
as double,registeredAt: freezed == registeredAt ? _self.registeredAt : registeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CropRegistration {

 int get id;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'crop_name') String get cropName;@JsonKey(name: 'planting_date') DateTime? get plantingDate;@JsonKey(name: 'harvest_date') DateTime? get harvestDate;@JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull) double? get landSizeAcres; String? get status;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of CropRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CropRegistrationCopyWith<CropRegistration> get copyWith => _$CropRegistrationCopyWithImpl<CropRegistration>(this as CropRegistration, _$identity);

  /// Serializes this CropRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CropRegistration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CropRegistration&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.plantingDate, _this.plantingDate) || other.plantingDate == _this.plantingDate)&&(identical(other.harvestDate, _this.harvestDate) || other.harvestDate == _this.harvestDate)&&(identical(other.landSizeAcres, _this.landSizeAcres) || other.landSizeAcres == _this.landSizeAcres)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CropRegistration;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.cropName,_this.plantingDate,_this.harvestDate,_this.landSizeAcres,_this.status,_this.createdAt);
}

@override
String toString() {
  final _this = this as CropRegistration;
  return 'CropRegistration(id: ${_this.id}, userId: ${_this.userId}, cropName: ${_this.cropName}, plantingDate: ${_this.plantingDate}, harvestDate: ${_this.harvestDate}, landSizeAcres: ${_this.landSizeAcres}, status: ${_this.status}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CropRegistrationCopyWith<$Res>  {
  factory $CropRegistrationCopyWith(CropRegistration value, $Res Function(CropRegistration) _then) = _$CropRegistrationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'planting_date') DateTime? plantingDate,@JsonKey(name: 'harvest_date') DateTime? harvestDate,@JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull) double? landSizeAcres, String? status,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$CropRegistrationCopyWithImpl<$Res>
    implements $CropRegistrationCopyWith<$Res> {
  _$CropRegistrationCopyWithImpl(this._self, this._then);

  final CropRegistration _self;
  final $Res Function(CropRegistration) _then;

/// Create a copy of CropRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? cropName = null,Object? plantingDate = freezed,Object? harvestDate = freezed,Object? landSizeAcres = freezed,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(CropRegistration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,plantingDate: freezed == plantingDate ? _self.plantingDate : plantingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,harvestDate: freezed == harvestDate ? _self.harvestDate : harvestDate // ignore: cast_nullable_to_non_nullable
as DateTime?,landSizeAcres: freezed == landSizeAcres ? _self.landSizeAcres : landSizeAcres // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CropRegistration].
extension CropRegistrationPatterns on CropRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CropRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CropRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CropRegistration value)  $default,){
final _that = this;
switch (_that) {
case _CropRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CropRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _CropRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'planting_date')  DateTime? plantingDate, @JsonKey(name: 'harvest_date')  DateTime? harvestDate, @JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull)  double? landSizeAcres,  String? status, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CropRegistration() when $default != null:
return $default(_that.id,_that.userId,_that.cropName,_that.plantingDate,_that.harvestDate,_that.landSizeAcres,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'planting_date')  DateTime? plantingDate, @JsonKey(name: 'harvest_date')  DateTime? harvestDate, @JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull)  double? landSizeAcres,  String? status, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CropRegistration():
return $default(_that.id,_that.userId,_that.cropName,_that.plantingDate,_that.harvestDate,_that.landSizeAcres,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'planting_date')  DateTime? plantingDate, @JsonKey(name: 'harvest_date')  DateTime? harvestDate, @JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull)  double? landSizeAcres,  String? status, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CropRegistration() when $default != null:
return $default(_that.id,_that.userId,_that.cropName,_that.plantingDate,_that.harvestDate,_that.landSizeAcres,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CropRegistration implements CropRegistration {
  const _CropRegistration({required this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'crop_name') required this.cropName, @JsonKey(name: 'planting_date') this.plantingDate, @JsonKey(name: 'harvest_date') this.harvestDate, @JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull) this.landSizeAcres, this.status, @JsonKey(name: 'created_at') this.createdAt});
  factory _CropRegistration.fromJson(Map<String, dynamic> json) => _$CropRegistrationFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(name: 'planting_date') final  DateTime? plantingDate;
@override@JsonKey(name: 'harvest_date') final  DateTime? harvestDate;
@override@JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull) final  double? landSizeAcres;
@override final  String? status;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of CropRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CropRegistrationCopyWith<_CropRegistration> get copyWith => __$CropRegistrationCopyWithImpl<_CropRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CropRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CropRegistration&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.plantingDate, plantingDate) || other.plantingDate == plantingDate)&&(identical(other.harvestDate, harvestDate) || other.harvestDate == harvestDate)&&(identical(other.landSizeAcres, landSizeAcres) || other.landSizeAcres == landSizeAcres)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,cropName,plantingDate,harvestDate,landSizeAcres,status,createdAt);
}

@override
String toString() {
    return 'CropRegistration(id: $id, userId: $userId, cropName: $cropName, plantingDate: $plantingDate, harvestDate: $harvestDate, landSizeAcres: $landSizeAcres, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CropRegistrationCopyWith<$Res> implements $CropRegistrationCopyWith<$Res> {
  factory _$CropRegistrationCopyWith(_CropRegistration value, $Res Function(_CropRegistration) _then) = __$CropRegistrationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'planting_date') DateTime? plantingDate,@JsonKey(name: 'harvest_date') DateTime? harvestDate,@JsonKey(name: 'land_size_acres', fromJson: asDoubleOrNull) double? landSizeAcres, String? status,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$CropRegistrationCopyWithImpl<$Res>
    implements _$CropRegistrationCopyWith<$Res> {
  __$CropRegistrationCopyWithImpl(this._self, this._then);

  final _CropRegistration _self;
  final $Res Function(_CropRegistration) _then;

/// Create a copy of CropRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? cropName = null,Object? plantingDate = freezed,Object? harvestDate = freezed,Object? landSizeAcres = freezed,Object? status = freezed,Object? createdAt = freezed,}) {
  return _then(_CropRegistration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,plantingDate: freezed == plantingDate ? _self.plantingDate : plantingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,harvestDate: freezed == harvestDate ? _self.harvestDate : harvestDate // ignore: cast_nullable_to_non_nullable
as DateTime?,landSizeAcres: freezed == landSizeAcres ? _self.landSizeAcres : landSizeAcres // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
