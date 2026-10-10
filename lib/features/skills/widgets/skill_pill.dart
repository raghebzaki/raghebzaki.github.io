import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/skill.dart';
import 'skill_tone_style.dart';

/// A decorative skill label that glows in its tone while a mouse hovers it.
class SkillPill extends StatefulWidget {
  const SkillPill(this.label, {required this.tone, super.key});

  final String label;
  final SkillTone tone;

  @override
  State<SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<SkillPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = toneStyle(widget.tone);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return MouseRegion(
      onEnter: (event) {
        if (event.kind == PointerDeviceKind.mouse) {
          setState(() => _hovered = true);
        }
      },
      onExit: (_) {
        if (_hovered) setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : AppDurations.fast,
        constraints: const BoxConstraints(
          minHeight: AppLayout.skillPillMinHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppLayout.skillPillPadding,
        ),
        decoration: BoxDecoration(
          color: _hovered ? style.hoverFill : AppColors.surfaceInset,
          borderRadius: AppRadii.pillBorder,
          border: Border.all(
            color: _hovered ? style.hoverBorder : AppColors.borderTag,
          ),
          boxShadow: _hovered ? [style.hoverGlow] : const [],
        ),
        // Shrink-wrap to the label: a Container `alignment` would make the
        // pill expand to the full Wrap width (one pill per row).
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: AnimatedDefaultTextStyle(
            duration: reduceMotion ? Duration.zero : AppDurations.fast,
            style: AppTextStyles.skillPill.copyWith(
              color: _hovered ? AppColors.textPrimary : AppColors.textEmphasis,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
