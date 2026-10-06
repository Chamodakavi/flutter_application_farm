// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlternativeCrop {

@JsonKey(name: 'crop_name') String get cropName;@JsonKey(name: 'remaining_mt', fromJson: asDouble) double get remainingMt;@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? get fairPrice;
/// Create a copy of AlternativeCrop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlternativeCropCopyWith<AlternativeCrop> get copyWith => _$AlternativeCropCopyWithImpl<AlternativeCrop>(this as AlternativeCrop, _$identity);

  /// Serializes this AlternativeCrop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlternativeCrop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlternativeCrop&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.remainingMt, _this.remainingMt) || other.remainingMt == _this.remainingMt)&&(identical(other.fairPrice, _this.fairPrice) || other.fairPrice == _this.fairPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlternativeCrop;
  return Object.hash(runtimeType,_this.cropName,_this.remainingMt,_this.fairPrice);
}

@override
String toString() {
  final _this = this as AlternativeCrop;
  return 'AlternativeCrop(cropName: ${_this.cropName}, remainingMt: ${_this.remainingMt}, fairPrice: ${_this.fairPrice})';
}


}

/// @nodoc
abstract mixin class $AlternativeCropCopyWith<$Res>  {
  factory $AlternativeCropCopyWith(AlternativeCrop value, $Res Function(AlternativeCrop) _then) = _$AlternativeCropCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'remaining_mt', fromJson: asDouble) double remainingMt,@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice
});




}
/// @nodoc
class _$AlternativeCropCopyWithImpl<$Res>
    implements $AlternativeCropCopyWith<$Res> {
  _$AlternativeCropCopyWithImpl(this._self, this._then);

  final AlternativeCrop _self;
  final $Res Function(AlternativeCrop) _then;

/// Create a copy of AlternativeCrop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cropName = null,Object? remainingMt = null,Object? fairPrice = freezed,}) {
  return _then(AlternativeCrop(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,remainingMt: null == remainingMt ? _self.remainingMt : remainingMt // ignore: cast_nullable_to_non_nullable
as double,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlternativeCrop].
extension AlternativeCropPatterns on AlternativeCrop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlternativeCrop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlternativeCrop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlternativeCrop value)  $default,){
final _that = this;
switch (_that) {
case _AlternativeCrop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlternativeCrop value)?  $default,){
final _that = this;
switch (_that) {
case _AlternativeCrop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlternativeCrop() when $default != null:
return $default(_that.cropName,_that.remainingMt,_that.fairPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice)  $default,) {final _that = this;
switch (_that) {
case _AlternativeCrop():
return $default(_that.cropName,_that.remainingMt,_that.fairPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull)  double? fairPrice)?  $default,) {final _that = this;
switch (_that) {
case _AlternativeCrop() when $default != null:
return $default(_that.cropName,_that.remainingMt,_that.fairPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlternativeCrop implements AlternativeCrop {
  const _AlternativeCrop({@JsonKey(name: 'crop_name') required this.cropName, @JsonKey(name: 'remaining_mt', fromJson: asDouble) this.remainingMt = 0, @JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) this.fairPrice});
  factory _AlternativeCrop.fromJson(Map<String, dynamic> json) => _$AlternativeCropFromJson(json);

@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(name: 'remaining_mt', fromJson: asDouble) final  double remainingMt;
@override@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) final  double? fairPrice;

/// Create a copy of AlternativeCrop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlternativeCropCopyWith<_AlternativeCrop> get copyWith => __$AlternativeCropCopyWithImpl<_AlternativeCrop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlternativeCropToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlternativeCrop&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.remainingMt, remainingMt) || other.remainingMt == remainingMt)&&(identical(other.fairPrice, fairPrice) || other.fairPrice == fairPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cropName,remainingMt,fairPrice);
}

@override
String toString() {
    return 'AlternativeCrop(cropName: $cropName, remainingMt: $remainingMt, fairPrice: $fairPrice)';
}


}

/// @nodoc
abstract mixin class _$AlternativeCropCopyWith<$Res> implements $AlternativeCropCopyWith<$Res> {
  factory _$AlternativeCropCopyWith(_AlternativeCrop value, $Res Function(_AlternativeCrop) _then) = __$AlternativeCropCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(name: 'remaining_mt', fromJson: asDouble) double remainingMt,@JsonKey(name: 'target_fair_price', fromJson: asDoubleOrNull) double? fairPrice
});




}
/// @nodoc
class __$AlternativeCropCopyWithImpl<$Res>
    implements _$AlternativeCropCopyWith<$Res> {
  __$AlternativeCropCopyWithImpl(this._self, this._then);

  final _AlternativeCrop _self;
  final $Res Function(_AlternativeCrop) _then;

/// Create a copy of AlternativeCrop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cropName = null,Object? remainingMt = null,Object? fairPrice = freezed,}) {
  return _then(_AlternativeCrop(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,remainingMt: null == remainingMt ? _self.remainingMt : remainingMt // ignore: cast_nullable_to_non_nullable
as double,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

RegisterResult _$RegisterResultFromJson(
  Map<String, dynamic> json
) {
        switch (json['status']) {
                  case 'success':
          return RegisterSuccess.fromJson(
            json
          );
                case 'surplus_warning':
          return RegisterSurplus.fromJson(
            json
          );
                case 'no_target':
          return RegisterNoTarget.fromJson(
            json
          );
                case 'invalid_amount':
          return RegisterInvalid.fromJson(
            json
          );
        
          default:
            return RegisterUnknown.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$RegisterResult {



  /// Serializes this RegisterResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterResult);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterResult()';
}


}

/// @nodoc
class $RegisterResultCopyWith<$Res>  {
$RegisterResultCopyWith(RegisterResult _, $Res Function(RegisterResult) __);
}


/// Adds pattern-matching-related methods to [RegisterResult].
extension RegisterResultPatterns on RegisterResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RegisterSuccess value)?  success,TResult Function( RegisterSurplus value)?  surplus,TResult Function( RegisterNoTarget value)?  noTarget,TResult Function( RegisterInvalid value)?  invalid,TResult Function( RegisterUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RegisterSuccess() when success != null:
return success(_that);case RegisterSurplus() when surplus != null:
return surplus(_that);case RegisterNoTarget() when noTarget != null:
return noTarget(_that);case RegisterInvalid() when invalid != null:
return invalid(_that);case RegisterUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RegisterSuccess value)  success,required TResult Function( RegisterSurplus value)  surplus,required TResult Function( RegisterNoTarget value)  noTarget,required TResult Function( RegisterInvalid value)  invalid,required TResult Function( RegisterUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case RegisterSuccess():
return success(_that);case RegisterSurplus():
return surplus(_that);case RegisterNoTarget():
return noTarget(_that);case RegisterInvalid():
return invalid(_that);case RegisterUnknown():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RegisterSuccess value)?  success,TResult? Function( RegisterSurplus value)?  surplus,TResult? Function( RegisterNoTarget value)?  noTarget,TResult? Function( RegisterInvalid value)?  invalid,TResult? Function( RegisterUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case RegisterSuccess() when success != null:
return success(_that);case RegisterSurplus() when surplus != null:
return surplus(_that);case RegisterNoTarget() when noTarget != null:
return noTarget(_that);case RegisterInvalid() when invalid != null:
return invalid(_that);case RegisterUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@JsonKey(name: 'registration_id', fromJson: asIntOrNull)  int? registrationId, @JsonKey(name: 'crop_name')  String? cropName, @JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull)  double? remainingMt)?  success,TResult Function(@JsonKey(name: 'crop_name')  String? cropName, @JsonKey(name: 'limit_mt', fromJson: asDouble)  double limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble)  double filledMt, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt,  List<AlternativeCrop> alternatives)?  surplus,TResult Function()?  noTarget,TResult Function()?  invalid,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RegisterSuccess() when success != null:
return success(_that.registrationId,_that.cropName,_that.remainingMt);case RegisterSurplus() when surplus != null:
return surplus(_that.cropName,_that.limitMt,_that.filledMt,_that.remainingMt,_that.alternatives);case RegisterNoTarget() when noTarget != null:
return noTarget();case RegisterInvalid() when invalid != null:
return invalid();case RegisterUnknown() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@JsonKey(name: 'registration_id', fromJson: asIntOrNull)  int? registrationId, @JsonKey(name: 'crop_name')  String? cropName, @JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull)  double? remainingMt)  success,required TResult Function(@JsonKey(name: 'crop_name')  String? cropName, @JsonKey(name: 'limit_mt', fromJson: asDouble)  double limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble)  double filledMt, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt,  List<AlternativeCrop> alternatives)  surplus,required TResult Function()  noTarget,required TResult Function()  invalid,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case RegisterSuccess():
return success(_that.registrationId,_that.cropName,_that.remainingMt);case RegisterSurplus():
return surplus(_that.cropName,_that.limitMt,_that.filledMt,_that.remainingMt,_that.alternatives);case RegisterNoTarget():
return noTarget();case RegisterInvalid():
return invalid();case RegisterUnknown():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@JsonKey(name: 'registration_id', fromJson: asIntOrNull)  int? registrationId, @JsonKey(name: 'crop_name')  String? cropName, @JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull)  double? remainingMt)?  success,TResult? Function(@JsonKey(name: 'crop_name')  String? cropName, @JsonKey(name: 'limit_mt', fromJson: asDouble)  double limitMt, @JsonKey(name: 'filled_mt', fromJson: asDouble)  double filledMt, @JsonKey(name: 'remaining_mt', fromJson: asDouble)  double remainingMt,  List<AlternativeCrop> alternatives)?  surplus,TResult? Function()?  noTarget,TResult? Function()?  invalid,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case RegisterSuccess() when success != null:
return success(_that.registrationId,_that.cropName,_that.remainingMt);case RegisterSurplus() when surplus != null:
return surplus(_that.cropName,_that.limitMt,_that.filledMt,_that.remainingMt,_that.alternatives);case RegisterNoTarget() when noTarget != null:
return noTarget();case RegisterInvalid() when invalid != null:
return invalid();case RegisterUnknown() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class RegisterSuccess implements RegisterResult {
  const RegisterSuccess({@JsonKey(name: 'registration_id', fromJson: asIntOrNull) this.registrationId, @JsonKey(name: 'crop_name') this.cropName, @JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull) this.remainingMt,  String? $type}): $type = $type ?? 'success';
  factory RegisterSuccess.fromJson(Map<String, dynamic> json) => _$RegisterSuccessFromJson(json);

@JsonKey(name: 'registration_id', fromJson: asIntOrNull) final  int? registrationId;
@JsonKey(name: 'crop_name') final  String? cropName;
@JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull) final  double? remainingMt;

@JsonKey(name: 'status')
final String $type;


/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterSuccessCopyWith<RegisterSuccess> get copyWith => _$RegisterSuccessCopyWithImpl<RegisterSuccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterSuccessToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterSuccess&&(identical(other.registrationId, registrationId) || other.registrationId == registrationId)&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.remainingMt, remainingMt) || other.remainingMt == remainingMt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,registrationId,cropName,remainingMt);
}

@override
String toString() {
    return 'RegisterResult.success(registrationId: $registrationId, cropName: $cropName, remainingMt: $remainingMt)';
}


}

/// @nodoc
abstract mixin class $RegisterSuccessCopyWith<$Res> implements $RegisterResultCopyWith<$Res> {
  factory $RegisterSuccessCopyWith(RegisterSuccess value, $Res Function(RegisterSuccess) _then) = _$RegisterSuccessCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'registration_id', fromJson: asIntOrNull) int? registrationId,@JsonKey(name: 'crop_name') String? cropName,@JsonKey(name: 'remaining_mt', fromJson: asDoubleOrNull) double? remainingMt
});




}
/// @nodoc
class _$RegisterSuccessCopyWithImpl<$Res>
    implements $RegisterSuccessCopyWith<$Res> {
  _$RegisterSuccessCopyWithImpl(this._self, this._then);

  final RegisterSuccess _self;
  final $Res Function(RegisterSuccess) _then;

/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? registrationId = freezed,Object? cropName = freezed,Object? remainingMt = freezed,}) {
  return _then(RegisterSuccess(
registrationId: freezed == registrationId ? _self.registrationId : registrationId // ignore: cast_nullable_to_non_nullable
as int?,cropName: freezed == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String?,remainingMt: freezed == remainingMt ? _self.remainingMt : remainingMt // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RegisterSurplus implements RegisterResult {
  const RegisterSurplus({@JsonKey(name: 'crop_name') this.cropName, @JsonKey(name: 'limit_mt', fromJson: asDouble) this.limitMt = 0, @JsonKey(name: 'filled_mt', fromJson: asDouble) this.filledMt = 0, @JsonKey(name: 'remaining_mt', fromJson: asDouble) this.remainingMt = 0,  List<AlternativeCrop> alternatives = const <AlternativeCrop>[],  String? $type}): _alternatives = alternatives,$type = $type ?? 'surplus_warning';
  factory RegisterSurplus.fromJson(Map<String, dynamic> json) => _$RegisterSurplusFromJson(json);

@JsonKey(name: 'crop_name') final  String? cropName;
@JsonKey(name: 'limit_mt', fromJson: asDouble) final  double limitMt;
@JsonKey(name: 'filled_mt', fromJson: asDouble) final  double filledMt;
@JsonKey(name: 'remaining_mt', fromJson: asDouble) final  double remainingMt;
 final  List<AlternativeCrop> _alternatives;
@JsonKey() List<AlternativeCrop> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}


@JsonKey(name: 'status')
final String $type;


/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterSurplusCopyWith<RegisterSurplus> get copyWith => _$RegisterSurplusCopyWithImpl<RegisterSurplus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterSurplusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterSurplus&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.limitMt, limitMt) || other.limitMt == limitMt)&&(identical(other.filledMt, filledMt) || other.filledMt == filledMt)&&(identical(other.remainingMt, remainingMt) || other.remainingMt == remainingMt)&&const DeepCollectionEquality().equals(other.alternatives, _alternatives));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,cropName,limitMt,filledMt,remainingMt,const DeepCollectionEquality().hash(_alternatives));
}

@override
String toString() {
    return 'RegisterResult.surplus(cropName: $cropName, limitMt: $limitMt, filledMt: $filledMt, remainingMt: $remainingMt, alternatives: $alternatives)';
}


}

/// @nodoc
abstract mixin class $RegisterSurplusCopyWith<$Res> implements $RegisterResultCopyWith<$Res> {
  factory $RegisterSurplusCopyWith(RegisterSurplus value, $Res Function(RegisterSurplus) _then) = _$RegisterSurplusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'crop_name') String? cropName,@JsonKey(name: 'limit_mt', fromJson: asDouble) double limitMt,@JsonKey(name: 'filled_mt', fromJson: asDouble) double filledMt,@JsonKey(name: 'remaining_mt', fromJson: asDouble) double remainingMt, List<AlternativeCrop> alternatives
});




}
/// @nodoc
class _$RegisterSurplusCopyWithImpl<$Res>
    implements $RegisterSurplusCopyWith<$Res> {
  _$RegisterSurplusCopyWithImpl(this._self, this._then);

  final RegisterSurplus _self;
  final $Res Function(RegisterSurplus) _then;

/// Create a copy of RegisterResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cropName = freezed,Object? limitMt = null,Object? filledMt = null,Object? remainingMt = null,Object? alternatives = null,}) {
  return _then(RegisterSurplus(
cropName: freezed == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String?,limitMt: null == limitMt ? _self.limitMt : limitMt // ignore: cast_nullable_to_non_nullable
as double,filledMt: null == filledMt ? _self.filledMt : filledMt // ignore: cast_nullable_to_non_nullable
as double,remainingMt: null == remainingMt ? _self.remainingMt : remainingMt // ignore: cast_nullable_to_non_nullable
as double,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<AlternativeCrop>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RegisterNoTarget implements RegisterResult {
  const RegisterNoTarget({ String? $type}): $type = $type ?? 'no_target';
  factory RegisterNoTarget.fromJson(Map<String, dynamic> json) => _$RegisterNoTargetFromJson(json);



@JsonKey(name: 'status')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$RegisterNoTargetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterNoTarget);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterResult.noTarget()';
}


}




/// @nodoc
@JsonSerializable()

class RegisterInvalid implements RegisterResult {
  const RegisterInvalid({ String? $type}): $type = $type ?? 'invalid_amount';
  factory RegisterInvalid.fromJson(Map<String, dynamic> json) => _$RegisterInvalidFromJson(json);



@JsonKey(name: 'status')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$RegisterInvalidToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterInvalid);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterResult.invalid()';
}


}




/// @nodoc
@JsonSerializable()

class RegisterUnknown implements RegisterResult {
  const RegisterUnknown({ String? $type}): $type = $type ?? 'unknown';
  factory RegisterUnknown.fromJson(Map<String, dynamic> json) => _$RegisterUnknownFromJson(json);



@JsonKey(name: 'status')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$RegisterUnknownToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterUnknown);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RegisterResult.unknown()';
}


}




// dart format on
