import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/responsive/breakpoints.dart';
import 'package:ragheb_portfolio/core/responsive/responsive_value.dart';
import 'package:ragheb_portfolio/core/theme/app_typography.dart';

void main() {
  group('ResponsiveValue', () {
    test('only mobile falls back everywhere', () {
      const v = ResponsiveValue<int>(mobile: 1);
      expect(v.resolve(ScreenType.mobile), 1);
      expect(v.resolve(ScreenType.tablet), 1);
      expect(v.resolve(ScreenType.desktop), 1);
    });

    test('mobile + desktop: tablet falls back to mobile', () {
      const v = ResponsiveValue<int>(mobile: 1, desktop: 3);
      expect(v.resolve(ScreenType.tablet), 1);
      expect(v.resolve(ScreenType.desktop), 3);
    });

    test('mobile + tablet: desktop falls back to tablet', () {
      const v = ResponsiveValue<int>(mobile: 1, tablet: 2);
      expect(v.resolve(ScreenType.desktop), 2);
    });
  });

  group('FluidValue', () {
    test('clamps at min, max and interpolates between', () {
      const v = FluidValue(10, 20, 0.01);
      expect(v.resolve(100), 10);
      expect(v.resolve(1500), 15);
      expect(v.resolve(5000), 20);
    });

    test('display token', () {
      expect(AppFluid.display.resolve(360), 46);
      expect(AppFluid.display.resolve(800), closeTo(72, 1e-9));
      expect(AppFluid.display.resolve(1440), 92);
    });
  });

  group('AutoFit', () {
    test('stats (minTile 220)', () {
      expect(AutoFit.columns(360 - 48, minTile: 220), 1);
      expect(AutoFit.columns(1000, minTile: 220, maxColumns: 3), 3);
      expect(AutoFit.columns(1000, minTile: 220), 4);
    });

    test('projects (minTile 540, gap 20)', () {
      expect(AutoFit.columns(1000, minTile: 540, gap: 20), 1);
      expect(AutoFit.columns(1152, minTile: 540, gap: 20), 2);
    });

    test('skills (minTile 380, gap 20)', () {
      expect(AutoFit.columns(720, minTile: 380, gap: 20), 1);
      expect(AutoFit.columns(1152, minTile: 380, gap: 20), 2);
    });

    test('never fewer than 1 column, honors maxColumns', () {
      expect(AutoFit.columns(100, minTile: 500), 1);
      expect(AutoFit.columns(10000, minTile: 100, maxColumns: 4), 4);
    });

    test('tileWidth', () {
      expect(AutoFit.tileWidth(1000, 2, 20), 490);
      expect(AutoFit.tileWidth(300, 1, 20), 300);
    });
  });
}
