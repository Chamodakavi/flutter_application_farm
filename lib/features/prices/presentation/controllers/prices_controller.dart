import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderException;

import '../../../registration/data/registration_repository.dart' show RefreshGate;
import '../../data/price_repository.dart';
import '../../domain/price_forecast.dart';
import '../../domain/price_overview.dart';
import '../../domain/price_series.dart';

/// "Today" for every price rule; overridden in tests.
final priceClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final _overviewGateProvider = Provider<RefreshGate>((ref) => RefreshGate());
final _forecastGateProvider = Provider<RefreshGate>((ref) => RefreshGate());
final _recentHistoryGateProvider = Provider<RefreshGate>((ref) => RefreshGate());
final _historyGateProvider = Provider.family<RefreshGate, String>((ref, _) => RefreshGate());

/// Rows of `crop_price_overview` (current month, change vs. last month).
final priceOverviewProvider = FutureProvider<List<PriceOverview>>((ref) {
  final force = ref.watch(_overviewGateProvider).take();
  return ref.watch(priceRepositoryProvider).overview(forceRefresh: force);
});

/// Model forecasts for every crop — only the newest `model_version` of each
/// crop (spec §13.6). Cached, so the planner works offline.
final priceForecastsProvider = FutureProvider<List<PriceForecast>>((ref) async {
  final force = ref.watch(_forecastGateProvider).take();
  final now = ref.watch(priceClockProvider)();
  final rows = await ref
      .watch(priceRepositoryProvider)
      .forecasts(forceRefresh: force, now: now);
  return latestModelVersion(rows);
});

/// The last few actual prices of every crop, keyed by crop.
final recentPriceHistoryProvider = FutureProvider<Map<String, List<PricePoint>>>((ref) {
  final force = ref.watch(_recentHistoryGateProvider).take();
  final now = ref.watch(priceClockProvider)();
  return ref.watch(priceRepositoryProvider).recentHistory(forceRefresh: force, now: now);
});

/// 24 months of actual prices for one crop (database key).
final priceHistoryProvider = FutureProvider.family<List<PricePoint>, String>((ref, crop) {
  final force = ref.watch(_historyGateProvider(crop)).take();
  final now = ref.watch(priceClockProvider)();
  return ref.watch(priceRepositoryProvider).history(crop, forceRefresh: force, now: now);
});

/// Awaits futures without letting one failure sink the rest: the first error
/// is remembered and only rethrown when nothing at all could be shown.
class _Soft {
  Object? error;
  StackTrace? stack;

  Future<T> call<T>(Future<T> future, T fallback) async {
    try {
      return await future;
    } catch (e, st) {
      // A failure of a watched provider may arrive wrapped by Riverpod.
      error ??= e is ProviderException ? e.exception : e;
      stack ??= st;
      return fallback;
    }
  }

  Never rethrowFirst() => Error.throwWithStackTrace(error!, stack ?? StackTrace.current);
}

/// Rows of the Crop Prices list. The forecasts are the backbone; the overview
/// view and recent history only refine them, so a failure of either is
/// tolerated as long as something can be shown.
final priceSummariesProvider = FutureProvider<List<PriceSummary>>((ref) async {
  final now = ref.watch(priceClockProvider)();
  final soft = _Soft();
  final forecastFuture = soft(ref.watch(priceForecastsProvider.future), const <PriceForecast>[]);
  final overviewFuture = soft(ref.watch(priceOverviewProvider.future), const <PriceOverview>[]);
  final historyFuture = soft(
    ref.watch(recentPriceHistoryProvider.future),
    const <String, List<PricePoint>>{},
  );

  final rows = buildPriceSummaries(
    forecasts: await forecastFuture,
    overview: await overviewFuture,
    history: await historyFuture,
    now: now,
  );
  if (rows.isEmpty && soft.error != null) soft.rethrowFirst();
  return rows;
});

/// History + forecast of one crop with the §13.6 rules applied. History is
/// optional: without it the chart shows the forecast only.
final priceSeriesProvider = FutureProvider.family<PriceSeries, String>((ref, crop) async {
  final key = cropKey(crop);
  final now = ref.watch(priceClockProvider)();
  final soft = _Soft();
  final forecastFuture = soft(ref.watch(priceForecastsProvider.future), const <PriceForecast>[]);
  final historyFuture = soft(ref.watch(priceHistoryProvider(key).future), const <PricePoint>[]);

  final series = PriceSeries(
    crop: key,
    forecast: await forecastFuture,
    history: await historyFuture,
    now: now,
  );
  if (series.isEmpty && soft.error != null) soft.rethrowFirst();
  return series;
});

/// Latest-version forecast rows of one crop, oldest first; empty while loading.
final cropForecastsProvider = Provider.family<List<PriceForecast>, String>((ref, crop) {
  final key = cropKey(crop);
  final all = ref.watch(priceForecastsProvider).value ?? const <PriceForecast>[];
  return all.where((f) => cropKey(f.cropName) == key).toList();
});

/// Reloads everything the price screens show (pull-to-refresh).
void refreshPrices(WidgetRef ref, {String? crop}) {
  ref.invalidate(priceOverviewProvider);
  ref.invalidate(priceForecastsProvider);
  ref.invalidate(recentPriceHistoryProvider);
  if (crop != null) ref.invalidate(priceHistoryProvider(cropKey(crop)));
}
