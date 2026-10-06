import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One of the 25 districts with its approximate centroid (spec §15).
class District {
  const District({
    required this.key,
    required this.si,
    required this.ta,
    required this.lat,
    required this.lon,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    key: json['key'] as String,
    si: json['si'] as String,
    ta: json['ta'] as String,
    lat: (json['lat'] as num).toDouble(),
    lon: (json['lon'] as num).toDouble(),
  );

  /// English name — the value stored in `users.u_district`.
  final String key;
  final String si;
  final String ta;
  final double lat;
  final double lon;

  String label(String languageCode) => switch (languageCode) {
    'si' => si,
    'ta' => ta,
    _ => key,
  };
}

abstract final class Districts {
  static List<District> _all = const [];

  /// Used for weather when the profile has no district yet.
  static const fallback = District(
    key: 'Colombo',
    si: 'කොළඹ',
    ta: 'கொழும்பு',
    lat: 6.93,
    lon: 79.86,
  );

  /// Loads `assets/data/districts.json`; called once from bootstrap.
  static Future<void> load([AssetBundle? bundle]) async {
    final raw = await (bundle ?? rootBundle).loadString('assets/data/districts.json');
    loadFromJson(jsonDecode(raw) as List<dynamic>);
  }

  static void loadFromJson(List<dynamic> json) {
    _all = json.map((e) => District.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  static List<District> get all => _all;

  static District? byKey(String? key) {
    if (key == null) return null;
    final k = key.trim().toLowerCase();
    for (final d in _all) {
      if (d.key.toLowerCase() == k) return d;
    }
    return null;
  }

  /// Localized name for a stored `u_district` value; unknown values pass through.
  static String label(BuildContext context, String? key) {
    if (key == null || key.isEmpty) return '';
    return byKey(key)?.label(Localizations.localeOf(context).languageCode) ?? key;
  }
}
