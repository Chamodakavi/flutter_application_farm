import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../utils/formatters.dart';

/// Localizes crop names. The database stores UPPERCASE English keys exactly as
/// the ML model's label encoder spells them (`DRUMSTIC`, `RADDISH` — spec
/// §16.3); this maps them to display labels without touching the keys.
abstract final class CropLabels {
  static Map<String, Map<String, String>> _data = const {};

  static const _emoji = {
    'plantain': '🍌',
    'beans': '🌱',
    'beetroot': '🍠',
    'gourd': '🥒',
    'brinjal': '🍆',
    'cabbage': '🥬',
    'capsicum': '🌶️',
    'carrot': '🥕',
    'cucumber': '🥒',
    'drumstick': '🌿',
    'leeks': '🌿',
    'radish': '🌱',
    'tomato': '🍅',
  };

  /// Loads `assets/data/crops_i18n.json`; called once from bootstrap.
  static Future<void> load([AssetBundle? bundle]) async {
    final raw = await (bundle ?? rootBundle).loadString('assets/data/crops_i18n.json');
    loadFromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static void loadFromJson(Map<String, dynamic> json) {
    _data = json.map(
      (k, v) => MapEntry(k.toUpperCase(), Map<String, String>.from(v as Map)),
    );
  }

  /// Label for [dbName] in the current app language.
  static String of(BuildContext context, String dbName) =>
      forLocale(Localizations.localeOf(context).languageCode, dbName);

  static String forLocale(String languageCode, String dbName) {
    final entry = _data[dbName.trim().toUpperCase()];
    return entry?[languageCode] ?? entry?['en'] ?? Fmt.titleCase(dbName);
  }

  /// English display name with corrected spelling (`DRUMSTIC` → `Drumstick`).
  static String english(String dbName) => forLocale('en', dbName);

  /// Emoji used as the crop icon.
  static String emoji(String dbName) =>
      _emoji[_data[dbName.trim().toUpperCase()]?['icon']] ?? '🌱';

  /// Crop keys known to the model, in alphabetical order.
  static List<String> get knownCrops => _data.keys.toList()..sort();

  /// True when [query] matches the crop in any language.
  static bool matches(String dbName, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final entry = _data[dbName.trim().toUpperCase()];
    return dbName.toLowerCase().contains(q) ||
        (entry?.values.any((v) => v.toLowerCase().contains(q)) ?? false);
  }
}
