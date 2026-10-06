// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

 int get id;@JsonKey(name: 'user_id') String? get userId; String get content; String? get image;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'author_name') String? get authorName;@JsonKey(name: 'author_avatar') String? get authorAvatar;@JsonKey(name: 'like_count', fromJson: asInt) int get likeCount;@JsonKey(name: 'comment_count', fromJson: asInt) int get commentCount;@JsonKey(name: 'liked_by_me', fromJson: asBool) bool get likedByMe;@JsonKey(name: 'saved_by_me', fromJson: asBool) bool get savedByMe;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Post;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.authorAvatar, _this.authorAvatar) || other.authorAvatar == _this.authorAvatar)&&(identical(other.likeCount, _this.likeCount) || other.likeCount == _this.likeCount)&&(identical(other.commentCount, _this.commentCount) || other.commentCount == _this.commentCount)&&(identical(other.likedByMe, _this.likedByMe) || other.likedByMe == _this.likedByMe)&&(identical(other.savedByMe, _this.savedByMe) || other.savedByMe == _this.savedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Post;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.content,_this.image,_this.createdAt,_this.authorName,_this.authorAvatar,_this.likeCount,_this.commentCount,_this.likedByMe,_this.savedByMe);
}

@override
String toString() {
  final _this = this as Post;
  return 'Post(id: ${_this.id}, userId: ${_this.userId}, content: ${_this.content}, image: ${_this.image}, createdAt: ${_this.createdAt}, authorName: ${_this.authorName}, authorAvatar: ${_this.authorAvatar}, likeCount: ${_this.likeCount}, commentCount: ${_this.commentCount}, likedByMe: ${_this.likedByMe}, savedByMe: ${_this.savedByMe})';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId, String content, String? image,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'author_name') String? authorName,@JsonKey(name: 'author_avatar') String? authorAvatar,@JsonKey(name: 'like_count', fromJson: asInt) int likeCount,@JsonKey(name: 'comment_count', fromJson: asInt) int commentCount,@JsonKey(name: 'liked_by_me', fromJson: asBool) bool likedByMe,@JsonKey(name: 'saved_by_me', fromJson: asBool) bool savedByMe
});




}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? content = null,Object? image = freezed,Object? createdAt = freezed,Object? authorName = freezed,Object? authorAvatar = freezed,Object? likeCount = null,Object? commentCount = null,Object? likedByMe = null,Object? savedByMe = null,}) {
  return _then(Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,savedByMe: null == savedByMe ? _self.savedByMe : savedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId,  String content,  String? image, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'author_name')  String? authorName, @JsonKey(name: 'author_avatar')  String? authorAvatar, @JsonKey(name: 'like_count', fromJson: asInt)  int likeCount, @JsonKey(name: 'comment_count', fromJson: asInt)  int commentCount, @JsonKey(name: 'liked_by_me', fromJson: asBool)  bool likedByMe, @JsonKey(name: 'saved_by_me', fromJson: asBool)  bool savedByMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.userId,_that.content,_that.image,_that.createdAt,_that.authorName,_that.authorAvatar,_that.likeCount,_that.commentCount,_that.likedByMe,_that.savedByMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId,  String content,  String? image, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'author_name')  String? authorName, @JsonKey(name: 'author_avatar')  String? authorAvatar, @JsonKey(name: 'like_count', fromJson: asInt)  int likeCount, @JsonKey(name: 'comment_count', fromJson: asInt)  int commentCount, @JsonKey(name: 'liked_by_me', fromJson: asBool)  bool likedByMe, @JsonKey(name: 'saved_by_me', fromJson: asBool)  bool savedByMe)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.id,_that.userId,_that.content,_that.image,_that.createdAt,_that.authorName,_that.authorAvatar,_that.likeCount,_that.commentCount,_that.likedByMe,_that.savedByMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  String? userId,  String content,  String? image, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'author_name')  String? authorName, @JsonKey(name: 'author_avatar')  String? authorAvatar, @JsonKey(name: 'like_count', fromJson: asInt)  int likeCount, @JsonKey(name: 'comment_count', fromJson: asInt)  int commentCount, @JsonKey(name: 'liked_by_me', fromJson: asBool)  bool likedByMe, @JsonKey(name: 'saved_by_me', fromJson: asBool)  bool savedByMe)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.userId,_that.content,_that.image,_that.createdAt,_that.authorName,_that.authorAvatar,_that.likeCount,_that.commentCount,_that.likedByMe,_that.savedByMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post extends Post {
  const _Post({required this.id, @JsonKey(name: 'user_id') this.userId, this.content = '', this.image, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'author_name') this.authorName, @JsonKey(name: 'author_avatar') this.authorAvatar, @JsonKey(name: 'like_count', fromJson: asInt) this.likeCount = 0, @JsonKey(name: 'comment_count', fromJson: asInt) this.commentCount = 0, @JsonKey(name: 'liked_by_me', fromJson: asBool) this.likedByMe = false, @JsonKey(name: 'saved_by_me', fromJson: asBool) this.savedByMe = false}): super._();
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey() final  String content;
@override final  String? image;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'author_name') final  String? authorName;
@override@JsonKey(name: 'author_avatar') final  String? authorAvatar;
@override@JsonKey(name: 'like_count', fromJson: asInt) final  int likeCount;
@override@JsonKey(name: 'comment_count', fromJson: asInt) final  int commentCount;
@override@JsonKey(name: 'liked_by_me', fromJson: asBool) final  bool likedByMe;
@override@JsonKey(name: 'saved_by_me', fromJson: asBool) final  bool savedByMe;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatar, authorAvatar) || other.authorAvatar == authorAvatar)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.savedByMe, savedByMe) || other.savedByMe == savedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,content,image,createdAt,authorName,authorAvatar,likeCount,commentCount,likedByMe,savedByMe);
}

@override
String toString() {
    return 'Post(id: $id, userId: $userId, content: $content, image: $image, createdAt: $createdAt, authorName: $authorName, authorAvatar: $authorAvatar, likeCount: $likeCount, commentCount: $commentCount, likedByMe: $likedByMe, savedByMe: $savedByMe)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId, String content, String? image,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'author_name') String? authorName,@JsonKey(name: 'author_avatar') String? authorAvatar,@JsonKey(name: 'like_count', fromJson: asInt) int likeCount,@JsonKey(name: 'comment_count', fromJson: asInt) int commentCount,@JsonKey(name: 'liked_by_me', fromJson: asBool) bool likedByMe,@JsonKey(name: 'saved_by_me', fromJson: asBool) bool savedByMe
});




}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? content = null,Object? image = freezed,Object? createdAt = freezed,Object? authorName = freezed,Object? authorAvatar = freezed,Object? likeCount = null,Object? commentCount = null,Object? likedByMe = null,Object? savedByMe = null,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,savedByMe: null == savedByMe ? _self.savedByMe : savedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
