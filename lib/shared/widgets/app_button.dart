import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/css_gradient.dart';
import 'app_icon.dart';

enum _ButtonKind { primary, secondary }

/// The site's primary (gradient) and secondary (outlined) buttons.
class AppButton extends StatefulWidget {
  const AppButton.primary({
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.semanticLabel,
    this.isLink = false,
    this.compact = false,
    this.labelMinWidth,
    super.key,
  }) : _kind = _ButtonKind.primary;

  const AppButton.secondary({
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.semanticLabel,
    this.isLink = false,
    this.compact = false,
    this.labelMinWidth,
    super.key,
  }) : _kind = _ButtonKind.secondary;

  final String label;
  final AppIcon? icon;

  /// Icon shown after the label.
  final AppIcon? trailingIcon;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  /// Exposes link semantics instead of button semantics (use inside `Link`).
  final bool isLink;

  /// Tighter horizontal padding (16 instead of 20) for buttons that sit in
  /// narrow columns, e.g. store links in a two-column project card. The tap
  /// target height is unchanged.
  final bool compact;

  /// Minimum width of the (centered) label, so a label that changes (e.g.
  /// "Copy email" -> "Copied") does not resize the button.
  final double? labelMinWidth;
  final _ButtonKind _kind;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  static const _primaryGradient = CssLinearGradient(
    colors: [AppColors.cyan400, AppColors.blue500],
  );
  static const _primaryHoverGradient = CssLinearGradient(
    colors: [AppColors.cyan300, AppColors.blue400],
  );
  static const double _ringWidth = 2;
  static const double _ringGap = 2;

  bool _hovered = false;
  bool _focused = false;

  bool get _primary => widget._kind == _ButtonKind.primary;

  bool get _showRing =>
      _focused &&
      FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppDurations.fast;
    final style = _primary ? AppTextStyles.buttonPrimary : AppTextStyles.button;
    final foreground = style.color!;

    final decoration = _primary
        ? BoxDecoration(
            gradient: _hovered ? _primaryHoverGradient : _primaryGradient,
            borderRadius: AppRadii.buttonBorder,
            border: Border.all(color: const Color(0x00000000)),
          )
        : BoxDecoration(
            color: _hovered ? AppColors.surfaceHover : AppColors.surface,
            borderRadius: AppRadii.buttonBorder,
            border: Border.all(
              color: _hovered ? AppColors.cyanBorderStrong : AppColors.border,
            ),
          );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          AppIconView(widget.icon!, color: foreground),
          const SizedBox(width: AppSpacing.s8),
        ],
        // Flexible so a long label (an email address, large text scale) wraps
        // instead of overflowing a narrow screen.
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: widget.labelMinWidth ?? 0),
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.s8),
          AppIconView(widget.trailingIcon!, color: foreground),
        ],
      ],
    );

    return Semantics(
      button: !widget.isLink,
      link: widget.isLink,
      enabled: widget.onPressed != null,
      label: widget.semanticLabel,
      excludeSemantics: widget.semanticLabel != null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: AppRadii.buttonBorder,
            mouseCursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeOut,
              constraints: const BoxConstraints(
                minHeight: AppLayout.minTapTarget,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? AppSpacing.s16 : AppSpacing.s20,
              ),
              decoration: decoration,
              child: Center(widthFactor: 1, heightFactor: 1, child: content),
            ),
          ),
          if (_showRing)
            Positioned(
              left: -(_ringGap + _ringWidth),
              top: -(_ringGap + _ringWidth),
              right: -(_ringGap + _ringWidth),
              bottom: -(_ringGap + _ringWidth),
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppRadii.button + _ringGap + _ringWidth,
                    ),
                    border: Border.all(
                      color: AppColors.cyan400,
                      width: _ringWidth,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
