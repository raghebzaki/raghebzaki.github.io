import 'package:flutter/widgets.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/skill.dart';
import '../../../shared/widgets/app_icon.dart';
import 'skill_tone_style.dart';

/// A rounded tile with the category glyph in its accent colour.
class SkillIconBadge extends StatelessWidget {
  const SkillIconBadge({required this.glyph, required this.tone, super.key});

  final SkillGlyph glyph;
  final SkillTone tone;

  @override
  Widget build(BuildContext context) {
    final style = toneStyle(tone);
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: AppLayout.skillBadgeSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style.badgeFill,
            borderRadius: AppRadii.buttonBorder,
            border: Border.all(color: style.badgeBorder),
          ),
          child: Center(
            child: AppIconView(
              skillGlyphIcon(glyph),
              color: style.accent,
              size: AppLayout.skillBadgeIcon,
            ),
          ),
        ),
      ),
    );
  }
}
