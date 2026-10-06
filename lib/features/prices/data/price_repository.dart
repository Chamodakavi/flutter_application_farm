import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/hive_boxes.dart';
import '../../../core/config/constants.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json_utils.dart';
import '../domain/price_forecast.dart';
import '../domain/price_overview.dart';
import '../domain/price_series.dart';

/// Reads the model output and past prices (spec §13.6). The app never runs
/// the model; it only reads stored rows, cached for six hours so prices and
/// the planner keep working offline (spec §17.3).
class PriceRepository {
  PriceRepository(this._db, this._cache);

  final SupabaseClient _db;
  final CacheStore _cache;

  Future<List<T>> _cached<T>({
    required String key,
    required bool forceRefresh,
    required Future<Object?> Function() load,
    required T? Function(Map<String, dynamic> row) parse,
  }) => _cache.fetch<List<T>>(
    box: HiveBoxes.cachePrices,
    key: key,
    ttl: CacheTtl.prices,
    forceRefresh: forceRefresh,
    load: load,
    decode: (json) => asRows(json).map(parse).whereType<T>().toList(),
  );

  /// Rows of the `crop_price_overview` view (current month).
  Future<List<PriceOverview>> overview({bool forceRefresh = false}) => _cached(
    key: 'overview',
    forceRefresh: forceRefresh,
    load: () => _db.from(Tables.priceOverview).select().order('crop_name', ascending: true),
    parse: (row) => row['crop_name'] == null ? null : PriceOverview.fromJson(row),
  );

  /// Forecast rows of every crop from last month on, in one query; callers
  /// group them per crop and keep the newest model version. Newest runs are
  /// requested first so a server row limit can only cut off old versions.
  Future<List<PriceForecast>> forecasts({bool forceRefresh = false, DateTime? now}) {
    final from = addMonths(monthOf(now ?? DateTime.now()), -1);
    return _cached<PriceForecast>(
      key: 'forecasts',
      forceRefresh: forceRefresh,
      load: () => _db
          .from(Tables.priceForecasts)
          .select()
          .gte('year', from.year)
          .order('generated_at')
          .order('crop_name', ascending: true)
          .order('year', ascending: true)
          .order('month', ascending: true),
      parse: (row) => row['crop_name'] == null ? null : PriceForecast.fromJson(row),
    ).then((rows) => rows.where((f) => !f.harvestDate.isBefore(from)).toList());
  }

  /// Actual wholesale prices of one crop for the last [months] months.
  Future<List<PricePoint>> history(
    String crop, {
    int months = 24,
    bool forceRefresh = false,
    DateTime? now,
  }) {
    final key = cropKey(crop);
    final from = addMonths(monthOf(now ?? DateTime.now()), -months);
    return _cached<PricePoint>(
      key: 'history_$key',
      forceRefresh: forceRefresh,
      load: () => _db
          .from(Tables.priceHistory)
          .select('year,month,wholesale_price')
          .eq('crop_name', key)
          .gte('year', from.year)
          .order('year', ascending: true)
          .order('month', ascending: true),
      parse: _historyPoint,
    ).then((points) => points.where((p) => !p.date.isBefore(from)).toList());
  }

  /// The last few actual prices of every crop in one query — the fallback for
  /// "this month" and "last month" on the list while a forecast is pending.
  Future<Map<String, List<PricePoint>>> recentHistory({
    int months = 6,
    bool forceRefresh = false,
    DateTime? now,
  }) async {
    final from = addMonths(monthOf(now ?? DateTime.now()), -months);
    final rows = await _cached<MapEntry<String, PricePoint>>(
      key: 'history_recent',
      forceRefresh: forceRefresh,
      load: () => _db
          .from(Tables.priceHistory)
          .select('crop_name,year,month,wholesale_price')
          .gte('year', from.year)
          .order('year', ascending: true)
          .order('month', ascending: true),
      parse: (row) {
        final point = _historyPoint(row);
        final name = row['crop_name'];
        return (point == null || name == null) ? null : MapEntry(cropKey('$name'), point);
      },
    );
    final byCrop = <String, List<PricePoint>>{};
    for (final entry in rows) {
      if (entry.value.date.isBefore(from)) continue;
      byCrop.putIfAbsent(entry.key, () => []).add(entry.value);
    }
    return byCrop;
  }

  static PricePoint? _historyPoint(Map<String, dynamic> row) {
    final month = asIntOrNull(row['month']);
    if (asIntOrNull(row['year']) == null || month == null || month < 1 || month > 12) return null;
    if (asDoubleOrNull(row['wholesale_price']) == null) return null;
    return PricePoint.fromHistoryRow(row);
  }
}

final priceRepositoryProvider = Provider<PriceRepository>(
  (ref) => PriceRepository(ref.watch(supabaseClientProvider), ref.watch(cacheStoreProvider)),
);
