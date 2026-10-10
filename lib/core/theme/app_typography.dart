import 'package:flutter/painting.dart';

import '../responsive/responsive_value.dart';
import 'app_colors.dart';

/// Font family names (declared in pubspec.yaml).
abstract final class AppFonts {
  static const String sans = 'Geist';
  static const String mono = 'GeistMono';
  static const String arabic = 'NotoSansArabic';
  static const List<String> fallback = [arabic];
}

/// Letter spacing in `em` units converted to logical pixels.
double em(double size, double em) => size * em;

/// Fixed (non-fluid) text styles, usable in `const` widgets.
abstract final class AppTextStyles {
  static const TextStyle statValue = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 44,
    fontWeight: FontWeight.w700,
    letterSpacing: 44 * -0.04,
    height: 1.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: 26 * -0.02,
    color: AppColors.textPrimary,
  );

  static const TextStyle tileTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 20 * -0.01,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 15,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onAccent,
  );

  static const TextStyle nav = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  /// Nav row text in the compact (mobile) menu panel.
  static const TextStyle navLarge = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle brand = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Eyebrow label. Uppercase is applied by the widget (`toUpperCase()`),
  /// not by the style.
  static const TextStyle eyebrow = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 12 * 0.14,
    color: AppColors.cyan400,
  );

  /// Role and dates in a timeline card header (the prototype's `.mono` 12px).
  static const TextStyle timelineMeta = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  /// Copyright/build line in the footer.
  static const TextStyle footerMono = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle tag = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle tagLarge = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Label under a stat value (14px, default line height).
  static const TextStyle statLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Subtitle under a skill category title (colour applied per tone).
  static const TextStyle skillSubtitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Skill pill label.
  static const TextStyle skillPill = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textEmphasis,
  );

  /// Project name on the app-icon card.
  static const TextStyle projectTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 22 * -0.02,
    color: AppColors.textPrimary,
  );

  /// App name in a showcase tile.
  static const TextStyle showcaseName = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Phone number link in the contact panel.
  static const TextStyle phoneLink = TextStyle(
    fontFamily: AppFonts.mono,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  /// Native-script project name under the card title.
  static const TextStyle nativeName = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  static const TextStyle segment = TextStyle(
    fontFamily: AppFonts.sans,
    fontFamilyFallback: AppFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}

/// Fluid size tokens (mirroring CSS `clamp()`).
abstract final class AppFluid {
  static const FluidValue display = FluidValue(46, 92, 0.09);
  static const FluidValue lead = FluidValue(17, 21, 0.024);
  static const FluidValue sectionTitle = FluidValue(30, 44, 0.045);
  static const FluidValue ecosystemTitle = FluidValue(28, 40, 0.04);
  static const FluidValue ctaTitle = FluidValue(30, 52, 0.05);
}

/// All text styles resolved for a given viewport width.
class AppTypography {
  const AppTypography({
    required this.display,
    required this.lead,
    required this.sectionTitle,
    required this.ecosystemTitle,
    required this.ctaTitle,
  });

  factory AppTypography.of(double viewportWidth) {
    final displaySize = AppFluid.display.resolve(viewportWidth);
    final leadSize = AppFluid.lead.resolve(viewportWidth);
    final sectionSize = AppFluid.sectionTitle.resolve(viewportWidth);
    final ecosystemSize = AppFluid.ecosystemTitle.resolve(viewportWidth);
    final ctaSize = AppFluid.ctaTitle.resolve(viewportWidth);

    return AppTypography(
      display: TextStyle(
        fontFamily: AppFonts.sans,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: displaySize,
        fontWeight: FontWeight.w700,
        letterSpacing: em(displaySize, -0.045),
        height: 1.02,
        color: AppColors.textPrimary,
      ),
      lead: TextStyle(
        fontFamily: AppFonts.sans,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: leadSize,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: AppColors.textSecondary,
      ),
      sectionTitle: TextStyle(
        fontFamily: AppFonts.sans,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: sectionSize,
        fontWeight: FontWeight.w600,
        letterSpacing: em(sectionSize, -0.03),
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      ecosystemTitle: TextStyle(
        fontFamily: AppFonts.sans,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: ecosystemSize,
        fontWeight: FontWeight.w600,
        letterSpacing: em(ecosystemSize, -0.03),
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      ctaTitle: TextStyle(
        fontFamily: AppFonts.sans,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: ctaSize,
        fontWeight: FontWeight.w600,
        letterSpacing: em(ctaSize, -0.035),
        height: 1.08,
        color: AppColors.textPrimary,
      ),
    );
  }

  final TextStyle display;
  final TextStyle lead;
  final TextStyle sectionTitle;
  final TextStyle ecosystemTitle;
  final TextStyle ctaTitle;

  // Fixed styles, mirrored for convenience.
  TextStyle get statValue => AppTextStyles.statValue;
  TextStyle get cardTitle => AppTextStyles.cardTitle;
  TextStyle get tileTitle => AppTextStyles.tileTitle;
  TextStyle get body => AppTextStyles.body;
  TextStyle get caption => AppTextStyles.caption;
  TextStyle get button => AppTextStyles.button;
  TextStyle get buttonPrimary => AppTextStyles.buttonPrimary;
  TextStyle get nav => AppTextStyles.nav;
  TextStyle get navLarge => AppTextStyles.navLarge;
  TextStyle get brand => AppTextStyles.brand;
  TextStyle get eyebrow => AppTextStyles.eyebrow;
  TextStyle get tag => AppTextStyles.tag;
  TextStyle get tagLarge => AppTextStyles.tagLarge;
  TextStyle get statLabel => AppTextStyles.statLabel;
  TextStyle get chip => AppTextStyles.chip;
  TextStyle get segment => AppTextStyles.segment;
}
