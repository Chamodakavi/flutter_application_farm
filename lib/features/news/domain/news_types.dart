import 'news.dart';

String _norm(String? type) => type?.trim().toLowerCase() ?? '';

/// Distinct `n_type` values of [items] in first-seen order — the filter chips
/// after "All" (spec §11.18). Casing and stray spaces are ignored, so
/// `Alert` and `alert ` give one chip.
List<String> newsTypesOf(Iterable<News> items) {
  final seen = <String>{};
  final types = <String>[];
  for (final item in items) {
    final key = _norm(item.type);
    if (key.isEmpty || !seen.add(key)) continue;
    types.add(item.type!.trim());
  }
  return types;
}

/// [items] of the given [type]; null or blank means "All".
List<News> filterNewsByType(List<News> items, String? type) {
  final key = _norm(type);
  if (key.isEmpty) return items;
  return items.where((n) => _norm(n.type) == key).toList();
}
