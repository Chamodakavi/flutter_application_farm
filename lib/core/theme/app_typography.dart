import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Locale-aware type scale (spec §10.2).
///
/// Sinhala and Tamil glyphs are taller than Latin ones, so those locales get a
/// larger line height and fall back to Noto Sans for Latin characters.
abstract final class AppTypography {
  static const latin = 'NotoSans';
  static const sinhala = 'NotoSansSinhala';
  static const tamil = 'NotoSansTamil';

  static String familyFor(Locale locale) => switch (locale.languageCode) {
    'si' => sinhala,
    'ta' => tamil,
    _ => latin,
  };

  /// Every script is listed so user content in another language still renders.
  static List<String> fallbackFor(Locale locale) => switch (locale.languageCode) {
    'si' => const [latin, tamil],
    'ta' => const [latin, sinhala],
    _ => const [sinhala, tamil],
  };

  static double lineHeightFor(Locale locale) => switch (locale.languageCode) {
    'si' => 1.45,
    'ta' => 1.4,
    _ => 1.3,
  };

  static TextTheme forLocale(Locale locale) {
    final family = familyFor(locale);
    final fallback = fallbackFor(locale);
    final height = lineHeightFor(locale);

    TextStyle style(double size, FontWeight weight, {Color color = AppColors.ink900}) =>
        TextStyle(
          fontFamily: family,
          fontFamilyFallback: fallback,
          fontSize: size,
          fontWeight: weight,
          height: height,
          color: color,
        );

    return TextTheme(
      displaySmall: style(24, FontWeight.w700),
      headlineSmall: style(22, FontWeight.w700),
      titleLarge: style(22, FontWeight.w700),
      titleMedium: style(17, FontWeight.w600),
      titleSmall: style(15, FontWeight.w600),
      bodyLarge: style(16, FontWeight.w400),
      bodyMedium: style(14, FontWeight.w400),
      bodySmall: style(12, FontWeight.w400, color: AppColors.ink500),
      labelLarge: style(16, FontWeight.w600),
      labelMedium: style(13, FontWeight.w600),
      labelSmall: style(12, FontWeight.w600),
    );
  }
}
