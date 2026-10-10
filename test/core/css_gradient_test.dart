import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/css_gradient.dart';

void main() {
  // Recovers start/end through the alignment conversion, which uses the same
  // maths as the shader.
  (Offset, Offset) line(Size size, double angle) {
    final g = cssLinearGradient(size, angle, const [
      Color(0xFF000000),
      Color(0xFFFFFFFF),
    ]);
    Offset at(Alignment a) => Offset(
      size.width / 2 + a.x * size.width / 2,
      size.height / 2 + a.y * size.height / 2,
    );
    return (at(g.begin as Alignment), at(g.end as Alignment));
  }

  void expectOffset(Offset actual, Offset expected, double tol) {
    expect(actual.dx, closeTo(expected.dx, tol));
    expect(actual.dy, closeTo(expected.dy, tol));
  }

  test('90deg on 200x100 runs left to right', () {
    final (s, e) = line(const Size(200, 100), 90);
    expectOffset(s, const Offset(0, 50), 0.01);
    expectOffset(e, const Offset(200, 50), 0.01);
  });

  test('180deg runs top to bottom', () {
    final (s, e) = line(const Size(200, 100), 180);
    expectOffset(s, const Offset(100, 0), 0.01);
    expectOffset(e, const Offset(100, 100), 0.01);
  });

  test('135deg on a square runs corner to corner', () {
    final (s, e) = line(const Size(100, 100), 135);
    expectOffset(s, Offset.zero, 0.01);
    expectOffset(e, const Offset(100, 100), 0.01);
  });

  test('135deg on 1000x94 matches the CSS gradient line', () {
    final (s, e) = line(const Size(1000, 94), 135);
    expectOffset(s, const Offset(226.5, -226.5), 0.5);
    expectOffset(e, const Offset(773.5, 320.5), 0.5);
  });

  test('alignment conversion for 90deg', () {
    final g = cssLinearGradient(const Size(200, 100), 90, const [
      Color(0xFF000000),
      Color(0xFFFFFFFF),
    ]);
    expect(g.begin, Alignment.centerLeft);
    expect(g.end, Alignment.centerRight);
  });

  test('zero sizes do not throw', () {
    expect(
      () => cssLinearGradient(Size.zero, 135, const [
        Color(0xFF000000),
        Color(0xFFFFFFFF),
      ]),
      returnsNormally,
    );
  });

  test('cssLinearShader returns a shader', () {
    final shader = cssLinearShader(
      const Rect.fromLTWH(0, 0, 100, 100),
      cssAngle135,
      const [Color(0xFF000000), Color(0xFFFFFFFF)],
    );
    expect(shader, isA<Shader>());
  });
}
