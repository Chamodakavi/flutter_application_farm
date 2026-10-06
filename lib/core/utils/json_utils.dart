/// Tolerant JSON readers. Several columns are `varchar`/`numeric` in Postgres
/// (e.g. `products.stock`, `cart.product_id`), so values may arrive as strings.
double asDouble(Object? v) => asDoubleOrNull(v) ?? 0;

double? asDoubleOrNull(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString().trim());
}

int asInt(Object? v) => asIntOrNull(v) ?? 0;

int? asIntOrNull(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toInt();
  final s = v.toString().trim();
  return int.tryParse(s) ?? double.tryParse(s)?.toInt();
}

String? asStringOrNull(Object? v) => v?.toString();

String asString(Object? v) => v?.toString() ?? '';

bool asBool(Object? v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v?.toString().toLowerCase();
  return s == 'true' || s == 't' || s == '1';
}

DateTime? asDateOrNull(Object? v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

/// Postgres `_varchar` arrives as a JSON list; tolerate null and `{a,b}` text.
List<String> asStringList(Object? v) {
  if (v is List) return v.where((e) => e != null).map((e) => e.toString()).toList();
  if (v is String && v.startsWith('{') && v.endsWith('}')) {
    final inner = v.substring(1, v.length - 1);
    if (inner.isEmpty) return const [];
    return inner.split(',').map((e) => e.replaceAll('"', '').trim()).toList();
  }
  return const [];
}

/// Rows from PostgREST as typed maps.
List<Map<String, dynamic>> asRows(Object? v) {
  if (v is! List) return const [];
  return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
}
