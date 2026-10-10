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
  static const Color sky300 = Color(0xFF7DD3FC);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color cyan700 = Color(0xFF0E7490);
  static const Color blue600 = Color(0xFF2563EB);

  // Phone mockup
  static const Color phoneBody = Color(0xFF0A0D14);
  static const Color phoneBorder = Color(0xFF30363D);
  static const Color phoneScreen = Color(0xFF0F1623);
  static const Color phoneTile = Color(0xFF161E2B);
  static const Color phoneInput = Color(0xFF1A2230);
  static const Color skeleton = Color(0xFF232B38);
  static const Color phoneImageStart = Color(0xFF1E2A3D);
  static const Color phoneImageEnd = Color(0xFF14202F);
  static const Color phoneSelectedStart = Color(0xFF164E63);
  static const Color phoneSelectedEnd = Color(0xFF0C2A3A);
  static const Color phoneSelectedRing = Color(0x9922D3EE); // cyan .6
  static const Color phoneNotch = Color(0xFF000000);
  static const Color mockTintCyan = Color(0x2622D3EE); // cyan .15
  static const Color mockTintBlue = Color(0x2E3B82F6); // blue .18
  static const Color white85 = Color(0xD9FFFFFF);
  static const Color white88 = Color(0xE0FFFFFF);
  static const Color white75 = Color(0xBFFFFFFF);
  static const Color white45 = Color(0x73FFFFFF);

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
  static const Color layerSkyBorder = Color(0x4D38BDF8); // .30
  static const Color layerBlueBorder = Color(0x4D60A5FA); // .30
  static const Color flowActiveFill = Color(0x1A22D3EE); // .10
  static const Color flowActiveBorder = Color(0x6622D3EE); // .40
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

  /// CSS `linear-gradient(90deg, cyan400, blue500)` (highlight bars).
  static const LinearGradient highlight = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.cyan400, AppColors.blue500],
  );

  static const LinearGradient phoneImageSelected = LinearGradient(
    begin: Alignment(-0.34, -0.94),
    end: Alignment(0.34, 0.94),
    colors: [AppColors.phoneSelectedStart, AppColors.phoneSelectedEnd],
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

  static const LinearGradient banner = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cyan700, AppColors.blue600],
  );

  static const LinearGradient memberCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cyan700, AppColors.blue700],
  );

  /// CSS 160deg: mostly top-to-bottom, leaning slightly to the right.
  static const LinearGradient phoneImage = LinearGradient(
    begin: Alignment(-0.34, -0.94),
    end: Alignment(0.34, 0.94),
    colors: [AppColors.phoneImageStart, AppColors.phoneImageEnd],
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

  static const List<BoxShadow> phoneCyan = [
    BoxShadow(
      color: Color(0xE6000000), // black .9
      offset: Offset(0, 30),
      blurRadius: 60,
      spreadRadius: -24,
    ),
    BoxShadow(
      color: Color(0x8022D3EE), // cyan .5
      offset: Offset(0, 30),
      blurRadius: 90,
      spreadRadius: -34,
    ),
  ];

  static const List<BoxShadow> phoneBlue = [
    BoxShadow(
      color: Color(0xE6000000),
      offset: Offset(0, 30),
      blurRadius: 60,
      spreadRadius: -24,
    ),
    BoxShadow(
      color: Color(0x803B82F6), // blue500 .5
      offset: Offset(0, 30),
      blurRadius: 90,
      spreadRadius: -34,
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

  static const List<BoxShadow> timelineDot = [
    BoxShadow(color: AppColors.background, spreadRadius: 4),
  ];
}
