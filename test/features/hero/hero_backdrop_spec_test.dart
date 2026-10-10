import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/features/hero/widgets/hero_backdrop.dart';

void main() {
  final spec = HeroBackdropSpec.forSize(const Size(1440, 720));

  test('cyan glow', () {
    expect(spec.cyanGlow.center, const Offset(720, 0));
    expect(spec.cyanGlow.radii.dx, closeTo(864, 1e-9));
    expect(spec.cyanGlow.radii.dy, closeTo(396, 1e-9));
    expect(spec.cyanGlow.stops, [0, 0.7]);
  });

  test('blue glow', () {
    expect(spec.blueGlow.center.dx, closeTo(1224, 1e-9));
    expect(spec.blueGlow.center.dy, closeTo(144, 1e-9));
    expect(spec.blueGlow.radii.dx, closeTo(576, 1e-9));
    expect(spec.blueGlow.radii.dy, closeTo(288, 1e-9));
  });

  test('grid mask', () {
    expect(spec.gridMask.center, const Offset(720, 180));
    expect(spec.gridMask.stops, [0, 0.75]);
  });

  test('grid lines sit on the first pixel of each 56px tile', () {
    expect(spec.verticalLines.length, 26);
    expect(spec.verticalLines.first, 0.5);
    expect(spec.verticalLines.last, 25 * 56 + 0.5);
    expect(spec.horizontalLines.length, 13);
    for (final v in [...spec.verticalLines, ...spec.horizontalLines]) {
      expect(v - v.floor(), 0.5);
    }
  });

  test('matrix is translate · scale', () {
    final m = spec.cyanGlow.matrix;
    expect(m[0], closeTo(864, 1e-9));
    expect(m[5], closeTo(396, 1e-9));
    expect(m[12], 720);
    expect(m[13], 0);
    expect(m[15], 1);
  });

  test('zero size yields empty geometry', () {
    final empty = HeroBackdropSpec.forSize(Size.zero);
    expect(empty.verticalLines, isEmpty);
    expect(empty.cyanGlow.isEmpty, isTrue);
  });
}
