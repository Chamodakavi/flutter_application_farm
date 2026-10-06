// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$News {

@JsonKey(name: 'n_id') int get id;@JsonKey(name: 'n_img') String? get image;@JsonKey(name: 'n_title') String get title;@JsonKey(name: 'n_description') String get description;@JsonKey(name: 'n_type') String? get type;@JsonKey(name: 'n_author') String? get author;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of News
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsCopyWith<News> get copyWith => _$NewsCopyWithImpl<News>(this as News, _$identity);

  /// Serializes this News to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as News;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is News&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as News;
  return Object.hash(runtimeType,_this.id,_this.image,_this.title,_this.description,_this.type,_this.author,_this.createdAt);
}

@override
String toString() {
  final _this = this as News;
  return 'News(id: ${_this.id}, image: ${_this.image}, title: ${_this.title}, description: ${_this.description}, type: ${_this.type}, author: ${_this.author}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $NewsCopyWith<$Res>  {
  factory $NewsCopyWith(News value, $Res Function(News) _then) = _$NewsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'n_id') int id,@JsonKey(name: 'n_img') String? image,@JsonKey(name: 'n_title') String title,@JsonKey(name: 'n_description') String description,@JsonKey(name: 'n_type') String? type,@JsonKey(name: 'n_author') String? author,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$NewsCopyWithImpl<$Res>
    implements $NewsCopyWith<$Res> {
  _$NewsCopyWithImpl(this._self, this._then);

  final News _self;
  final $Res Function(News) _then;

/// Create a copy of News
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? image = freezed,Object? title = null,Object? description = null,Object? type = freezed,Object? author = freezed,Object? createdAt = freezed,}) {
  return _then(News(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [News].
extension NewsPatterns on News {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _News value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _News() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _News value)  $default,){
final _that = this;
switch (_that) {
case _News():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _News value)?  $default,){
final _that = this;
switch (_that) {
case _News() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'n_id')  int id, @JsonKey(name: 'n_img')  String? image, @JsonKey(name: 'n_title')  String title, @JsonKey(name: 'n_description')  String description, @JsonKey(name: 'n_type')  String? type, @JsonKey(name: 'n_author')  String? author, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _News() when $default != null:
return $default(_that.id,_that.image,_that.title,_that.description,_that.type,_that.author,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'n_id')  int id, @JsonKey(name: 'n_img')  String? image, @JsonKey(name: 'n_title')  String title, @JsonKey(name: 'n_description')  String description, @JsonKey(name: 'n_type')  String? type, @JsonKey(name: 'n_author')  String? author, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _News():
return $default(_that.id,_that.image,_that.title,_that.description,_that.type,_that.author,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'n_id')  int id, @JsonKey(name: 'n_img')  String? image, @JsonKey(name: 'n_title')  String title, @JsonKey(name: 'n_description')  String description, @JsonKey(name: 'n_type')  String? type, @JsonKey(name: 'n_author')  String? author, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _News() when $default != null:
return $default(_that.id,_that.image,_that.title,_that.description,_that.type,_that.author,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _News extends News {
  const _News({@JsonKey(name: 'n_id') required this.id, @JsonKey(name: 'n_img') this.image, @JsonKey(name: 'n_title') this.title = '', @JsonKey(name: 'n_description') this.description = '', @JsonKey(name: 'n_type') this.type, @JsonKey(name: 'n_author') this.author, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

@override@JsonKey(name: 'n_id') final  int id;
@override@JsonKey(name: 'n_img') final  String? image;
@override@JsonKey(name: 'n_title') final  String title;
@override@JsonKey(name: 'n_description') final  String description;
@override@JsonKey(name: 'n_type') final  String? type;
@override@JsonKey(name: 'n_author') final  String? author;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of News
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsCopyWith<_News> get copyWith => __$NewsCopyWithImpl<_News>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _News&&(identical(other.id, id) || other.id == id)&&(identical(other.image, image) || other.image == image)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,image,title,description,type,author,createdAt);
}

@override
String toString() {
    return 'News(id: $id, image: $image, title: $title, description: $description, type: $type, author: $author, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NewsCopyWith<$Res> implements $NewsCopyWith<$Res> {
  factory _$NewsCopyWith(_News value, $Res Function(_News) _then) = __$NewsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'n_id') int id,@JsonKey(name: 'n_img') String? image,@JsonKey(name: 'n_title') String title,@JsonKey(name: 'n_description') String description,@JsonKey(name: 'n_type') String? type,@JsonKey(name: 'n_author') String? author,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$NewsCopyWithImpl<$Res>
    implements _$NewsCopyWith<$Res> {
  __$NewsCopyWithImpl(this._self, this._then);

  final _News _self;
  final $Res Function(_News) _then;

/// Create a copy of News
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? image = freezed,Object? title = null,Object? description = null,Object? type = freezed,Object? author = freezed,Object? createdAt = freezed,}) {
  return _then(_News(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
