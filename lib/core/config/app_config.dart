import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/json_utils.dart';
import 'constants.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

/// The single row of `app_config`: version gate, maintenance switch and
/// server-tunable display values (spec §6.1, §11.33).
@freezed
abstract class AppConfig with _$AppConfig {
  const AppConfig._();

  const factory AppConfig({
    @JsonKey(name: 'min_supported_version') String? minSupportedVersion,
    @JsonKey(name: 'latest_version') String? latestVersion,
    @JsonKey(name: 'android_store_url') String? androidStoreUrl,
    @JsonKey(name: 'ios_store_url') String? iosStoreUrl,
    @JsonKey(name: 'maintenance_message') String? maintenanceMessage,
    @JsonKey(name: 'shipping_fee_lkr', fromJson: asDoubleOrNull) double? shippingFeeLkr,
    @JsonKey(name: 'surplus_medium_ratio', fromJson: asDoubleOrNull) double? surplusMediumRatio,
    @JsonKey(name: 'surplus_high_ratio', fromJson: asDoubleOrNull) double? surplusHighRatio,
    @JsonKey(name: 'surplus_alert_ratio', fromJson: asDoubleOrNull) double? surplusAlertRatio,
    @JsonKey(name: 'diesel_price_lkr', fromJson: asDoubleOrNull) double? dieselPriceLkr,
    @JsonKey(name: 'chat_limit_per_min', fromJson: asIntOrNull) int? chatLimitPerMin,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

  bool get inMaintenance => maintenanceMessage != null && maintenanceMessage!.trim().isNotEmpty;

  double get shippingFee => shippingFeeLkr ?? AppConst.shippingFee;
  double get mediumRatio => surplusMediumRatio ?? AppConst.surplusMediumRatio;
  double get highRatio => surplusHighRatio ?? AppConst.surplusHighRatio;

  /// True when [current] is older than `min_supported_version`.
  bool requiresUpdate(String current) =>
      minSupportedVersion != null && compareVersions(current, minSupportedVersion!) < 0;

  /// True when a newer (optional) version is in the store.
  bool hasUpdate(String current) =>
      latestVersion != null && compareVersions(current, latestVersion!) < 0;
}

/// Compares semantic versions; build metadata (`+12`) and pre-release tags are
/// ignored. Returns <0, 0 or >0 like [Comparable.compareTo].
int compareVersions(String a, String b) {
  List<int> parse(String v) => v
      .split('+')
      .first
      .split('-')
      .first
      .split('.')
      .map((p) => int.tryParse(p.trim()) ?? 0)
      .toList();
  final pa = parse(a), pb = parse(b);
  for (var i = 0; i < 3; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}
