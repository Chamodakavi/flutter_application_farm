// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 int get id;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'user_name') String? get userName;@JsonKey(name: 'user_email') String? get userEmail;@JsonKey(name: 'user_phone') String? get userPhone;@JsonKey(name: 'total_amount', fromJson: asDouble) double get totalAmount;@JsonKey(name: 'shipping_amount', fromJson: asDouble) double get shippingAmount; String? get status;@JsonKey(name: 'admin_note') String? get adminNote;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'order_items') List<OrderItem> get items;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Order;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.userEmail, _this.userEmail) || other.userEmail == _this.userEmail)&&(identical(other.userPhone, _this.userPhone) || other.userPhone == _this.userPhone)&&(identical(other.totalAmount, _this.totalAmount) || other.totalAmount == _this.totalAmount)&&(identical(other.shippingAmount, _this.shippingAmount) || other.shippingAmount == _this.shippingAmount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.adminNote, _this.adminNote) || other.adminNote == _this.adminNote)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Order;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.userName,_this.userEmail,_this.userPhone,_this.totalAmount,_this.shippingAmount,_this.status,_this.adminNote,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as Order;
  return 'Order(id: ${_this.id}, userId: ${_this.userId}, userName: ${_this.userName}, userEmail: ${_this.userEmail}, userPhone: ${_this.userPhone}, totalAmount: ${_this.totalAmount}, shippingAmount: ${_this.shippingAmount}, status: ${_this.status}, adminNote: ${_this.adminNote}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_email') String? userEmail,@JsonKey(name: 'user_phone') String? userPhone,@JsonKey(name: 'total_amount', fromJson: asDouble) double totalAmount,@JsonKey(name: 'shipping_amount', fromJson: asDouble) double shippingAmount, String? status,@JsonKey(name: 'admin_note') String? adminNote,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'order_items') List<OrderItem> items
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? userName = freezed,Object? userEmail = freezed,Object? userPhone = freezed,Object? totalAmount = null,Object? shippingAmount = null,Object? status = freezed,Object? adminNote = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userPhone: freezed == userPhone ? _self.userPhone : userPhone // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,shippingAmount: null == shippingAmount ? _self.shippingAmount : shippingAmount // ignore: cast_nullable_to_non_nullable
as double,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,adminNote: freezed == adminNote ? _self.adminNote : adminNote // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_phone')  String? userPhone, @JsonKey(name: 'total_amount', fromJson: asDouble)  double totalAmount, @JsonKey(name: 'shipping_amount', fromJson: asDouble)  double shippingAmount,  String? status, @JsonKey(name: 'admin_note')  String? adminNote, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'order_items')  List<OrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userEmail,_that.userPhone,_that.totalAmount,_that.shippingAmount,_that.status,_that.adminNote,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_phone')  String? userPhone, @JsonKey(name: 'total_amount', fromJson: asDouble)  double totalAmount, @JsonKey(name: 'shipping_amount', fromJson: asDouble)  double shippingAmount,  String? status, @JsonKey(name: 'admin_note')  String? adminNote, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'order_items')  List<OrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.userId,_that.userName,_that.userEmail,_that.userPhone,_that.totalAmount,_that.shippingAmount,_that.status,_that.adminNote,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'user_email')  String? userEmail, @JsonKey(name: 'user_phone')  String? userPhone, @JsonKey(name: 'total_amount', fromJson: asDouble)  double totalAmount, @JsonKey(name: 'shipping_amount', fromJson: asDouble)  double shippingAmount,  String? status, @JsonKey(name: 'admin_note')  String? adminNote, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'order_items')  List<OrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userEmail,_that.userPhone,_that.totalAmount,_that.shippingAmount,_that.status,_that.adminNote,_that.createdAt,_that.updatedAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({required this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'user_name') this.userName, @JsonKey(name: 'user_email') this.userEmail, @JsonKey(name: 'user_phone') this.userPhone, @JsonKey(name: 'total_amount', fromJson: asDouble) this.totalAmount = 0, @JsonKey(name: 'shipping_amount', fromJson: asDouble) this.shippingAmount = 0, this.status, @JsonKey(name: 'admin_note') this.adminNote, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'order_items')  List<OrderItem> items = const <OrderItem>[]}): _items = items,super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'user_name') final  String? userName;
@override@JsonKey(name: 'user_email') final  String? userEmail;
@override@JsonKey(name: 'user_phone') final  String? userPhone;
@override@JsonKey(name: 'total_amount', fromJson: asDouble) final  double totalAmount;
@override@JsonKey(name: 'shipping_amount', fromJson: asDouble) final  double shippingAmount;
@override final  String? status;
@override@JsonKey(name: 'admin_note') final  String? adminNote;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
 final  List<OrderItem> _items;
@override@JsonKey(name: 'order_items') List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userPhone, userPhone) || other.userPhone == userPhone)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.shippingAmount, shippingAmount) || other.shippingAmount == shippingAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.adminNote, adminNote) || other.adminNote == adminNote)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,userName,userEmail,userPhone,totalAmount,shippingAmount,status,adminNote,createdAt,updatedAt,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'Order(id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, totalAmount: $totalAmount, shippingAmount: $shippingAmount, status: $status, adminNote: $adminNote, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'user_email') String? userEmail,@JsonKey(name: 'user_phone') String? userPhone,@JsonKey(name: 'total_amount', fromJson: asDouble) double totalAmount,@JsonKey(name: 'shipping_amount', fromJson: asDouble) double shippingAmount, String? status,@JsonKey(name: 'admin_note') String? adminNote,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'order_items') List<OrderItem> items
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? userName = freezed,Object? userEmail = freezed,Object? userPhone = freezed,Object? totalAmount = null,Object? shippingAmount = null,Object? status = freezed,Object? adminNote = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: freezed == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String?,userPhone: freezed == userPhone ? _self.userPhone : userPhone // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,shippingAmount: null == shippingAmount ? _self.shippingAmount : shippingAmount // ignore: cast_nullable_to_non_nullable
as double,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,adminNote: freezed == adminNote ? _self.adminNote : adminNote // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}


}

// dart format on
