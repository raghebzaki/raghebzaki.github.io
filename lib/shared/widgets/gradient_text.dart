import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';

/// Text filled with a [gradient].
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.style,
    this.gradient = AppGradients.text,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: style.copyWith(color: AppColors.textBright),
      ),
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
            child: GradientText(highlight, style: style),
          ),
          if (trail.isNotEmpty) TextSpan(text: trail),
        ],
      ),
      textAlign: textAlign,
      style: style,
    );
  }
}
