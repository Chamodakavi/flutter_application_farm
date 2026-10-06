import 'package:intl/intl.dart';

import '../../../core/config/constants.dart';
import '../../../core/utils/formatters.dart';
import 'bucket_status.dart';
import 'register_result.dart';

/// Surplus colour thresholds, tunable from `app_config` (spec §13.2).
class SurplusThresholds {
  const SurplusThresholds({
    this.medium = AppConst.surplusMediumRatio,
    this.high = AppConst.surplusHighRatio,
  });

  final double medium;
  final double high;

  bool get isValid => medium > 0 && high > medium && high <= 1;

  /// Level with the configured thresholds; a broken config falls back to the
  /// built-in [BucketStatus.level].
  SurplusLevel levelOf(BucketStatus bucket) => isValid
      ? SurplusLevel.fromRatio(bucket.fillRatio, medium: medium, high: high)
      : bucket.level;

  SurplusLevel levelOfRatio(double ratio) => isValid
      ? SurplusLevel.fromRatio(ratio, medium: medium, high: high)
      : SurplusLevel.fromRatio(ratio);
}

/// A date read from a free-text column (`target_harvest_date`, `planting_date`).
class LooseDate {
  const LooseDate(this.date, {this.monthOnly = false});

  final DateTime date;

  /// The text only named a month ("March 2027", "2027-03").
  final bool monthOnly;

  static final _yearMonth = RegExp(r'^(\d{4})[-/.](\d{1,2})$');
  static final _monthYear = RegExp(r'^(\d{1,2})[-/.](\d{4})$');
  static final _dayMonthYear = RegExp(r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})$');
  static const _fullPatterns = ['d MMM yyyy', 'd MMMM yyyy', 'MMM d, yyyy', 'MMMM d, yyyy'];
  static const _monthPatterns = ['MMMM yyyy', 'MMM yyyy'];

  /// Null when [raw] is empty or not a recognisable date.
  static LooseDate? tryParse(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;

    var m = _yearMonth.firstMatch(text);
    if (m != null) return _month(int.parse(m[1]!), int.parse(m[2]!));
    m = _monthYear.firstMatch(text);
    if (m != null) return _month(int.parse(m[2]!), int.parse(m[1]!));
    m = _dayMonthYear.firstMatch(text);
    if (m != null) return _day(int.parse(m[3]!), int.parse(m[2]!), int.parse(m[1]!));

    if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(text)) {
      final iso = DateTime.tryParse(text);
      if (iso != null) return LooseDate(DateTime(iso.year, iso.month, iso.day));
    }
    for (final pattern in _fullPatterns) {
      final d = _tryFormat(pattern, text);
      if (d != null) return LooseDate(d);
    }
    for (final pattern in _monthPatterns) {
      final d = _tryFormat(pattern, text);
      if (d != null) return LooseDate(d, monthOnly: true);
    }
    return null;
  }

  static LooseDate? _month(int year, int month) =>
      (month < 1 || month > 12) ? null : LooseDate(DateTime(year, month), monthOnly: true);

  static LooseDate? _day(int year, int month, int day) =>
      (month < 1 || month > 12 || day < 1 || day > 31) ? null : LooseDate(DateTime(year, month, day));

  static DateTime? _tryFormat(String pattern, String text) {
    try {
      return DateFormat(pattern, 'en_US').parseStrict(text);
    } on FormatException {
      return null;
    }
  }

  String format(String locale) => monthOnly ? Fmt.monthYear(date, locale) : Fmt.date(date, locale);
}

/// A formatted date when [raw] is parseable, else the raw text; null when the
/// column is empty.
String? formatLooseDate(String? raw, String locale) {
  final text = raw?.trim() ?? '';
  if (text.isEmpty) return null;
  return LooseDate.tryParse(text)?.format(locale) ?? text;
}

extension BucketStatusRules on BucketStatus {
  /// UPPERCASE database key, for joins with forecasts and registrations.
  String get key => cropName.trim().toUpperCase();

  /// The month this quota is meant to be harvested in: `year`/`month` from the
  /// RPC, else whatever `target_harvest_date` parses to.
  DateTime? get targetMonth {
    if (harvestMonth != null) return harvestMonth;
    final parsed = LooseDate.tryParse(harvestDate)?.date;
    return parsed == null ? null : DateTime(parsed.year, parsed.month);
  }

  /// Target harvest date for display: formatted when the free-text column is
  /// parseable, else the raw text, else the target month.
  String? harvestLabel(String locale) =>
      formatLooseDate(harvestDate, locale) ??
      (harvestMonth == null ? null : Fmt.monthYear(harvestMonth, locale));

  String? plantingLabel(String locale) => formatLooseDate(plantingDate, locale);

  /// Remaining quota, never negative.
  double get roomMt => remainingMt < 0 ? 0 : remainingMt;
}

/// Finds a crop in the bucket by its database key, ignoring case.
BucketStatus? bucketFor(Iterable<BucketStatus> buckets, String? cropName) {
  if (cropName == null) return null;
  final key = cropName.trim().toUpperCase();
  for (final b in buckets) {
    if (b.key == key) return b;
  }
  return null;
}

/// Crop picker order: crops with room first (most room on top), full crops
/// last (spec §13.2).
List<BucketStatus> sortForPicker(Iterable<BucketStatus> buckets) {
  final list = buckets.toList();
  list.sort((a, b) {
    if (a.isFull != b.isFull) return a.isFull ? 1 : -1;
    final byRoom = b.remainingMt.compareTo(a.remainingMt);
    return byRoom != 0 ? byRoom : a.cropName.compareTo(b.cropName);
  });
  return list;
}

/// The instant check against the cached bucket (spec §13.2): null when the
/// amount fits or the crop is not cached, else a warning built from the cache
/// with up to three local suggestions. The RPC result always replaces it.
RegisterSurplus? preCheckSurplus(Iterable<BucketStatus> buckets, String cropName, double amountMt) {
  final bucket = bucketFor(buckets, cropName);
  if (bucket == null || bucket.fits(amountMt)) return null;
  final others = sortForPicker(buckets.where((b) => b.key != bucket.key && b.remainingMt > 0));
  final roomy = others.where((b) => b.fits(amountMt)).toList();
  return RegisterSurplus(
    cropName: bucket.cropName,
    limitMt: bucket.limitMt,
    filledMt: bucket.filledMt,
    remainingMt: bucket.remainingMt < 0 ? 0 : bucket.remainingMt,
    alternatives: [
      for (final b in (roomy.isNotEmpty ? roomy : others).take(3))
        AlternativeCrop(cropName: b.cropName, remainingMt: b.remainingMt, fairPrice: b.fairPrice),
    ],
  );
}

/// Largest amount with two decimals that still fits in [remainingMt].
double registrableRemainder(double remainingMt) =>
    remainingMt <= 0 ? 0 : (remainingMt * 100 + 1e-6).floorToDouble() / 100;

/// `12`, `12.5`, `12.25` — the text put into the amount field.
String amountFieldText(double value) {
  final rounded = Fmt.round(value, 2);
  return rounded == rounded.roundToDouble() ? rounded.toInt().toString() : rounded.toString();
}

/// Filter chips of Crop Outlook (spec §11.12).
enum OutlookFilter {
  all,
  available,
  almostFull,
  full;

  bool matches(SurplusLevel level) => switch (this) {
    all => true,
    available => level == SurplusLevel.low || level == SurplusLevel.medium,
    almostFull => level == SurplusLevel.high,
    full => level == SurplusLevel.full,
  };
}

enum OutlookSort { mostRoom, highestPrice, name }
