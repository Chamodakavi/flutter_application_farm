// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {

@JsonKey(name: 'min_supported_version') String? get minSupportedVersion;@JsonKey(name: 'latest_version') String? get latestVersion;@JsonKey(name: 'android_store_url') String? get androidStoreUrl;@JsonKey(name: 'ios_store_url') String? get iosStoreUrl;@JsonKey(name: 'maintenance_message') String? get maintenanceMessage;@JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull) double? get shippingFeeLkr;@JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull) double? get surplusMediumRatio;@JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull) double? get surplusHighRatio;@JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull) double? get surplusAlertRatio;@JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull) double? get dieselPriceLkr;@JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull) int? get chatLimitPerMin;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&(identical(other.minSupportedVersion, _this.minSupportedVersion) || other.minSupportedVersion == _this.minSupportedVersion)&&(identical(other.latestVersion, _this.latestVersion) || other.latestVersion == _this.latestVersion)&&(identical(other.androidStoreUrl, _this.androidStoreUrl) || other.androidStoreUrl == _this.androidStoreUrl)&&(identical(other.iosStoreUrl, _this.iosStoreUrl) || other.iosStoreUrl == _this.iosStoreUrl)&&(identical(other.maintenanceMessage, _this.maintenanceMessage) || other.maintenanceMessage == _this.maintenanceMessage)&&(identical(other.shippingFeeLkr, _this.shippingFeeLkr) || other.shippingFeeLkr == _this.shippingFeeLkr)&&(identical(other.surplusMediumRatio, _this.surplusMediumRatio) || other.surplusMediumRatio == _this.surplusMediumRatio)&&(identical(other.surplusHighRatio, _this.surplusHighRatio) || other.surplusHighRatio == _this.surplusHighRatio)&&(identical(other.surplusAlertRatio, _this.surplusAlertRatio) || other.surplusAlertRatio == _this.surplusAlertRatio)&&(identical(other.dieselPriceLkr, _this.dieselPriceLkr) || other.dieselPriceLkr == _this.dieselPriceLkr)&&(identical(other.chatLimitPerMin, _this.chatLimitPerMin) || other.chatLimitPerMin == _this.chatLimitPerMin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppConfig;
  return Object.hash(runtimeType,_this.minSupportedVersion,_this.latestVersion,_this.androidStoreUrl,_this.iosStoreUrl,_this.maintenanceMessage,_this.shippingFeeLkr,_this.surplusMediumRatio,_this.surplusHighRatio,_this.surplusAlertRatio,_this.dieselPriceLkr,_this.chatLimitPerMin);
}

@override
String toString() {
  final _this = this as AppConfig;
  return 'AppConfig(minSupportedVersion: ${_this.minSupportedVersion}, latestVersion: ${_this.latestVersion}, androidStoreUrl: ${_this.androidStoreUrl}, iosStoreUrl: ${_this.iosStoreUrl}, maintenanceMessage: ${_this.maintenanceMessage}, shippingFeeLkr: ${_this.shippingFeeLkr}, surplusMediumRatio: ${_this.surplusMediumRatio}, surplusHighRatio: ${_this.surplusHighRatio}, surplusAlertRatio: ${_this.surplusAlertRatio}, dieselPriceLkr: ${_this.dieselPriceLkr}, chatLimitPerMin: ${_this.chatLimitPerMin})';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'min_supported_version') String? minSupportedVersion,@JsonKey(name: 'latest_version') String? latestVersion,@JsonKey(name: 'android_store_url') String? androidStoreUrl,@JsonKey(name: 'ios_store_url') String? iosStoreUrl,@JsonKey(name: 'maintenance_message') String? maintenanceMessage,@JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull) double? shippingFeeLkr,@JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull) double? surplusMediumRatio,@JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull) double? surplusHighRatio,@JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull) double? surplusAlertRatio,@JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull) double? dieselPriceLkr,@JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull) int? chatLimitPerMin
});




}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minSupportedVersion = freezed,Object? latestVersion = freezed,Object? androidStoreUrl = freezed,Object? iosStoreUrl = freezed,Object? maintenanceMessage = freezed,Object? shippingFeeLkr = freezed,Object? surplusMediumRatio = freezed,Object? surplusHighRatio = freezed,Object? surplusAlertRatio = freezed,Object? dieselPriceLkr = freezed,Object? chatLimitPerMin = freezed,}) {
  return _then(AppConfig(
minSupportedVersion: freezed == minSupportedVersion ? _self.minSupportedVersion : minSupportedVersion // ignore: cast_nullable_to_non_nullable
as String?,latestVersion: freezed == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String?,androidStoreUrl: freezed == androidStoreUrl ? _self.androidStoreUrl : androidStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,iosStoreUrl: freezed == iosStoreUrl ? _self.iosStoreUrl : iosStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,maintenanceMessage: freezed == maintenanceMessage ? _self.maintenanceMessage : maintenanceMessage // ignore: cast_nullable_to_non_nullable
as String?,shippingFeeLkr: freezed == shippingFeeLkr ? _self.shippingFeeLkr : shippingFeeLkr // ignore: cast_nullable_to_non_nullable
as double?,surplusMediumRatio: freezed == surplusMediumRatio ? _self.surplusMediumRatio : surplusMediumRatio // ignore: cast_nullable_to_non_nullable
as double?,surplusHighRatio: freezed == surplusHighRatio ? _self.surplusHighRatio : surplusHighRatio // ignore: cast_nullable_to_non_nullable
as double?,surplusAlertRatio: freezed == surplusAlertRatio ? _self.surplusAlertRatio : surplusAlertRatio // ignore: cast_nullable_to_non_nullable
as double?,dieselPriceLkr: freezed == dieselPriceLkr ? _self.dieselPriceLkr : dieselPriceLkr // ignore: cast_nullable_to_non_nullable
as double?,chatLimitPerMin: freezed == chatLimitPerMin ? _self.chatLimitPerMin : chatLimitPerMin // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'min_supported_version')  String? minSupportedVersion, @JsonKey(name: 'latest_version')  String? latestVersion, @JsonKey(name: 'android_store_url')  String? androidStoreUrl, @JsonKey(name: 'ios_store_url')  String? iosStoreUrl, @JsonKey(name: 'maintenance_message')  String? maintenanceMessage, @JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull)  double? shippingFeeLkr, @JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull)  double? surplusMediumRatio, @JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull)  double? surplusHighRatio, @JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull)  double? surplusAlertRatio, @JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull)  double? dieselPriceLkr, @JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull)  int? chatLimitPerMin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.minSupportedVersion,_that.latestVersion,_that.androidStoreUrl,_that.iosStoreUrl,_that.maintenanceMessage,_that.shippingFeeLkr,_that.surplusMediumRatio,_that.surplusHighRatio,_that.surplusAlertRatio,_that.dieselPriceLkr,_that.chatLimitPerMin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'min_supported_version')  String? minSupportedVersion, @JsonKey(name: 'latest_version')  String? latestVersion, @JsonKey(name: 'android_store_url')  String? androidStoreUrl, @JsonKey(name: 'ios_store_url')  String? iosStoreUrl, @JsonKey(name: 'maintenance_message')  String? maintenanceMessage, @JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull)  double? shippingFeeLkr, @JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull)  double? surplusMediumRatio, @JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull)  double? surplusHighRatio, @JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull)  double? surplusAlertRatio, @JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull)  double? dieselPriceLkr, @JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull)  int? chatLimitPerMin)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.minSupportedVersion,_that.latestVersion,_that.androidStoreUrl,_that.iosStoreUrl,_that.maintenanceMessage,_that.shippingFeeLkr,_that.surplusMediumRatio,_that.surplusHighRatio,_that.surplusAlertRatio,_that.dieselPriceLkr,_that.chatLimitPerMin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'min_supported_version')  String? minSupportedVersion, @JsonKey(name: 'latest_version')  String? latestVersion, @JsonKey(name: 'android_store_url')  String? androidStoreUrl, @JsonKey(name: 'ios_store_url')  String? iosStoreUrl, @JsonKey(name: 'maintenance_message')  String? maintenanceMessage, @JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull)  double? shippingFeeLkr, @JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull)  double? surplusMediumRatio, @JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull)  double? surplusHighRatio, @JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull)  double? surplusAlertRatio, @JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull)  double? dieselPriceLkr, @JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull)  int? chatLimitPerMin)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.minSupportedVersion,_that.latestVersion,_that.androidStoreUrl,_that.iosStoreUrl,_that.maintenanceMessage,_that.shippingFeeLkr,_that.surplusMediumRatio,_that.surplusHighRatio,_that.surplusAlertRatio,_that.dieselPriceLkr,_that.chatLimitPerMin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfig extends AppConfig {
  const _AppConfig({@JsonKey(name: 'min_supported_version') this.minSupportedVersion, @JsonKey(name: 'latest_version') this.latestVersion, @JsonKey(name: 'android_store_url') this.androidStoreUrl, @JsonKey(name: 'ios_store_url') this.iosStoreUrl, @JsonKey(name: 'maintenance_message') this.maintenanceMessage, @JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull) this.shippingFeeLkr, @JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull) this.surplusMediumRatio, @JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull) this.surplusHighRatio, @JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull) this.surplusAlertRatio, @JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull) this.dieselPriceLkr, @JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull) this.chatLimitPerMin}): super._();
  factory _AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

@override@JsonKey(name: 'min_supported_version') final  String? minSupportedVersion;
@override@JsonKey(name: 'latest_version') final  String? latestVersion;
@override@JsonKey(name: 'android_store_url') final  String? androidStoreUrl;
@override@JsonKey(name: 'ios_store_url') final  String? iosStoreUrl;
@override@JsonKey(name: 'maintenance_message') final  String? maintenanceMessage;
@override@JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull) final  double? shippingFeeLkr;
@override@JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull) final  double? surplusMediumRatio;
@override@JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull) final  double? surplusHighRatio;
@override@JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull) final  double? surplusAlertRatio;
@override@JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull) final  double? dieselPriceLkr;
@override@JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull) final  int? chatLimitPerMin;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.minSupportedVersion, minSupportedVersion) || other.minSupportedVersion == minSupportedVersion)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.androidStoreUrl, androidStoreUrl) || other.androidStoreUrl == androidStoreUrl)&&(identical(other.iosStoreUrl, iosStoreUrl) || other.iosStoreUrl == iosStoreUrl)&&(identical(other.maintenanceMessage, maintenanceMessage) || other.maintenanceMessage == maintenanceMessage)&&(identical(other.shippingFeeLkr, shippingFeeLkr) || other.shippingFeeLkr == shippingFeeLkr)&&(identical(other.surplusMediumRatio, surplusMediumRatio) || other.surplusMediumRatio == surplusMediumRatio)&&(identical(other.surplusHighRatio, surplusHighRatio) || other.surplusHighRatio == surplusHighRatio)&&(identical(other.surplusAlertRatio, surplusAlertRatio) || other.surplusAlertRatio == surplusAlertRatio)&&(identical(other.dieselPriceLkr, dieselPriceLkr) || other.dieselPriceLkr == dieselPriceLkr)&&(identical(other.chatLimitPerMin, chatLimitPerMin) || other.chatLimitPerMin == chatLimitPerMin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,minSupportedVersion,latestVersion,androidStoreUrl,iosStoreUrl,maintenanceMessage,shippingFeeLkr,surplusMediumRatio,surplusHighRatio,surplusAlertRatio,dieselPriceLkr,chatLimitPerMin);
}

@override
String toString() {
    return 'AppConfig(minSupportedVersion: $minSupportedVersion, latestVersion: $latestVersion, androidStoreUrl: $androidStoreUrl, iosStoreUrl: $iosStoreUrl, maintenanceMessage: $maintenanceMessage, shippingFeeLkr: $shippingFeeLkr, surplusMediumRatio: $surplusMediumRatio, surplusHighRatio: $surplusHighRatio, surplusAlertRatio: $surplusAlertRatio, dieselPriceLkr: $dieselPriceLkr, chatLimitPerMin: $chatLimitPerMin)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'min_supported_version') String? minSupportedVersion,@JsonKey(name: 'latest_version') String? latestVersion,@JsonKey(name: 'android_store_url') String? androidStoreUrl,@JsonKey(name: 'ios_store_url') String? iosStoreUrl,@JsonKey(name: 'maintenance_message') String? maintenanceMessage,@JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull) double? shippingFeeLkr,@JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull) double? surplusMediumRatio,@JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull) double? surplusHighRatio,@JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull) double? surplusAlertRatio,@JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull) double? dieselPriceLkr,@JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull) int? chatLimitPerMin
});




}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minSupportedVersion = freezed,Object? latestVersion = freezed,Object? androidStoreUrl = freezed,Object? iosStoreUrl = freezed,Object? maintenanceMessage = freezed,Object? shippingFeeLkr = freezed,Object? surplusMediumRatio = freezed,Object? surplusHighRatio = freezed,Object? surplusAlertRatio = freezed,Object? dieselPriceLkr = freezed,Object? chatLimitPerMin = freezed,}) {
  return _then(_AppConfig(
minSupportedVersion: freezed == minSupportedVersion ? _self.minSupportedVersion : minSupportedVersion // ignore: cast_nullable_to_non_nullable
as String?,latestVersion: freezed == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String?,androidStoreUrl: freezed == androidStoreUrl ? _self.androidStoreUrl : androidStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,iosStoreUrl: freezed == iosStoreUrl ? _self.iosStoreUrl : iosStoreUrl // ignore: cast_nullable_to_non_nullable
as String?,maintenanceMessage: freezed == maintenanceMessage ? _self.maintenanceMessage : maintenanceMessage // ignore: cast_nullable_to_non_nullable
as String?,shippingFeeLkr: freezed == shippingFeeLkr ? _self.shippingFeeLkr : shippingFeeLkr // ignore: cast_nullable_to_non_nullable
as double?,surplusMediumRatio: freezed == surplusMediumRatio ? _self.surplusMediumRatio : surplusMediumRatio // ignore: cast_nullable_to_non_nullable
as double?,surplusHighRatio: freezed == surplusHighRatio ? _self.surplusHighRatio : surplusHighRatio // ignore: cast_nullable_to_non_nullable
as double?,surplusAlertRatio: freezed == surplusAlertRatio ? _self.surplusAlertRatio : surplusAlertRatio // ignore: cast_nullable_to_non_nullable
as double?,dieselPriceLkr: freezed == dieselPriceLkr ? _self.dieselPriceLkr : dieselPriceLkr // ignore: cast_nullable_to_non_nullable
as double?,chatLimitPerMin: freezed == chatLimitPerMin ? _self.chatLimitPerMin : chatLimitPerMin // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
