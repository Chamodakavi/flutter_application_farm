// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
  minSupportedVersion: json['min_supported_version'] as String?,
  latestVersion: json['latest_version'] as String?,
  androidStoreUrl: json['android_store_url'] as String?,
  iosStoreUrl: json['ios_store_url'] as String?,
  maintenanceMessage: json['maintenance_message'] as String?,
  shippingFeeLkr: asDoubleOrNull(json['shipping_fee_lkr']),
  surplusMediumRatio: asDoubleOrNull(json['surplus_medium_ratio']),
  surplusHighRatio: asDoubleOrNull(json['surplus_high_ratio']),
  surplusAlertRatio: asDoubleOrNull(json['surplus_alert_ratio']),
  dieselPriceLkr: asDoubleOrNull(json['diesel_price_lkr']),
  chatLimitPerMin: asIntOrNull(json['chat_limit_per_min']),
);

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'min_supported_version': instance.minSupportedVersion,
      'latest_version': instance.latestVersion,
      'android_store_url': instance.androidStoreUrl,
      'ios_store_url': instance.iosStoreUrl,
      'maintenance_message': instance.maintenanceMessage,
      'shipping_fee_lkr': instance.shippingFeeLkr,
      'surplus_medium_ratio': instance.surplusMediumRatio,
      'surplus_high_ratio': instance.surplusHighRatio,
      'surplus_alert_ratio': instance.surplusAlertRatio,
      'diesel_price_lkr': instance.dieselPriceLkr,
      'chat_limit_per_min': instance.chatLimitPerMin,
    };
