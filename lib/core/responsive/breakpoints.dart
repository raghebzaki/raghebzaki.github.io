enum ScreenType { mobile, tablet, desktop }

abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;

  static ScreenType of(double width) {
    if (width >= desktop) return ScreenType.desktop;
    if (width >= tablet) return ScreenType.tablet;
    return ScreenType.mobile;
  }
}
