import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/l10n/district_labels.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/weather.dart';

/// Forecast from Open-Meteo — free and keyless, so nothing secret ships in the
/// app (spec §0.2, §15). Cached per district for 30 minutes (spec §17.3).
class WeatherRepository {
  WeatherRepository(this._dio, this._cache);

  final Dio _dio;
  final CacheStore _cache;

  static const endpoint = 'https://api.open-meteo.com/v1/forecast';

  /// Query for [district]'s centroid: current conditions, 7 daily entries and
  /// the hourly chance of rain, in Sri Lanka time.
  static Map<String, Object> queryFor(District district) => {
    'latitude': district.lat,
    'longitude': district.lon,
    'current': 'temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m',
    'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
    'hourly': 'precipitation_probability',
    'forecast_days': 7,
    'timezone': 'Asia/Colombo',
  };

  /// Weather for [district]. Offline, the last saved forecast is returned.
  Future<Weather> fetch(District district, {bool forceRefresh = false}) => guard(
    () => _cache.fetch<Weather>(
      box: HiveBoxes.cacheWeather,
      key: district.key,
      ttl: CacheTtl.weather,
      forceRefresh: forceRefresh,
      load: () async {
        final res = await _dio.get<dynamic>(endpoint, queryParameters: queryFor(district));
        final data = res.data;
        return data is String ? jsonDecode(data) : data;
      },
      decode: (json) => Weather.fromOpenMeteo(Map<String, dynamic>.from(json! as Map)),
    ),
  );

  /// When [district]'s forecast was last downloaded — "updated X ago".
  DateTime? savedAt(District district) => _cache.savedAt(HiveBoxes.cacheWeather, district.key);
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(ref.watch(dioProvider), ref.watch(cacheStoreProvider)),
);
