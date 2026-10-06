import 'package:intl/intl.dart';

/// Locale-aware formatting for money, amounts and dates (spec §13.5).
///
/// Numbers always use Latin digits and `1,234.50` grouping so prices read the
/// same in every language; only month and day names follow the app locale.
abstract final class Fmt {
  static final _money = NumberFormat('#,##0.00', 'en_US');
  static final _whole = NumberFormat('#,##0', 'en_US');
  static final _amount = NumberFormat('#,##0.##', 'en_US');
  static final _oneDecimal = NumberFormat('#,##0.#', 'en_US');

  /// `Rs. 1,130.00` — product cards and prices.
  static String rs(num? value) => value == null ? '—' : 'Rs. ${_money.format(value)}';

  /// `Rs. 1,130` — large totals where cents add noise (planner).
  static String rsWhole(num? value) => value == null ? '—' : 'Rs. ${_whole.format(value)}';

  /// `LKR 1,130` — orders (matches web).
  static String lkr(num? value) => value == null ? '—' : 'LKR ${_amount.format(value)}';

  /// `Rs. 245/kg` — crop prices.
  static String perKg(num? value) => value == null ? '—' : 'Rs. ${_amount.format(value)}/kg';

  /// `66` / `66.25` — up to two decimals, no unit.
  static String amount(num? value) => value == null ? '—' : _amount.format(value);

  /// `66 MT`.
  static String mt(num? value) => value == null ? '—' : '${_amount.format(value)} MT';

  /// `8.2%` (always positive; the caller adds ▲/▼).
  static String percent(num? value) =>
      value == null ? '—' : '${_oneDecimal.format(value.abs())}%';

  /// `5 Oct 2026` in the given locale.
  static String date(DateTime? d, String locale) =>
      d == null ? '—' : DateFormat('d MMM yyyy', locale).format(d.toLocal());

  /// `9:41 AM`.
  static String time(DateTime? d, String locale) =>
      d == null ? '—' : DateFormat.jm(locale).format(d.toLocal());

  /// `5 Oct 2026, 9:41 AM`.
  static String dateTime(DateTime? d, String locale) =>
      d == null ? '—' : '${date(d, locale)}, ${time(d, locale)}';

  /// `March 2027`.
  static String monthYear(DateTime? d, String locale) =>
      d == null ? '—' : DateFormat('MMMM yyyy', locale).format(d);

  /// `Mar 27` — chart axes and chips.
  static String monthShort(DateTime? d, String locale) =>
      d == null ? '—' : DateFormat('MMM yy', locale).format(d);

  /// `March`.
  static String monthName(DateTime? d, String locale) =>
      d == null ? '—' : DateFormat('MMMM', locale).format(d);

  /// `CARROT` → `Carrot`, `ASH PLANTAINS` → `Ash Plantains`.
  static String titleCase(String s) => s
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  /// Rounds to [places] decimals without floating-point tails.
  static double round(double value, [int places = 2]) =>
      double.parse(value.toStringAsFixed(places));
}
