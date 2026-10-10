import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/css_gradient.dart';

/// How the gradient box is sized relative to the text.
enum GradientFit {
  /// Full available width x text height (a CSS block element). Falls back to
  /// [tight] when the width is unbounded.
  block,

  /// Measured text width x height (a CSS inline span).
  tight,
}

/// Text filled with a CSS-accurate linear gradient, applied through
/// `TextStyle.foreground` (no offscreen layer).
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.style,
    this.colors = AppGradients.textColors,
    this.stops = AppGradients.textStops,
    this.angle = cssAngle135,
    this.textAlign,
    this.fit = GradientFit.block,
    super.key,
  });

  final String text;
  final TextStyle style;
  final List<Color> colors;
  final List<double>? stops;
  final double angle;
  final TextAlign? textAlign;
  final GradientFit fit;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textAlign: textAlign ?? TextAlign.start,
          textDirection: textDirection,
          textScaler: textScaler,
        )..layout(maxWidth: constraints.maxWidth);
        final measuredWidth = painter.width;
        final height = painter.height;
        painter.dispose();

        final bounded = constraints.maxWidth.isFinite;
        final boxWidth = (fit == GradientFit.block && bounded)
            ? constraints.maxWidth
            : measuredWidth.ceilToDouble();
        final paint = Paint()
          ..shader = cssLinearShader(
            Rect.fromLTWH(0, 0, boxWidth, height),
            angle,
            colors,
            stops,
          );
        return SizedBox(
          width: boxWidth,
          child: Text(
            text,
            textAlign: textAlign,
            style: style.copyWith(foreground: paint),
          ),
        );
      },
    );
  }
}

/// A title with an inline gradient-highlighted substring.
class HighlightedTitle extends StatelessWidget {
  const HighlightedTitle({
    required this.lead,
    required this.highlight,
    required this.style,
    this.trail = '',
    this.textAlign,
    super.key,
  });

  final String lead;
  final String highlight;
  final String trail;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: lead),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GradientText(
              highlight,
              style: style,
              fit: GradientFit.tight,
            ),
          ),
          if (trail.isNotEmpty) TextSpan(text: trail),
        ],
      ),
      textAlign: textAlign,
      style: style,
    );
  }
}
