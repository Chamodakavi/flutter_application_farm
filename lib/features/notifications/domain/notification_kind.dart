import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// What a broadcast is about, guessed from its words — it picks the inbox
/// icon (spec §11.24). `notifications` has no type column.
enum NotificationKind {
  alert(Icons.warning_amber_rounded, AppColors.orange600),
  weather(Icons.cloud_outlined, AppColors.blue600),
  market(Icons.trending_up_rounded, AppColors.green600),
  order(Icons.local_shipping_outlined, AppColors.forest800),
  general(Icons.notifications_none_rounded, AppColors.ink500);

  const NotificationKind(this.icon, this.color);

  final IconData icon;
  final Color color;

  // Whole English words, plus the usual Sinhala and Tamil terms: admins write
  // broadcasts in any of the three languages.
  static final _alert = RegExp(
    r'\b(alerts?|warnings?|urgent|danger|surplus)\b|අනතුරු|අවවාද|හදිසි|எச்சரிக்கை|அவசர',
  );
  static final _weather = RegExp(
    r'\b(weather|rain(s|y|fall)?|storms?|floods?|drought|cyclone|wind(s|y)?)\b'
    r'|කාලගුණ|වැසි|වර්ෂා|ගංවතුර|නියඟ|வானிலை|மழை|வெள்ள|வறட்சி|புயல்',
  );
  static final _market = RegExp(
    r'\b(market(s|place)?|prices?|wholesale|retail)\b|වෙළඳ|මිල|சந்தை|விலை',
  );
  static final _order = RegExp(
    r'\b(orders?|ordered|deliver(y|ies|ed)|shipp(ed|ing)|shipment)\b|ඇණවුම|බෙදාහැරීම|ஆர்டர்|விநியோக',
  );

  /// The first match wins, most urgent first: a "price alert" is an alert.
  static NotificationKind of(String? title, String? message) {
    final text = '${title ?? ''} ${message ?? ''}'.toLowerCase();
    if (_alert.hasMatch(text)) return alert;
    if (_weather.hasMatch(text)) return weather;
    if (_market.hasMatch(text)) return market;
    if (_order.hasMatch(text)) return order;
    return general;
  }
}
