import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Design tokens: spacing scale.
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
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
}

/// Design tokens: animation durations.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration phoneLift = Duration(milliseconds: 350);
}

/// Design tokens: animation curves.
abstract final class AppCurves {
  static const Cubic phoneLift = Cubic(0.2, 0.8, 0.2, 1);
}
