import 'breakpoints.dart';

/// A value that varies by [ScreenType], with downward fallback
/// (desktop -> tablet -> mobile).
class ResponsiveValue<T> {
  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  final T mobile;
  final T? tablet;
  final T? desktop;

  T resolve(ScreenType screen) {
    switch (screen) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }
}

/// A fluid size mirroring CSS `clamp(min, n·vw, max)`.
class FluidValue {
  const FluidValue(this.min, this.max, this.viewportFraction)
    : assert(min <= max, 'min must be <= max');

  final double min;
  final double max;

  /// Fraction of the viewport width (e.g. 0.09 == 9vw).
  final double viewportFraction;

  double resolve(double viewportWidth) =>
      (viewportWidth * viewportFraction).clamp(min, max).toDouble();
}

/// Mirrors CSS `repeat(auto-fit, minmax(min(minTile, 100%), 1fr))`.
abstract final class AutoFit {
  /// Largest n >= 1 with `n * minTile + (n - 1) * gap <= available`,
  /// capped at [maxColumns].
  static int columns(
    double available, {
    required double minTile,
    double gap = 0,
    int maxColumns = 12,
  }) {
    if (available <= 0 || minTile <= 0) return 1;
    final n = ((available + gap) / (minTile + gap)).floor();
    if (n < 1) return 1;
    return n > maxColumns ? maxColumns : n;
  }

  static double tileWidth(double available, int columns, double gap) {
    if (columns <= 0) return available;
    return (available - gap * (columns - 1)) / columns;
  }
}
