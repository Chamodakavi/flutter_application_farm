import '../../../core/config/constants.dart';
import '../../../core/utils/json_utils.dart';
import 'price_forecast.dart';
import 'price_overview.dart';

/// Crop names are compared in UPPERCASE exactly as stored (spec §13.6).
String cropKey(String name) => name.trim().toUpperCase();

/// First day of [d]'s month — prices are monthly.
DateTime monthOf(DateTime d) => DateTime(d.year, d.month);

DateTime addMonths(DateTime month, int count) => DateTime(month.year, month.month + count);

/// One point of a price line: an actual past price or a model forecast.
class PricePoint {
  const PricePoint(this.date, this.price, [this.isForecast = false]);

  /// A row of `crop_price_history` (`year`, `month`, `wholesale_price`).
  factory PricePoint.fromHistoryRow(Map<String, dynamic> row) =>
      PricePoint(DateTime(asInt(row['year']), asInt(row['month'])), asDouble(row['wholesale_price']));

  /// First day of the month the price belongs to.
  final DateTime date;
  final double price;
  final bool isForecast;

  @override
  bool operator ==(Object other) =>
      other is PricePoint &&
      other.date == date &&
      other.price == price &&
      other.isForecast == isForecast;

  @override
  int get hashCode => Object.hash(date, price, isForecast);

  @override
  String toString() => 'PricePoint($date, $price, forecast: $isForecast)';
}

/// Keeps, for every crop, only the rows of its newest `model_version`, so a
/// chart never mixes two model runs (spec §13.6). The newest version is the
/// one generated last; without dates the higher version text wins.
List<PriceForecast> latestModelVersion(Iterable<PriceForecast> rows) {
  final byCrop = <String, List<PriceForecast>>{};
  for (final row in rows) {
    byCrop.putIfAbsent(cropKey(row.cropName), () => []).add(row);
  }
  final result = <PriceForecast>[];
  for (final cropRows in byCrop.values) {
    final newestRun = <String, DateTime?>{};
    for (final row in cropRows) {
      final seen = newestRun[row.modelVersion];
      final at = row.generatedAt;
      newestRun[row.modelVersion] = (seen == null || (at != null && at.isAfter(seen))) ? at ?? seen : seen;
    }
    var winner = newestRun.keys.first;
    for (final version in newestRun.keys.skip(1)) {
      if (_isNewer(version, newestRun[version], winner, newestRun[winner])) winner = version;
    }
    result.addAll(cropRows.where((r) => r.modelVersion == winner));
  }
  result.sort(_byCropThenMonth);
  return result;
}

bool _isNewer(String version, DateTime? at, String otherVersion, DateTime? otherAt) {
  if (at != null && otherAt != null && !at.isAtSameMomentAs(otherAt)) return at.isAfter(otherAt);
  if (at != null && otherAt == null) return true;
  if (at == null && otherAt != null) return false;
  return _compareVersionText(version, otherVersion) > 0;
}

/// Natural order: `v10` sorts after `v9`, `2026-10` after `2026-9`.
int _compareVersionText(String a, String b) {
  final chunk = RegExp(r'\d+|\D+');
  final pa = chunk.allMatches(a).map((m) => m.group(0)!).toList();
  final pb = chunk.allMatches(b).map((m) => m.group(0)!).toList();
  for (var i = 0; i < pa.length && i < pb.length; i++) {
    final na = int.tryParse(pa[i]), nb = int.tryParse(pb[i]);
    final c = (na != null && nb != null) ? na.compareTo(nb) : pa[i].compareTo(pb[i]);
    if (c != 0) return c;
  }
  return pa.length.compareTo(pb.length);
}

int _byCropThenMonth(PriceForecast a, PriceForecast b) {
  final c = cropKey(a.cropName).compareTo(cropKey(b.cropName));
  return c != 0 ? c : a.harvestDate.compareTo(b.harvestDate);
}

/// Forecast row with the highest margin (`wholesale − cost`); ties go to the
/// earliest month (spec §13.6). Without any cost data the highest wholesale
/// price wins.
PriceForecast? bestHarvestMonth(Iterable<PriceForecast> rows) {
  final sorted = rows.toList()..sort((a, b) => a.harvestDate.compareTo(b.harvestDate));
  PriceForecast? best;
  for (final row in sorted) {
    final margin = row.marginPerKg;
    if (margin == null) continue;
    if (best == null || margin > best.marginPerKg!) best = row;
  }
  if (best != null) return best;
  for (final row in sorted) {
    if (best == null || row.wholesalePrice > best.wholesalePrice) best = row;
  }
  return best;
}

/// Everything the price screens need for one crop: past actual prices and the
/// newest model run, with the rules of spec §13.6 on top.
class PriceSeries {
  PriceSeries({
    required String crop,
    Iterable<PricePoint> history = const [],
    Iterable<PriceForecast> forecast = const [],
    DateTime? now,
  }) : crop = cropKey(crop),
       now = now ?? DateTime.now(),
       history = _cleanHistory(history),
       forecast = latestModelVersion(forecast.where((f) => cropKey(f.cropName) == cropKey(crop)));

  final String crop;
  final DateTime now;

  /// Actual wholesale prices, oldest first, one per month.
  final List<PricePoint> history;

  /// Rows of the newest model version only, oldest first.
  final List<PriceForecast> forecast;

  static List<PricePoint> _cleanHistory(Iterable<PricePoint> points) {
    final byMonth = <DateTime, PricePoint>{};
    for (final p in points) {
      byMonth[monthOf(p.date)] = PricePoint(monthOf(p.date), p.price);
    }
    return byMonth.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  DateTime get thisMonth => monthOf(now);

  PriceForecast? forecastFor(DateTime month) {
    for (final row in forecast) {
      if (row.isFor(month.year, month.month)) return row;
    }
    return null;
  }

  PricePoint? actualFor(DateTime month) {
    for (final p in history) {
      if (p.date.year == month.year && p.date.month == month.month) return p;
    }
    return null;
  }

  /// The forecast row for today's month, if the monthly job has produced it.
  PriceForecast? get current => forecastFor(thisMonth);

  /// True when [current] is missing and the price shown is the latest actual
  /// one — the UI adds a "Forecast pending" chip.
  bool get forecastPending => current == null;

  /// Latest actual price that is not in the future.
  PricePoint? get latestActual {
    for (final p in history.reversed) {
      if (!p.date.isAfter(thisMonth)) return p;
    }
    return null;
  }

  double? get currentPrice => current?.wholesalePrice ?? latestActual?.price;

  /// The month [currentPrice] belongs to.
  DateTime? get currentPriceMonth => current != null ? thisMonth : latestActual?.date;

  /// (this month − last month) ÷ last month, in percent. Last month comes
  /// from history when available, else from the forecast.
  double? get changePct {
    final price = currentPrice, month = currentPriceMonth;
    if (price == null || month == null) return null;
    return changeAgainstPrevious(price, month);
  }

  double? changeAgainstPrevious(double price, DateTime month) {
    final before = addMonths(monthOf(month), -1);
    final previous = actualFor(before)?.price ?? forecastFor(before)?.wholesalePrice;
    if (previous == null || previous == 0) return null;
    return (price - previous) / previous * 100;
  }

  /// Forecast rows from this month on — at most the next 12 months.
  List<PriceForecast> get upcoming =>
      forecast.where((f) => !f.harvestDate.isBefore(thisMonth)).take(12).toList();

  /// Best month to harvest within [upcoming].
  PriceForecast? get bestMonth => bestHarvestMonth(upcoming);

  /// Row used for cost / fair price / model details: this month's forecast,
  /// or the first upcoming one while the forecast is pending.
  PriceForecast? get reference => current ?? (upcoming.isEmpty ? null : upcoming.first);

  DateTime? get generatedAt {
    DateTime? latest;
    for (final row in forecast) {
      final at = row.generatedAt;
      if (at != null && (latest == null || at.isAfter(latest))) latest = at;
    }
    return latest;
  }

  String? get modelVersion => forecast.isEmpty ? null : forecast.first.modelVersion;

  bool get isStale => isForecastStale(generatedAt, now);

  bool get isEmpty => history.isEmpty && forecast.isEmpty;
}

/// A forecast older than [AppConst.forecastStaleAfter] gets an amber
/// "Forecast may be outdated" chip (spec §13.6).
bool isForecastStale(DateTime? generatedAt, DateTime now) =>
    generatedAt != null && now.difference(generatedAt) > AppConst.forecastStaleAfter;

/// One row of the Crop Prices list (spec §11.29).
class PriceSummary {
  const PriceSummary({
    required this.cropName,
    this.price,
    this.changePct,
    this.fairPrice,
    this.costPerKg,
    this.retailPrice,
    this.sparkline = const [],
    this.forecastPending = false,
    this.generatedAt,
  });

  final String cropName;

  /// This month's wholesale price per kg (latest actual price while pending).
  final double? price;
  final double? changePct;
  final double? fairPrice;
  final double? costPerKg;
  final double? retailPrice;

  /// Forecast wholesale price for the next six months.
  final List<double> sparkline;
  final bool forecastPending;
  final DateTime? generatedAt;

  double? get marginPerKg => (price == null || costPerKg == null) ? null : price! - costPerKg!;

  /// Null when there is no fair price for the same row to compare against.
  bool? get aboveFair =>
      (forecastPending || price == null || fairPrice == null) ? null : price! >= fairPrice!;
}

/// Joins the overview view, the forecasts and recent history into list rows,
/// one per crop, A–Z. The overview row wins when it has a price; otherwise the
/// forecast row for this month; otherwise the latest actual price, flagged
/// as pending.
List<PriceSummary> buildPriceSummaries({
  Iterable<PriceOverview> overview = const [],
  Iterable<PriceForecast> forecasts = const [],
  Map<String, List<PricePoint>> history = const {},
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final overviewByCrop = {for (final o in overview) cropKey(o.cropName): o};
  final forecastByCrop = <String, List<PriceForecast>>{};
  for (final f in forecasts) {
    forecastByCrop.putIfAbsent(cropKey(f.cropName), () => []).add(f);
  }
  final historyByCrop = {for (final e in history.entries) cropKey(e.key): e.value};
  final crops = {...overviewByCrop.keys, ...forecastByCrop.keys, ...historyByCrop.keys}.toList()
    ..sort();

  final rows = <PriceSummary>[];
  for (final crop in crops) {
    final series = PriceSeries(
      crop: crop,
      history: historyByCrop[crop] ?? const [],
      forecast: forecastByCrop[crop] ?? const [],
      now: today,
    );
    final view = overviewByCrop[crop];
    final current = series.current;
    final sparkline = series.upcoming.take(6).map((f) => f.wholesalePrice).toList();

    if (view?.wholesalePrice != null) {
      rows.add(
        PriceSummary(
          cropName: crop,
          price: view!.wholesalePrice,
          changePct:
              view.change ?? series.changeAgainstPrevious(view.wholesalePrice!, series.thisMonth),
          fairPrice: view.fairPrice ?? current?.fairPrice,
          costPerKg: view.costPerKg ?? current?.costPerKg,
          retailPrice: view.retailPrice ?? current?.retailPrice,
          sparkline: sparkline,
          generatedAt: view.generatedAt ?? series.generatedAt,
        ),
      );
    } else if (series.currentPrice != null || sparkline.isNotEmpty) {
      rows.add(
        PriceSummary(
          cropName: crop,
          price: series.currentPrice,
          changePct: series.changePct,
          fairPrice: current?.fairPrice,
          costPerKg: current?.costPerKg,
          retailPrice: current?.retailPrice,
          sparkline: sparkline,
          forecastPending: series.forecastPending,
          generatedAt: series.generatedAt,
        ),
      );
    }
  }
  return rows;
}
