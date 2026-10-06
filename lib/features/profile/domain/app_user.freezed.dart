// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id;@JsonKey(name: 'u_name') String? get name;@JsonKey(name: 'u_surname') String? get surname;@JsonKey(name: 'u_email') String? get email;@JsonKey(name: 'u_tel') String? get phone;@JsonKey(name: 'u_district') String? get district;@JsonKey(name: 'u_type') String? get userType;@JsonKey(name: 'u_notify') bool get notify;@JsonKey(name: 'u_avatar') String? get avatarUrl;@JsonKey(name: 'u_role') String get role;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.surname, _this.surname) || other.surname == _this.surname)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.district, _this.district) || other.district == _this.district)&&(identical(other.userType, _this.userType) || other.userType == _this.userType)&&(identical(other.notify, _this.notify) || other.notify == _this.notify)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.surname,_this.email,_this.phone,_this.district,_this.userType,_this.notify,_this.avatarUrl,_this.role,_this.createdAt);
}

@override
String toString() {
  final _this = this as AppUser;
  return 'AppUser(id: ${_this.id}, name: ${_this.name}, surname: ${_this.surname}, email: ${_this.email}, phone: ${_this.phone}, district: ${_this.district}, userType: ${_this.userType}, notify: ${_this.notify}, avatarUrl: ${_this.avatarUrl}, role: ${_this.role}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'u_name') String? name,@JsonKey(name: 'u_surname') String? surname,@JsonKey(name: 'u_email') String? email,@JsonKey(name: 'u_tel') String? phone,@JsonKey(name: 'u_district') String? district,@JsonKey(name: 'u_type') String? userType,@JsonKey(name: 'u_notify') bool notify,@JsonKey(name: 'u_avatar') String? avatarUrl,@JsonKey(name: 'u_role') String role,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? surname = freezed,Object? email = freezed,Object? phone = freezed,Object? district = freezed,Object? userType = freezed,Object? notify = null,Object? avatarUrl = freezed,Object? role = null,Object? createdAt = freezed,}) {
  return _then(AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,surname: freezed == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'u_name')  String? name, @JsonKey(name: 'u_surname')  String? surname, @JsonKey(name: 'u_email')  String? email, @JsonKey(name: 'u_tel')  String? phone, @JsonKey(name: 'u_district')  String? district, @JsonKey(name: 'u_type')  String? userType, @JsonKey(name: 'u_notify')  bool notify, @JsonKey(name: 'u_avatar')  String? avatarUrl, @JsonKey(name: 'u_role')  String role, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.name,_that.surname,_that.email,_that.phone,_that.district,_that.userType,_that.notify,_that.avatarUrl,_that.role,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'u_name')  String? name, @JsonKey(name: 'u_surname')  String? surname, @JsonKey(name: 'u_email')  String? email, @JsonKey(name: 'u_tel')  String? phone, @JsonKey(name: 'u_district')  String? district, @JsonKey(name: 'u_type')  String? userType, @JsonKey(name: 'u_notify')  bool notify, @JsonKey(name: 'u_avatar')  String? avatarUrl, @JsonKey(name: 'u_role')  String role, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.name,_that.surname,_that.email,_that.phone,_that.district,_that.userType,_that.notify,_that.avatarUrl,_that.role,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'u_name')  String? name, @JsonKey(name: 'u_surname')  String? surname, @JsonKey(name: 'u_email')  String? email, @JsonKey(name: 'u_tel')  String? phone, @JsonKey(name: 'u_district')  String? district, @JsonKey(name: 'u_type')  String? userType, @JsonKey(name: 'u_notify')  bool notify, @JsonKey(name: 'u_avatar')  String? avatarUrl, @JsonKey(name: 'u_role')  String role, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.name,_that.surname,_that.email,_that.phone,_that.district,_that.userType,_that.notify,_that.avatarUrl,_that.role,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({required this.id, @JsonKey(name: 'u_name') this.name, @JsonKey(name: 'u_surname') this.surname, @JsonKey(name: 'u_email') this.email, @JsonKey(name: 'u_tel') this.phone, @JsonKey(name: 'u_district') this.district, @JsonKey(name: 'u_type') this.userType, @JsonKey(name: 'u_notify') this.notify = true, @JsonKey(name: 'u_avatar') this.avatarUrl, @JsonKey(name: 'u_role') this.role = 'farmer', @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override@JsonKey(name: 'u_name') final  String? name;
@override@JsonKey(name: 'u_surname') final  String? surname;
@override@JsonKey(name: 'u_email') final  String? email;
@override@JsonKey(name: 'u_tel') final  String? phone;
@override@JsonKey(name: 'u_district') final  String? district;
@override@JsonKey(name: 'u_type') final  String? userType;
@override@JsonKey(name: 'u_notify') final  bool notify;
@override@JsonKey(name: 'u_avatar') final  String? avatarUrl;
@override@JsonKey(name: 'u_role') final  String role;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.surname, surname) || other.surname == surname)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.district, district) || other.district == district)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.notify, notify) || other.notify == notify)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,surname,email,phone,district,userType,notify,avatarUrl,role,createdAt);
}

@override
String toString() {
    return 'AppUser(id: $id, name: $name, surname: $surname, email: $email, phone: $phone, district: $district, userType: $userType, notify: $notify, avatarUrl: $avatarUrl, role: $role, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'u_name') String? name,@JsonKey(name: 'u_surname') String? surname,@JsonKey(name: 'u_email') String? email,@JsonKey(name: 'u_tel') String? phone,@JsonKey(name: 'u_district') String? district,@JsonKey(name: 'u_type') String? userType,@JsonKey(name: 'u_notify') bool notify,@JsonKey(name: 'u_avatar') String? avatarUrl,@JsonKey(name: 'u_role') String role,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? surname = freezed,Object? email = freezed,Object? phone = freezed,Object? district = freezed,Object? userType = freezed,Object? notify = null,Object? avatarUrl = freezed,Object? role = null,Object? createdAt = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,surname: freezed == surname ? _self.surname : surname // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,notify: null == notify ? _self.notify : notify // ignore: cast_nullable_to_non_nullable
as bool,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
