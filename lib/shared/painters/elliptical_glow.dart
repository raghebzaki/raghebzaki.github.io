import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// An elliptical radial gradient (CSS `radial-gradient(rx ry at cx cy, …)`).
///
/// Shared by the hero backdrop and the contact panel.
class EllipticalGlow {
  const EllipticalGlow({
    required this.center,
    required this.radii,
    required this.colors,
    required this.stops,
  });

  final Offset center;

  /// Horizontal and vertical radius (`dx` = rx, `dy` = ry).
  final Offset radii;
  final List<Color> colors;
  final List<double> stops;

  bool get isEmpty => radii.dx <= 0 || radii.dy <= 0;

  /// Column-major 4x4 matrix `translate(cx, cy) · scale(rx, ry)`, mapping the
  /// unit-circle gradient onto the ellipse.
  Float64List get matrix {
    final m = Float64List(16);
    m[0] = radii.dx;
    m[5] = radii.dy;
    m[10] = 1;
    m[12] = center.dx;
    m[13] = center.dy;
    m[15] = 1;
    return m;
  }

  ui.Shader createShader() =>
      ui.Gradient.radial(Offset.zero, 1, colors, stops, TileMode.clamp, matrix);
}
