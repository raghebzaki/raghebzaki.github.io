import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.cyan400,
      onPrimary: AppColors.onAccent,
      secondary: AppColors.blue500,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
      outlineVariant: AppColors.borderSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      fontFamily: AppFonts.sans,
      fontFamilyFallback: AppFonts.fallback,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.cardTitle,
        displayMedium: AppTextStyles.cardTitle,
        displaySmall: AppTextStyles.cardTitle,
        headlineLarge: AppTextStyles.cardTitle,
        headlineMedium: AppTextStyles.tileTitle,
        headlineSmall: AppTextStyles.tileTitle,
        titleLarge: AppTextStyles.cardTitle,
        titleMedium: AppTextStyles.tileTitle,
        titleSmall: AppTextStyles.brand,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.segment,
        labelSmall: AppTextStyles.tag,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: AppColors.cyan400.withValues(alpha: 0.35),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.cyan400,
        selectionColor: AppColors.cyan400.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.cyan400,
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(AppColors.borderStrong),
        thickness: WidgetStatePropertyAll(6),
        radius: Radius.circular(3),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        textStyle: AppTextStyles.caption,
      ),
      dividerColor: AppColors.borderSubtle,
      visualDensity: VisualDensity.standard,
    );
  }
}
