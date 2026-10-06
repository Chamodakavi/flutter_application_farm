// In-memory doubles shared by the registration and prices tests.
import 'dart:async';

import 'package:farmfriend/core/analytics/analytics_service.dart';
import 'package:farmfriend/features/prices/data/price_repository.dart';
import 'package:farmfriend/features/prices/domain/price_forecast.dart';
import 'package:farmfriend/features/prices/domain/price_overview.dart';
import 'package:farmfriend/features/prices/domain/price_series.dart';
import 'package:farmfriend/features/registration/data/registration_repository.dart';
import 'package:farmfriend/features/registration/domain/bucket_status.dart';
import 'package:farmfriend/features/registration/domain/farmer_registration.dart';
import 'package:farmfriend/features/registration/domain/register_result.dart';

BucketStatus bucket(
  String crop, {
  double limit = 1000,
  double filled = 0,
  double? fairPrice,
  double? wholesalePrice,
  int farmers = 0,
  int? year,
  int? month,
  String? harvestDate,
  String? plantingDate,
}) => BucketStatus(
  cropName: crop,
  limitMt: limit,
  filledMt: filled,
  remainingMt: limit - filled,
  farmerCount: farmers,
  fairPrice: fairPrice,
  wholesalePrice: wholesalePrice,
  year: year,
  month: month,
  harvestDate: harvestDate,
  plantingDate: plantingDate,
);

PriceForecast forecast(
  String crop,
  int year,
  int month, {
  double wholesale = 180,
  double? cost = 100,
  double? fair,
  double? floor,
  double? retail,
  double? goalMt = 20000,
  double? extentHa = 1000,
  int? plantingYear,
  int? plantingMonth,
  String version = 'v1',
  DateTime? generatedAt,
}) => PriceForecast(
  cropName: crop,
  year: year,
  month: month,
  wholesalePrice: wholesale,
  costPerKg: cost,
  fairPrice: fair ?? (cost == null ? null : cost * 1.4),
  floorPrice: floor ?? cost,
  retailPrice: retail,
  harvestGoalMt: goalMt,
  allowedExtentHa: extentHa,
  plantingYear: plantingYear,
  plantingMonth: plantingMonth,
  modelVersion: version,
  generatedAt: generatedAt,
);

/// Records events instead of sending them.
class FakeAnalytics extends AnalyticsService {
  FakeAnalytics(super.ref);

  final events = <(String, Map<String, Object?>)>[];

  Map<String, Object?>? propsOf(String event) {
    for (final e in events.reversed) {
      if (e.$1 == event) return e.$2;
    }
    return null;
  }

  @override
  void track(String event, [Map<String, Object?> props = const {}]) => events.add((event, props));
}

class FakeRegistrationRepository implements RegistrationRepository {
  FakeRegistrationRepository({
    List<BucketStatus> buckets = const [],
    List<FarmerRegistration> registrations = const [],
    this.cropRegistrations = const [],
  }) : buckets = [...buckets],
       registrations = [...registrations];

  List<BucketStatus> buckets;
  List<FarmerRegistration> registrations;
  List<CropRegistration> cropRegistrations;

  /// Answer of the next `register_harvest` call; an [Exception] is thrown.
  Object result = const RegisterResult.success();

  /// When set, `register` waits for it — lets a test look at the UI while the
  /// RPC is still running.
  Completer<void>? gate;

  int bucketCalls = 0;

  /// `forceRefresh` of every bucket read, in order.
  final bucketForced = <bool>[];
  int registrationCalls = 0;
  final registerCalls = <(String, double)>[];
  bool watching = false;

  @override
  Future<List<BucketStatus>> bucketStatus({bool forceRefresh = false}) async {
    bucketCalls++;
    bucketForced.add(forceRefresh);
    return buckets;
  }

  @override
  DateTime? get bucketSavedAt => null;

  @override
  Future<RegisterResult> register(String cropName, double amountMt) async {
    registerCalls.add((cropName, amountMt));
    await gate?.future;
    final answer = result;
    if (answer is RegisterResult) return answer;
    throw answer;
  }

  @override
  Future<List<FarmerRegistration>> myRegistrations(String uid, {bool forceRefresh = false}) async {
    registrationCalls++;
    return registrations;
  }

  @override
  Future<List<CropRegistration>> myCropRegistrations(String uid, {bool forceRefresh = false}) async =>
      cropRegistrations;

  @override
  void Function() watchRegistrations(void Function() onInsert) {
    watching = true;
    return () => watching = false;
  }
}

class FakePriceRepository implements PriceRepository {
  FakePriceRepository({
    this.overviewRows = const [],
    this.forecastRows = const [],
    this.historyRows = const {},
    this.overviewError,
  });

  List<PriceOverview> overviewRows;
  List<PriceForecast> forecastRows;

  /// Actual prices by UPPERCASE crop key.
  Map<String, List<PricePoint>> historyRows;
  Object? overviewError;

  @override
  Future<List<PriceOverview>> overview({bool forceRefresh = false}) async {
    if (overviewError != null) throw overviewError!;
    return overviewRows;
  }

  @override
  Future<List<PriceForecast>> forecasts({bool forceRefresh = false, DateTime? now}) async =>
      forecastRows;

  @override
  Future<List<PricePoint>> history(
    String crop, {
    int months = 24,
    bool forceRefresh = false,
    DateTime? now,
  }) async => historyRows[cropKey(crop)] ?? const [];

  @override
  Future<Map<String, List<PricePoint>>> recentHistory({
    int months = 6,
    bool forceRefresh = false,
    DateTime? now,
  }) async => historyRows;
}
