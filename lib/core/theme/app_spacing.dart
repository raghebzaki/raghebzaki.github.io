import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Design tokens: spacing scale.
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s5 = 5;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s28 = 28;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;
  static const double s72 = 72;
  static const double s96 = 96;
  static const double s112 = 112;
}

/// Design tokens: corner radii.
abstract final class AppRadii {
  static const double pill = 999;
  static const double segment = 10;
  static const double button = 12;
  static const double segmentGroup = 14;
  static const double card = 20;
  static const double panel = 24;
  static const double phoneOuter = 38;
  static const double phoneInner = 30;
  static const double brand = 9;

  static const BorderRadius brandBorder = BorderRadius.all(
    Radius.circular(brand),
  );
  static const BorderRadius pillBorder = BorderRadius.all(
    Radius.circular(pill),
  );
  static const BorderRadius segmentBorder = BorderRadius.all(
    Radius.circular(segment),
  );
  static const BorderRadius buttonBorder = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius segmentGroupBorder = BorderRadius.all(
    Radius.circular(segmentGroup),
  );
  static const BorderRadius cardBorder = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius panelBorder = BorderRadius.all(
    Radius.circular(panel),
  );
  static const BorderRadius phoneOuterBorder = BorderRadius.all(
    Radius.circular(phoneOuter),
  );
  static const BorderRadius phoneInnerBorder = BorderRadius.all(
    Radius.circular(phoneInner),
  );
}

/// Design tokens: layout constraints.
abstract final class AppLayout {
  static const double maxContent = 1200;
  static const double heroMax = 1000;
  static const double leadMax = 720;
  static const double ctaTextMax = 520;
  static const double gutter = 24;
  static const double minTapTarget = 44;
  static const double gridGap = 20;
  static const double ctaGap = 12;
  static const double heroGridSpacing = 56;
  static const double statsMinTile = 220;

  /// Featured projects grid.
  static const double projectMinTile = 540;
  static const double cardPadding = 28;
  static const double cardInfoMin = 220;

  /// Phone mockup (outer box, border-box).
  static const double phoneWidth = 208;
  static const double phoneHeight = 424;
  static const double phoneInset = 8;
  static const double phoneLift = 6;
  static const double phoneLiftAngle = -0.01745329251994; // -1deg in rad
  static const double notchWidth = 60;
  static const double notchHeight = 17;
  static const double notchTop = 9;

  /// Ecosystem card.
  static const double ecosystemHeaderMax = 560;
  static const double ecosystemGlowSize = 420;
  static const double ecosystemGlowTop = -120;
  static const double ecosystemGlowRight = -80;
  static const double chipMinHeight = 36;
  static const double chipLift = 2;

  /// Skills grid.
  static const double skillMinTile = 380;
  static const double skillCardPadding = 28;
  static const double skillCardMinHeight = 300;
  static const double skillBarsHeight = 56;
  static const double skillLayerIndent = 14;

  /// Hero avatar (outer ring box, inner photo, status dot, halo scale).
  static const double avatarSize = 88;
  static const double avatarRing = 2;
  static const double avatarPhoto = 84;
  static const double statusDotSize = 16;
  static const double statusDotRing = 3;
  static const double statusDotInset = 2;
  static const double statusHaloScale = 2.2;

  /// Timeline rail, gutter and dots.
  static const double timelineGutter = 36;
  static const double timelineRailLeft = 9;
  static const double timelineRailInset = 12;
  static const double timelineRailWidth = 2;
  static const double timelineDotSize = 12;
  static const double timelineDotTop = 30;
  static const double timelineBulletSize = 6;
  static const double timelineBulletTop = 9;

  /// Vertical section paddings from the prototype.
  static const double projectsTop = 96;
  static const double defaultTop = 112;
  static const double footerBottom = 48;
}

/// Design tokens: opacities.
abstract final class AppOpacity {
  /// Filtered-out ecosystem chips.
  static const double chipDimmed = 0.16;

  /// Count next to a filter label.
  static const double filterCount = 0.6;

  /// Halo start opacity of the avatar status dot.
  static const double statusHalo = 0.55;
}

/// Design tokens: animation durations.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration phoneLift = Duration(milliseconds: 350);
  static const Duration statusPulse = Duration(milliseconds: 2000);
  static const Duration copyFeedback = Duration(seconds: 2);
}

/// Design tokens: animation curves.
abstract final class AppCurves {
  static const Cubic phoneLift = Cubic(0.2, 0.8, 0.2, 1);
}
