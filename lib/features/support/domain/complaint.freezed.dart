// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Complaint {

 int get id;@JsonKey(name: 'created_at') DateTime? get createdAt; String get subject; String get body;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'user_name') String? get userName;@JsonKey(name: 'user_email') String? get userEmail; String? get status;@JsonKey(name: 'admin_reply') String? get adminReply;@JsonKey(name: 'replied_at') DateTime? get repliedAt;@JsonKey(name: 'read_at') DateTime? get readAt;
/// Create a copy of Complaint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComplaintCopyWith<Complaint> get copyWith => _$ComplaintCopyWithImpl<Complaint>(this as Complaint, _$identity);

  /// Serializes this Complaint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Complaint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Complaint&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.userEmail, _this.userEmail) || other.userEmail == _this.userEmail)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.adminReply, _this.adminReply) || other.adminReply == _this.adminReply)&&(identical(other.repliedAt, _this.repliedAt) || other.repliedAt == _this.repliedAt)&&(identical(other.readAt, _this.readAt) || other.readAt == _this.readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Complaint;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.subject,_this.body,_this.userId,_this.userName,_this.userEmail,_this.status,_this.adminReply,_this.repliedAt,_this.readAt);
}

@override
String toString() {
  final _this = this as Complaint;
  return 'Complaint(id: ${_this.id}, createdAt: ${_this.createdAt}, subject: ${_this.subject}, body: ${_this.body}, userId: ${_this.userId}, userName: ${_this.userName}, userEmail: ${_this.userEmail}, status: ${_this.status}, adminReply: ${_this.adminReply}, repliedAt: ${_this.repliedAt}, readAt: ${_this.readAt})';
}


}

/// @nodoc
abstract mixin class $ComplaintCopyWith<$Res>  {
  factory $ComplaintCopyWith(Complaint value, $Res Function(Complaint) _then) = _$ComplaintCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'created_at') DateTime? createdAt, String subject, String body,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_email') String? userEmail, String? status,@JsonKey(name: 'admin_reply') String? adminReply,@JsonKey(name: 'replied_at') DateTime? repliedAt,@JsonKey(name: 'read_at') DateTime? readAt
});




}
/// @nodoc
class _$ComplaintCopyWithImpl<$Res>
    implements $ComplaintCopyWith<$Res> {
  _$ComplaintCopyWithImpl(this._self, this._then);

  final Complaint _self;
  final $Res Function(Complaint) _then;

/// Create a copy of Complaint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? subject = null,Object? body = null,Object? userId = freezed,Object? userName = freezed,Object? userEmail = freezed,Object? status = freezed,Object? adminReply = freezed,Object? repliedAt = freezed,Object? readAt = freezed,}) {
  return _then(Complaint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,adminReply: freezed == adminReply ? _self.adminReply : adminReply // ignore: cast_nullable_to_non_nullable
as String?,repliedAt: freezed == repliedAt ? _self.repliedAt : repliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Complaint].
extension ComplaintPatterns on Complaint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Complaint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Complaint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Complaint value)  $default,){
final _that = this;
switch (_that) {
case _Complaint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Complaint value)?  $default,){
final _that = this;
switch (_that) {
case _Complaint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')  DateTime? createdAt,  String subject,  String body, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail,  String? status, @JsonKey(name: 'admin_reply')  String? adminReply, @JsonKey(name: 'replied_at')  DateTime? repliedAt, @JsonKey(name: 'read_at')  DateTime? readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Complaint() when $default != null:
return $default(_that.id,_that.createdAt,_that.subject,_that.body,_that.userId,_that.userName,_that.userEmail,_that.status,_that.adminReply,_that.repliedAt,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'created_at')  DateTime? createdAt,  String subject,  String body, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail,  String? status, @JsonKey(name: 'admin_reply')  String? adminReply, @JsonKey(name: 'replied_at')  DateTime? repliedAt, @JsonKey(name: 'read_at')  DateTime? readAt)  $default,) {final _that = this;
switch (_that) {
case _Complaint():
return $default(_that.id,_that.createdAt,_that.subject,_that.body,_that.userId,_that.userName,_that.userEmail,_that.status,_that.adminReply,_that.repliedAt,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'created_at')  DateTime? createdAt,  String subject,  String body, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail,  String? status, @JsonKey(name: 'admin_reply')  String? adminReply, @JsonKey(name: 'replied_at')  DateTime? repliedAt, @JsonKey(name: 'read_at')  DateTime? readAt)?  $default,) {final _that = this;
switch (_that) {
case _Complaint() when $default != null:
return $default(_that.id,_that.createdAt,_that.subject,_that.body,_that.userId,_that.userName,_that.userEmail,_that.status,_that.adminReply,_that.repliedAt,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Complaint extends Complaint {
  const _Complaint({required this.id, @JsonKey(name: 'created_at') this.createdAt, this.subject = '', this.body = '', @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'user_name') this.userName, @JsonKey(name: 'user_email') this.userEmail, this.status, @JsonKey(name: 'admin_reply') this.adminReply, @JsonKey(name: 'replied_at') this.repliedAt, @JsonKey(name: 'read_at') this.readAt}): super._();
  factory _Complaint.fromJson(Map<String, dynamic> json) => _$ComplaintFromJson(json);

@override final  int id;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey() final  String subject;
@override@JsonKey() final  String body;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'user_name') final  String? userName;
@override@JsonKey(name: 'user_email') final  String? userEmail;
@override final  String? status;
@override@JsonKey(name: 'admin_reply') final  String? adminReply;
@override@JsonKey(name: 'replied_at') final  DateTime? repliedAt;
@override@JsonKey(name: 'read_at') final  DateTime? readAt;

/// Create a copy of Complaint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComplaintCopyWith<_Complaint> get copyWith => __$ComplaintCopyWithImpl<_Complaint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ComplaintToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Complaint&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminReply, adminReply) || other.adminReply == adminReply)&&(identical(other.repliedAt, repliedAt) || other.repliedAt == repliedAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,subject,body,userId,userName,userEmail,status,adminReply,repliedAt,readAt);
}

@override
String toString() {
    return 'Complaint(id: $id, createdAt: $createdAt, subject: $subject, body: $body, userId: $userId, userName: $userName, userEmail: $userEmail, status: $status, adminReply: $adminReply, repliedAt: $repliedAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$ComplaintCopyWith<$Res> implements $ComplaintCopyWith<$Res> {
  factory _$ComplaintCopyWith(_Complaint value, $Res Function(_Complaint) _then) = __$ComplaintCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'created_at') DateTime? createdAt, String subject, String body,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_email') String? userEmail, String? status,@JsonKey(name: 'admin_reply') String? adminReply,@JsonKey(name: 'replied_at') DateTime? repliedAt,@JsonKey(name: 'read_at') DateTime? readAt
});




}
/// @nodoc
class __$ComplaintCopyWithImpl<$Res>
    implements _$ComplaintCopyWith<$Res> {
  __$ComplaintCopyWithImpl(this._self, this._then);

  final _Complaint _self;
  final $Res Function(_Complaint) _then;

/// Create a copy of Complaint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = freezed,Object? subject = null,Object? body = null,Object? userId = freezed,Object? userName = freezed,Object? userEmail = freezed,Object? status = freezed,Object? adminReply = freezed,Object? repliedAt = freezed,Object? readAt = freezed,}) {
  return _then(_Complaint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,adminReply: freezed == adminReply ? _self.adminReply : adminReply // ignore: cast_nullable_to_non_nullable
as String?,repliedAt: freezed == repliedAt ? _self.repliedAt : repliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
