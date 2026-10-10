import 'package:flutter/widgets.dart';

import '../theme/app_typography.dart';
import 'breakpoints.dart';
import 'responsive_value.dart';

/// Responsive helpers on [BuildContext].
///
/// Uses `MediaQuery.sizeOf`, so dependents only rebuild when the viewport
/// size changes (not on unrelated MediaQuery changes such as insets).
extension ResponsiveContext on BuildContext {
  double get viewportWidth => MediaQuery.sizeOf(this).width;

  ScreenType get screen => Breakpoints.of(viewportWidth);

  bool get isMobile => screen == ScreenType.mobile;
  bool get isTablet => screen == ScreenType.tablet;
  bool get isDesktop => screen == ScreenType.desktop;

  T responsive<T>(ResponsiveValue<T> value) => value.resolve(screen);

  AppTypography get typography => AppTypography.of(viewportWidth);
}
