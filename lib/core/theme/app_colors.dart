import 'package:flutter/painting.dart';

import 'css_gradient.dart';

/// Design tokens: colors. Names mirror the approved design spec.
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFF0B0F19);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceGradientEnd = Color(0xFF12171F);
  static const Color surfaceRaised = Color(0xFF111621);
  static const Color surfaceInset = Color(0xFF0D1117);
  static const Color surfaceHover = Color(0xFF1B2230);
  static const Color segmentActive = Color(0xFF1F2937);

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textEmphasis = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF64748B);

  /// Tile behind company logos (they are drawn on white).
  static const Color logoTile = Color(0xFFFFFFFF);
  static const Color textBright = Color(0xFFFFFFFF);
  static const Color onAccent = Color(0xFF04101A);

  // Borders (rgba values pre-computed to ARGB)
  static const Color borderSubtle = Color(0xCC1E293B);
  static const Color border = Color(0xCC334155);
  static const Color borderTag = Color(0xB3334155);
  static const Color borderStrong = Color(0xE6334155);

  // Accents
  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color cyan300 = Color(0xFF67E8F9);
  static const Color sky400 = Color(0xFF38BDF8);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo300 = Color(0xFFA5B4FC);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber300 = Color(0xFFFCD34D);

  // Status
  static const Color statusGreen = Color(0xFF22C55E);

  // Misc fills
  static const Color avatarFill = Color(0xFF161E2B);

  // App-icon badge fills (accent @ .22 -> other accent)
  static const Color appIconCyanStart = Color(0x3822D3EE); // cyan400 .22
  static const Color appIconCyanEnd = Color(0x243B82F6); // blue500 .14
  static const Color appIconBlueStart = Color(0x383B82F6); // blue500 .22
  static const Color appIconBlueEnd = Color(0x1A22D3EE); // cyan400 .10

  // Derived glows and tints
  static const Color gridLine = Color(0x0D94A3B8); // rgba(148,163,184,.05)
  static const Color cyanBorderHover = Color(0x5922D3EE); // .35
  static const Color cyanBorderStrong = Color(0x8022D3EE); // .50
  static const Color cyanTint = Color(0x1422D3EE); // .08
  static const Color cyanTintStrong = Color(0x2922D3EE); // .16
  static const Color blueTint = Color(0x173B82F6); // .09
  static const Color blueTintStrong = Color(0x333B82F6); // .20
  static const Color chipErpBorder = Color(0x4D22D3EE); // .30
  static const Color chipErpFill = Color(0x1222D3EE); // .07
  static const Color heroGlowCyan = Color(0x2922D3EE); // .16
  static const Color heroGlowCyanEnd = Color(0x0022D3EE);
  static const Color heroGlowBlue = Color(0x243B82F6); // .14
  static const Color heroGlowBlueEnd = Color(0x003B82F6);
  static const Color gridLineEnd = Color(0x0094A3B8);
  static const Color chipScBorder = Color(0x5960A5FA); // .35
  static const Color ecosystemGlow = Color(0x2422D3EE); // cyan .14
  static const Color contactGlow = Color(0x1F22D3EE); // cyan .12
  static const Color contactGlowEnd = Color(0x0022D3EE);
  // Skill tone cyan: accent400 at .12 / .30 / .45 / .08 / .25
  static const Color skillCyanBadgeFill = Color(0x1F22D3EE); // .12
  static const Color skillCyanBadgeBorder = Color(0x4C22D3EE); // .30
  static const Color skillCyanChipBorder = Color(0x7322D3EE); // .45
  static const Color skillCyanChipFill = Color(0x1422D3EE); // .08
  static const Color skillCyanChipGlow = Color(0x4022D3EE); // .25

  // Skill tone blue: accent400 at .12 / .30 / .45 / .08 / .25
  static const Color skillBlueBadgeFill = Color(0x1F60A5FA); // .12
  static const Color skillBlueBadgeBorder = Color(0x4C60A5FA); // .30
  static const Color skillBlueChipBorder = Color(0x7360A5FA); // .45
  static const Color skillBlueChipFill = Color(0x1460A5FA); // .08
  static const Color skillBlueChipGlow = Color(0x4060A5FA); // .25

  // Skill tone indigo: accent400 at .12 / .30 / .45 / .08 / .25
  static const Color skillIndigoBadgeFill = Color(0x1F818CF8); // .12
  static const Color skillIndigoBadgeBorder = Color(0x4C818CF8); // .30
  static const Color skillIndigoChipBorder = Color(0x73818CF8); // .45
  static const Color skillIndigoChipFill = Color(0x14818CF8); // .08
  static const Color skillIndigoChipGlow = Color(0x40818CF8); // .25

  // Skill tone amber: accent400 at .12 / .30 / .45 / .08 / .25
  static const Color skillAmberBadgeFill = Color(0x1FFBBF24); // .12
  static const Color skillAmberBadgeBorder = Color(0x4CFBBF24); // .30
  static const Color skillAmberChipBorder = Color(0x73FBBF24); // .45
  static const Color skillAmberChipFill = Color(0x14FBBF24); // .08
  static const Color skillAmberChipGlow = Color(0x40FBBF24); // .25
  static const Color timelineBullet = Color(0xB322D3EE); // cyan400 @ .7
}

/// Design tokens: gradients.
abstract final class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cyan400, AppColors.blue500],
  );

  /// Exact CSS `linear-gradient(135deg, …)` for boxes of any aspect ratio.
  static const CssLinearGradient primaryCss = CssLinearGradient(
    colors: [AppColors.cyan400, AppColors.blue500],
  );

  /// App-icon badge fills (CSS 135deg).
  static const CssLinearGradient appIconCyan = CssLinearGradient(
    colors: [AppColors.appIconCyanStart, AppColors.appIconCyanEnd],
  );
  static const CssLinearGradient appIconBlue = CssLinearGradient(
    colors: [AppColors.appIconBlueStart, AppColors.appIconBlueEnd],
  );

  static const LinearGradient primaryHover = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cyan300, AppColors.blue400],
  );

  static const List<Color> textColors = [
    AppColors.cyan300,
    AppColors.sky400,
    AppColors.blue500,
  ];
  static const List<double> textStops = [0.0, 0.45, 1.0];

  static const LinearGradient text = LinearGradient(
    colors: textColors,
    stops: textStops,
  );

  /// CSS `radial-gradient(circle, cyan .14, transparent 70%)` on a square
  /// (farthest-corner radius = 0.7071 of the side).
  static const RadialGradient ecosystemGlow = RadialGradient(
    radius: 0.7071,
    colors: [AppColors.ecosystemGlow, AppColors.heroGlowCyanEnd],
    stops: [0.0, 0.7],
  );

  static const LinearGradient surfaceCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.surface, AppColors.surfaceGradientEnd],
  );

  static const LinearGradient timelineRail = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.cyan400, Color(0x263B82F6)], // blue500 @ .15
  );

  static const RadialGradient heroGlowPrimary = RadialGradient(
    center: Alignment(0, -1),
    radius: 0.6,
    colors: [Color(0x2922D3EE), Color(0x0022D3EE)], // cyan400 @ .16 -> 0
    stops: [0.0, 0.7],
  );

  static const RadialGradient heroGlowSecondary = RadialGradient(
    center: Alignment(0.7, -0.6),
    radius: 0.6,
    colors: [Color(0x243B82F6), Color(0x003B82F6)], // blue500 @ .14 -> 0
    stops: [0.0, 0.7],
  );
}

/// Design tokens: shadows.
abstract final class AppShadows {
  static const List<BoxShadow> cardHover = [
    BoxShadow(color: Color(0x1422D3EE), spreadRadius: 1), // 0 0 0 1px cyan .08
    BoxShadow(
      color: Color(0x6622D3EE), // cyan .4
      offset: Offset(0, 24),
      blurRadius: 64,
      spreadRadius: -32,
    ),
  ];

  static const List<BoxShadow> timelineDotActive = [
    BoxShadow(color: AppColors.background, spreadRadius: 4),
    BoxShadow(color: Color(0xB322D3EE), blurRadius: 18), // cyan .7
  ];

  /// Drop shadow under the compact menu panel.
  static const List<BoxShadow> menuPanel = [
    BoxShadow(
      color: Color(0x66000000), // black .4
      offset: Offset(0, 16),
      blurRadius: 32,
      spreadRadius: -12,
    ),
  ];

  /// Soft cyan glow around the hero avatar.
  static const List<BoxShadow> avatarGlow = [
    BoxShadow(
      color: Color(0x5922D3EE), // cyan400 @ .35
      blurRadius: 40,
      spreadRadius: -8,
    ),
  ];

  static const List<BoxShadow> timelineDot = [
    BoxShadow(color: AppColors.background, spreadRadius: 4),
  ];
}
