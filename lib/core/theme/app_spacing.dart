import 'package:flutter/widgets.dart';

/// Spacing scale: 4, 8, 12, 16, 20, 24, 32 (spec §10.3).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Default page gutter.
  static const page = EdgeInsets.all(lg);

  /// Minimum tap target (spec §1.3).
  static const double minTap = 48;

  /// Height of full-width primary buttons.
  static const double buttonHeight = 54;

  static const gapXs = SizedBox(width: xs, height: xs);
  static const gapSm = SizedBox(width: sm, height: sm);
  static const gapMd = SizedBox(width: md, height: md);
  static const gapLg = SizedBox(width: lg, height: lg);
  static const gapXl = SizedBox(width: xl, height: xl);
  static const gapXxl = SizedBox(width: xxl, height: xxl);
}
