import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/painting.dart';

/// CSS `linear-gradient(135deg, …)`.
const double cssAngle135 = 135;

/// Start/end of the CSS gradient line for [angleDeg] over a [w] x [h] box,
/// relative to the box's top-left corner.
///
/// CSS angles: 0 = to top, 90 = to right, clockwise. The gradient line passes
/// through the box center and has length `|w·sin θ| + |h·cos θ|`.
(Offset, Offset) _cssLine(double w, double h, double angleDeg) {
  final theta = angleDeg * math.pi / 180;
  // Snap float noise (cos 90° = 6e-17) so axis-aligned angles stay exact.
  double snap(double v) => v.abs() < 1e-12 ? 0 : v;
  final dx = snap(math.sin(theta));
  final dy = snap(-math.cos(theta));
  final length = (w * dx).abs() + (h * dy).abs();
  final center = Offset(w / 2, h / 2);
  final half = Offset(dx * length / 2, dy * length / 2);
  return (center - half, center + half);
}

/// Shader equivalent to CSS `linear-gradient(<angleDeg>deg, …)` painted over
/// [rect].
ui.Shader cssLinearShader(
  Rect rect,
  double angleDeg,
  List<Color> colors, [
  List<double>? stops,
]) {
  final (start, end) = _cssLine(rect.width, rect.height, angleDeg);
  return ui.Gradient.linear(
    rect.topLeft + start,
    rect.topLeft + end,
    colors,
    stops,
  );
}

/// [LinearGradient] equivalent to CSS `linear-gradient(<angleDeg>deg, …)` for
/// a box of [size] (alignments are box-relative).
LinearGradient cssLinearGradient(
  Size size,
  double angleDeg,
  List<Color> colors, [
  List<double>? stops,
]) {
  final w = size.width;
  final h = size.height;
  if (w <= 0 || h <= 0) {
    return LinearGradient(colors: colors, stops: stops);
  }
  final (start, end) = _cssLine(w, h, angleDeg);
  Alignment toAlignment(Offset p) =>
      Alignment((p.dx - w / 2) / (w / 2), (p.dy - h / 2) / (h / 2));
  return LinearGradient(
    begin: toAlignment(start),
    end: toAlignment(end),
    colors: colors,
    stops: stops,
  );
}

/// A [Gradient] that resolves the CSS angle maths against the rect it is
/// actually painted into, so decorations get an exact CSS gradient without
/// knowing their size at build time. Interpolates with other
/// [CssLinearGradient]s of the same shape.
class CssLinearGradient extends Gradient {
  const CssLinearGradient({
    required super.colors,
    super.stops,
    this.angle = cssAngle135,
  });

  final double angle;

  @override
  ui.Shader createShader(Rect rect, {TextDirection? textDirection}) =>
      cssLinearShader(rect, angle, colors, stops);

  @override
  CssLinearGradient scale(double factor) => CssLinearGradient(
    colors: [for (final c in colors) Color.lerp(null, c, factor)!],
    stops: stops,
    angle: angle,
  );

  @override
  CssLinearGradient withOpacity(double opacity) => CssLinearGradient(
    colors: [for (final c in colors) c.withValues(alpha: opacity)],
    stops: stops,
    angle: angle,
  );

  @override
  CssLinearGradient fromColor(Color color) => CssLinearGradient(
    colors: List<Color>.filled(colors.length, color),
    stops: stops,
    angle: angle,
  );

  CssLinearGradient? _lerpWith(Gradient? other, double t, {required bool to}) {
    if (other is! CssLinearGradient ||
        other.colors.length != colors.length ||
        other.angle != angle) {
      return null;
    }
    final from = to ? this : other;
    final end = to ? other : this;
    return CssLinearGradient(
      colors: [
        for (var i = 0; i < colors.length; i++)
          Color.lerp(from.colors[i], end.colors[i], t)!,
      ],
      stops: stops,
      angle: angle,
    );
  }

  @override
  Gradient? lerpFrom(Gradient? a, double t) =>
      a == null ? scale(t) : _lerpWith(a, t, to: false);

  @override
  Gradient? lerpTo(Gradient? b, double t) =>
      b == null ? scale(1 - t) : _lerpWith(b, t, to: true);

  @override
  bool operator ==(Object other) =>
      other is CssLinearGradient &&
      other.angle == angle &&
      listEquals(other.colors, colors) &&
      listEquals(other.stops, stops);

  @override
  int get hashCode =>
      Object.hash(angle, Object.hashAll(colors), Object.hashAll(stops ?? []));
}
