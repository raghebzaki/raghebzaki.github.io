import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The site's card: a bordered surface whose border turns cyan and which
/// gains a glow while hovered or while keyboard focus is inside it.
///
/// The border is painted over the box (foreground) so it takes no layout
/// space. [builder] receives whether the card is currently highlighted, so
/// content can react (e.g. tint an icon).
class GlowCard extends StatefulWidget {
  const GlowCard({
    required this.builder,
    this.padding = const EdgeInsets.all(AppLayout.cardPadding),
    this.color = AppColors.surface,
    this.gradient,
    this.clip = false,
    super.key,
  });

  final Widget Function(BuildContext context, bool highlighted) builder;
  final EdgeInsetsGeometry padding;

  /// Fill colour, ignored when [gradient] is set.
  final Color color;
  final Gradient? gradient;

  /// Clips the content to the rounded corners (for decorative overflow).
  final bool clip;

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard> {
  bool _hovered = false;
  bool _focusInside = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final highlighted = _hovered || _focusInside;
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: (value) => setState(() => _focusInside = value),
          child: AnimatedContainer(
            duration: reduceMotion ? Duration.zero : AppDurations.fast,
            padding: widget.padding,
            clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
            decoration: BoxDecoration(
              color: widget.gradient == null ? widget.color : null,
              gradient: widget.gradient,
              borderRadius: AppRadii.cardBorder,
              boxShadow: highlighted ? AppShadows.cardHover : const [],
            ),
            // Painted over the box so the 1px border takes no layout space.
            foregroundDecoration: BoxDecoration(
              borderRadius: AppRadii.cardBorder,
              border: Border.all(
                color: highlighted
                    ? AppColors.cyanBorderHover
                    : AppColors.borderSubtle,
              ),
            ),
            child: widget.builder(context, highlighted),
          ),
        ),
      ),
    );
  }
}
