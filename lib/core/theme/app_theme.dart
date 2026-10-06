import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Material 3 theme with the overrides from spec §10.4.
abstract final class AppTheme {
  static ThemeData light(Locale locale) {
    final text = AppTypography.forLocale(locale);
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.green600,
      primary: AppColors.green600,
      onPrimary: AppColors.white,
      secondary: AppColors.amber200,
      onSecondary: AppColors.forest900,
      error: AppColors.red600,
      surface: AppColors.white,
      onSurface: AppColors.ink900,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.mint50,
      fontFamily: AppTypography.familyFor(locale),
      fontFamilyFallback: AppTypography.fallbackFor(locale),
      textTheme: text,
      dividerColor: AppColors.line200,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.forest900,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: text.titleMedium?.copyWith(color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardBorder,
          side: const BorderSide(color: AppColors.line200),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green600,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.line200,
          disabledForegroundColor: AppColors.ink500,
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonBorder),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.forest900,
          minimumSize: const Size(64, AppSpacing.minTap),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          side: const BorderSide(color: AppColors.forest900),
          shape: const StadiumBorder(),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.green600,
          minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
          textStyle: text.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTap, AppSpacing.minTap),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
        hintStyle: text.bodyLarge?.copyWith(color: AppColors.ink500),
        errorMaxLines: 3,
        helperMaxLines: 3,
        border: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: const BorderSide(color: AppColors.green600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: const BorderSide(color: AppColors.red600),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadii.inputBorder,
          borderSide: const BorderSide(color: AppColors.red600, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.forest900,
        indicatorColor: AppColors.forest800,
        surfaceTintColor: Colors.transparent,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? AppColors.white : Colors.white70,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelSmall?.copyWith(
            fontSize: 11,
            height: 1.2,
            color: states.contains(WidgetState.selected) ? AppColors.white : Colors.white70,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.green600,
        checkmarkColor: AppColors.white,
        side: const BorderSide(color: AppColors.line200),
        shape: const StadiumBorder(),
        labelStyle: text.labelSmall,
        secondaryLabelStyle: text.labelSmall?.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.forest900,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.white),
        actionTextColor: AppColors.amber200,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.inputBorder),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.sheetBorder),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardBorder),
        titleTextStyle: text.titleMedium,
        contentTextStyle: text.bodyMedium,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.forest900,
        minVerticalPadding: AppSpacing.md,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.green600 : AppColors.line200,
        ),
        thumbColor: const WidgetStatePropertyAll(AppColors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green600,
        linearTrackColor: AppColors.line200,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.green600,
        foregroundColor: AppColors.white,
        shape: CircleBorder(),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.forest900,
        unselectedLabelColor: AppColors.ink500,
        indicatorColor: AppColors.green600,
        labelStyle: text.labelMedium,
        unselectedLabelStyle: text.labelMedium,
      ),
    );
  }
}
