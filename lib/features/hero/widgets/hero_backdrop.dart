import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// An elliptical radial gradient (CSS `radial-gradient(rx ry at cx cy, …)`).
class HeroEllipse {
  const HeroEllipse({
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

/// Pure geometry of the hero backdrop for a given size.
class HeroBackdropSpec {
  const HeroBackdropSpec({
    required this.cyanGlow,
    required this.blueGlow,
    required this.gridMask,
    required this.verticalLines,
    required this.horizontalLines,
  });

  factory HeroBackdropSpec.forSize(Size size) {
    final w = size.width;
    final h = size.height;
    const spacing = AppLayout.heroGridSpacing;
    return HeroBackdropSpec(
      cyanGlow: HeroEllipse(
        center: Offset(w / 2, 0),
        radii: Offset(0.6 * w, 0.55 * h),
        colors: const [AppColors.heroGlowCyan, AppColors.heroGlowCyanEnd],
        stops: const [0, 0.7],
      ),
      blueGlow: HeroEllipse(
        center: Offset(0.85 * w, 0.2 * h),
        radii: Offset(0.4 * w, 0.4 * h),
        colors: const [AppColors.heroGlowBlue, AppColors.heroGlowBlueEnd],
        stops: const [0, 0.7],
      ),
      gridMask: HeroEllipse(
        center: Offset(0.5 * w, 0.25 * h),
        radii: Offset(0.7 * w, 0.7 * h),
        colors: const [AppColors.gridLine, AppColors.gridLineEnd],
        stops: const [0, 0.75],
      ),
      verticalLines: [
        if (w > 0)
          for (var k = 0; k <= (w / spacing).floor(); k++) k * spacing + 0.5,
      ],
      horizontalLines: [
        if (h > 0)
          for (var k = 0; k <= (h / spacing).floor(); k++) k * spacing + 0.5,
      ],
    );
  }

  final HeroEllipse cyanGlow;
  final HeroEllipse blueGlow;
  final HeroEllipse gridMask;

  /// X positions of the vertical grid lines.
  final List<double> verticalLines;

  /// Y positions of the horizontal grid lines.
  final List<double> horizontalLines;
}

/// Paints the hero glows and the masked grid.
class HeroBackdropPainter extends CustomPainter {
  const HeroBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final spec = HeroBackdropSpec.forSize(size);
    final rect = Offset.zero & size;

    for (final glow in [spec.cyanGlow, spec.blueGlow]) {
      if (glow.isEmpty) continue;
      canvas.drawRect(rect, Paint()..shader = glow.createShader());
    }

    if (spec.gridMask.isEmpty) return;
    final path = Path();
    for (final x in spec.verticalLines) {
      path
        ..moveTo(x, 0)
        ..lineTo(x, size.height);
    }
    for (final y in spec.horizontalLines) {
      path
        ..moveTo(0, y)
        ..lineTo(size.width, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..shader = spec.gridMask.createShader(),
    );
  }

  @override
  bool shouldRepaint(HeroBackdropPainter oldDelegate) => false;
}

/// Decorative backdrop; fills its parent.
class HeroBackdrop extends StatelessWidget {
  const HeroBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(painter: HeroBackdropPainter()),
        ),
      ),
    );
  }
}
