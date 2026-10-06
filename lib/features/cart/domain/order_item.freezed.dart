// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItem {

 int get id;@JsonKey(name: 'order_id', fromJson: asIntOrNull) int? get orderId;@JsonKey(name: 'product_id', fromJson: asStringOrNull) String? get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'product_image') String? get productImage;@JsonKey(name: 'product_price', fromJson: asDouble) double get productPrice;@JsonKey(fromJson: asInt) int get quantity;@JsonKey(fromJson: asDoubleOrNull) double? get subtotal;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrderItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orderId, _this.orderId) || other.orderId == _this.orderId)&&(identical(other.productId, _this.productId) || other.productId == _this.productId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.productImage, _this.productImage) || other.productImage == _this.productImage)&&(identical(other.productPrice, _this.productPrice) || other.productPrice == _this.productPrice)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.subtotal, _this.subtotal) || other.subtotal == _this.subtotal)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrderItem;
  return Object.hash(runtimeType,_this.id,_this.orderId,_this.productId,_this.productName,_this.productImage,_this.productPrice,_this.quantity,_this.subtotal,_this.createdAt);
}

@override
String toString() {
  final _this = this as OrderItem;
  return 'OrderItem(id: ${_this.id}, orderId: ${_this.orderId}, productId: ${_this.productId}, productName: ${_this.productName}, productImage: ${_this.productImage}, productPrice: ${_this.productPrice}, quantity: ${_this.quantity}, subtotal: ${_this.subtotal}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'order_id', fromJson: asIntOrNull) int? orderId,@JsonKey(name: 'product_id', fromJson: asStringOrNull) String? productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_image') String? productImage,@JsonKey(name: 'product_price', fromJson: asDouble) double productPrice,@JsonKey(fromJson: asInt) int quantity,@JsonKey(fromJson: asDoubleOrNull) double? subtotal,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = freezed,Object? productId = freezed,Object? productName = null,Object? productImage = freezed,Object? productPrice = null,Object? quantity = null,Object? subtotal = freezed,Object? createdAt = freezed,}) {
  return _then(OrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,productPrice: null == productPrice ? _self.productPrice : productPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'order_id', fromJson: asIntOrNull)  int? orderId, @JsonKey(name: 'product_id', fromJson: asStringOrNull)  String? productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_image')  String? productImage, @JsonKey(name: 'product_price', fromJson: asDouble)  double productPrice, @JsonKey(fromJson: asInt)  int quantity, @JsonKey(fromJson: asDoubleOrNull)  double? subtotal, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.productImage,_that.productPrice,_that.quantity,_that.subtotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'order_id', fromJson: asIntOrNull)  int? orderId, @JsonKey(name: 'product_id', fromJson: asStringOrNull)  String? productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_image')  String? productImage, @JsonKey(name: 'product_price', fromJson: asDouble)  double productPrice, @JsonKey(fromJson: asInt)  int quantity, @JsonKey(fromJson: asDoubleOrNull)  double? subtotal, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.productImage,_that.productPrice,_that.quantity,_that.subtotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'order_id', fromJson: asIntOrNull)  int? orderId, @JsonKey(name: 'product_id', fromJson: asStringOrNull)  String? productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_image')  String? productImage, @JsonKey(name: 'product_price', fromJson: asDouble)  double productPrice, @JsonKey(fromJson: asInt)  int quantity, @JsonKey(fromJson: asDoubleOrNull)  double? subtotal, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.productImage,_that.productPrice,_that.quantity,_that.subtotal,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem extends OrderItem {
  const _OrderItem({required this.id, @JsonKey(name: 'order_id', fromJson: asIntOrNull) this.orderId, @JsonKey(name: 'product_id', fromJson: asStringOrNull) this.productId, @JsonKey(name: 'product_name') this.productName = '', @JsonKey(name: 'product_image') this.productImage, @JsonKey(name: 'product_price', fromJson: asDouble) this.productPrice = 0, @JsonKey(fromJson: asInt) this.quantity = 0, @JsonKey(fromJson: asDoubleOrNull) this.subtotal, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'order_id', fromJson: asIntOrNull) final  int? orderId;
@override@JsonKey(name: 'product_id', fromJson: asStringOrNull) final  String? productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'product_image') final  String? productImage;
@override@JsonKey(name: 'product_price', fromJson: asDouble) final  double productPrice;
@override@JsonKey(fromJson: asInt) final  int quantity;
@override@JsonKey(fromJson: asDoubleOrNull) final  double? subtotal;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.productPrice, productPrice) || other.productPrice == productPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orderId,productId,productName,productImage,productPrice,quantity,subtotal,createdAt);
}

@override
String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, productName: $productName, productImage: $productImage, productPrice: $productPrice, quantity: $quantity, subtotal: $subtotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'order_id', fromJson: asIntOrNull) int? orderId,@JsonKey(name: 'product_id', fromJson: asStringOrNull) String? productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_image') String? productImage,@JsonKey(name: 'product_price', fromJson: asDouble) double productPrice,@JsonKey(fromJson: asInt) int quantity,@JsonKey(fromJson: asDoubleOrNull) double? subtotal,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = freezed,Object? productId = freezed,Object? productName = null,Object? productImage = freezed,Object? productPrice = null,Object? quantity = null,Object? subtotal = freezed,Object? createdAt = freezed,}) {
  return _then(_OrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int?,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,productPrice: null == productPrice ? _self.productPrice : productPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

PlaceOrderResult _$PlaceOrderResultFromJson(
  Map<String, dynamic> json
) {
        switch (json['status']) {
                  case 'success':
          return PlaceOrderSuccess.fromJson(
            json
          );
                case 'empty_cart':
          return PlaceOrderEmptyCart.fromJson(
            json
          );
                case 'insufficient_stock':
          return PlaceOrderInsufficientStock.fromJson(
            json
          );
        
          default:
            return PlaceOrderUnknown.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$PlaceOrderResult {



  /// Serializes this PlaceOrderResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceOrderResult);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PlaceOrderResult()';
}


}

/// @nodoc
class $PlaceOrderResultCopyWith<$Res>  {
$PlaceOrderResultCopyWith(PlaceOrderResult _, $Res Function(PlaceOrderResult) __);
}


/// Adds pattern-matching-related methods to [PlaceOrderResult].
extension PlaceOrderResultPatterns on PlaceOrderResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlaceOrderSuccess value)?  success,TResult Function( PlaceOrderEmptyCart value)?  emptyCart,TResult Function( PlaceOrderInsufficientStock value)?  insufficientStock,TResult Function( PlaceOrderUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlaceOrderSuccess() when success != null:
return success(_that);case PlaceOrderEmptyCart() when emptyCart != null:
return emptyCart(_that);case PlaceOrderInsufficientStock() when insufficientStock != null:
return insufficientStock(_that);case PlaceOrderUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlaceOrderSuccess value)  success,required TResult Function( PlaceOrderEmptyCart value)  emptyCart,required TResult Function( PlaceOrderInsufficientStock value)  insufficientStock,required TResult Function( PlaceOrderUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case PlaceOrderSuccess():
return success(_that);case PlaceOrderEmptyCart():
return emptyCart(_that);case PlaceOrderInsufficientStock():
return insufficientStock(_that);case PlaceOrderUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlaceOrderSuccess value)?  success,TResult? Function( PlaceOrderEmptyCart value)?  emptyCart,TResult? Function( PlaceOrderInsufficientStock value)?  insufficientStock,TResult? Function( PlaceOrderUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case PlaceOrderSuccess() when success != null:
return success(_that);case PlaceOrderEmptyCart() when emptyCart != null:
return emptyCart(_that);case PlaceOrderInsufficientStock() when insufficientStock != null:
return insufficientStock(_that);case PlaceOrderUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@JsonKey(name: 'order_id', fromJson: asInt)  int orderId, @JsonKey(fromJson: asDoubleOrNull)  double? total, @JsonKey(fromJson: asDoubleOrNull)  double? shipping)?  success,TResult Function()?  emptyCart,TResult Function(@JsonKey(name: 'product_id', fromJson: asStringOrNull)  String? productId, @JsonKey(name: 'product_name')  String? productName, @JsonKey(fromJson: asInt)  int available)?  insufficientStock,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlaceOrderSuccess() when success != null:
return success(_that.orderId,_that.total,_that.shipping);case PlaceOrderEmptyCart() when emptyCart != null:
return emptyCart();case PlaceOrderInsufficientStock() when insufficientStock != null:
return insufficientStock(_that.productId,_that.productName,_that.available);case PlaceOrderUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@JsonKey(name: 'order_id', fromJson: asInt)  int orderId, @JsonKey(fromJson: asDoubleOrNull)  double? total, @JsonKey(fromJson: asDoubleOrNull)  double? shipping)  success,required TResult Function()  emptyCart,required TResult Function(@JsonKey(name: 'product_id', fromJson: asStringOrNull)  String? productId, @JsonKey(name: 'product_name')  String? productName, @JsonKey(fromJson: asInt)  int available)  insufficientStock,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case PlaceOrderSuccess():
return success(_that.orderId,_that.total,_that.shipping);case PlaceOrderEmptyCart():
return emptyCart();case PlaceOrderInsufficientStock():
return insufficientStock(_that.productId,_that.productName,_that.available);case PlaceOrderUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@JsonKey(name: 'order_id', fromJson: asInt)  int orderId, @JsonKey(fromJson: asDoubleOrNull)  double? total, @JsonKey(fromJson: asDoubleOrNull)  double? shipping)?  success,TResult? Function()?  emptyCart,TResult? Function(@JsonKey(name: 'product_id', fromJson: asStringOrNull)  String? productId, @JsonKey(name: 'product_name')  String? productName, @JsonKey(fromJson: asInt)  int available)?  insufficientStock,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case PlaceOrderSuccess() when success != null:
return success(_that.orderId,_that.total,_that.shipping);case PlaceOrderEmptyCart() when emptyCart != null:
return emptyCart();case PlaceOrderInsufficientStock() when insufficientStock != null:
return insufficientStock(_that.productId,_that.productName,_that.available);case PlaceOrderUnknown() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PlaceOrderSuccess implements PlaceOrderResult {
  const PlaceOrderSuccess({@JsonKey(name: 'order_id', fromJson: asInt) required this.orderId, @JsonKey(fromJson: asDoubleOrNull) this.total, @JsonKey(fromJson: asDoubleOrNull) this.shipping,  String? $type}): $type = $type ?? 'success';
  factory PlaceOrderSuccess.fromJson(Map<String, dynamic> json) => _$PlaceOrderSuccessFromJson(json);

@JsonKey(name: 'order_id', fromJson: asInt) final  int orderId;
@JsonKey(fromJson: asDoubleOrNull) final  double? total;
@JsonKey(fromJson: asDoubleOrNull) final  double? shipping;

@JsonKey(name: 'status')
final String $type;


/// Create a copy of PlaceOrderResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceOrderSuccessCopyWith<PlaceOrderSuccess> get copyWith => _$PlaceOrderSuccessCopyWithImpl<PlaceOrderSuccess>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceOrderSuccessToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceOrderSuccess&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.total, total) || other.total == total)&&(identical(other.shipping, shipping) || other.shipping == shipping));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,orderId,total,shipping);
}

@override
String toString() {
    return 'PlaceOrderResult.success(orderId: $orderId, total: $total, shipping: $shipping)';
}


}

/// @nodoc
abstract mixin class $PlaceOrderSuccessCopyWith<$Res> implements $PlaceOrderResultCopyWith<$Res> {
  factory $PlaceOrderSuccessCopyWith(PlaceOrderSuccess value, $Res Function(PlaceOrderSuccess) _then) = _$PlaceOrderSuccessCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id', fromJson: asInt) int orderId,@JsonKey(fromJson: asDoubleOrNull) double? total,@JsonKey(fromJson: asDoubleOrNull) double? shipping
});




}
/// @nodoc
class _$PlaceOrderSuccessCopyWithImpl<$Res>
    implements $PlaceOrderSuccessCopyWith<$Res> {
  _$PlaceOrderSuccessCopyWithImpl(this._self, this._then);

  final PlaceOrderSuccess _self;
  final $Res Function(PlaceOrderSuccess) _then;

/// Create a copy of PlaceOrderResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? total = freezed,Object? shipping = freezed,}) {
  return _then(PlaceOrderSuccess(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double?,shipping: freezed == shipping ? _self.shipping : shipping // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlaceOrderEmptyCart implements PlaceOrderResult {
  const PlaceOrderEmptyCart({ String? $type}): $type = $type ?? 'empty_cart';
  factory PlaceOrderEmptyCart.fromJson(Map<String, dynamic> json) => _$PlaceOrderEmptyCartFromJson(json);



@JsonKey(name: 'status')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$PlaceOrderEmptyCartToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceOrderEmptyCart);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PlaceOrderResult.emptyCart()';
}


}




/// @nodoc
@JsonSerializable()

class PlaceOrderInsufficientStock implements PlaceOrderResult {
  const PlaceOrderInsufficientStock({@JsonKey(name: 'product_id', fromJson: asStringOrNull) this.productId, @JsonKey(name: 'product_name') this.productName, @JsonKey(fromJson: asInt) this.available = 0,  String? $type}): $type = $type ?? 'insufficient_stock';
  factory PlaceOrderInsufficientStock.fromJson(Map<String, dynamic> json) => _$PlaceOrderInsufficientStockFromJson(json);

@JsonKey(name: 'product_id', fromJson: asStringOrNull) final  String? productId;
@JsonKey(name: 'product_name') final  String? productName;
@JsonKey(fromJson: asInt) final  int available;

@JsonKey(name: 'status')
final String $type;


/// Create a copy of PlaceOrderResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceOrderInsufficientStockCopyWith<PlaceOrderInsufficientStock> get copyWith => _$PlaceOrderInsufficientStockCopyWithImpl<PlaceOrderInsufficientStock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceOrderInsufficientStockToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceOrderInsufficientStock&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,productId,productName,available);
}

@override
String toString() {
    return 'PlaceOrderResult.insufficientStock(productId: $productId, productName: $productName, available: $available)';
}


}

/// @nodoc
abstract mixin class $PlaceOrderInsufficientStockCopyWith<$Res> implements $PlaceOrderResultCopyWith<$Res> {
  factory $PlaceOrderInsufficientStockCopyWith(PlaceOrderInsufficientStock value, $Res Function(PlaceOrderInsufficientStock) _then) = _$PlaceOrderInsufficientStockCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id', fromJson: asStringOrNull) String? productId,@JsonKey(name: 'product_name') String? productName,@JsonKey(fromJson: asInt) int available
});




}
/// @nodoc
class _$PlaceOrderInsufficientStockCopyWithImpl<$Res>
    implements $PlaceOrderInsufficientStockCopyWith<$Res> {
  _$PlaceOrderInsufficientStockCopyWithImpl(this._self, this._then);

  final PlaceOrderInsufficientStock _self;
  final $Res Function(PlaceOrderInsufficientStock) _then;

/// Create a copy of PlaceOrderResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = freezed,Object? productName = freezed,Object? available = null,}) {
  return _then(PlaceOrderInsufficientStock(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlaceOrderUnknown implements PlaceOrderResult {
  const PlaceOrderUnknown({ String? $type}): $type = $type ?? 'unknown';
  factory PlaceOrderUnknown.fromJson(Map<String, dynamic> json) => _$PlaceOrderUnknownFromJson(json);



@JsonKey(name: 'status')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$PlaceOrderUnknownToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceOrderUnknown);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PlaceOrderResult.unknown()';
}


}




// dart format on
