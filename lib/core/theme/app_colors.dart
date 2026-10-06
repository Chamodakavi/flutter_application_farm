import 'package:flutter/material.dart';

/// Colour tokens derived from the deployed web UI (spec §10.1).
abstract final class AppColors {
  static const forest900 = Color(0xFF0E2A1C);
  static const forest800 = Color(0xFF173D29);
  static const green600 = Color(0xFF16A34A);
  static const green500 = Color(0xFF22C55E);
  static const green100 = Color(0xFFDCFCE7);
  static const mint50 = Color(0xFFD9F2C7);
  static const cream50 = Color(0xFFFDF6E7);
  static const amber200 = Color(0xFFFCD891);
  static const weatherTint = Color(0xFFFEF3E2);
  static const orange500 = Color(0xFFF59E0B);
  static const orange600 = Color(0xFFEA580C);
  static const red600 = Color(0xFFDC2626);
  static const red100 = Color(0xFFFEE2E2);
  static const blue600 = Color(0xFF2563EB);
  static const blue100 = Color(0xFFDBEAFE);
  static const ink900 = Color(0xFF111827);
  static const ink500 = Color(0xFF6B7280);
  static const line200 = Color(0xFFE5E7EB);
  static const fieldFill = Color(0xFFF7F7F5);
  static const white = Color(0xFFFFFFFF);

  // Surplus levels (spec §10.1 / §13.2).
  static const surplusLow = green600;
  static const surplusMedium = orange500;
  static const surplusHigh = orange600;
  static const surplusFull = red600;
}
