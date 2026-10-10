import 'package:flutter/painting.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/skill.dart';
import '../../../shared/widgets/app_icon.dart';

/// Colours of one [SkillTone], all precomputed tokens.
class SkillToneStyle {
  const SkillToneStyle({
    required this.accent,
    required this.soft,
    required this.badgeFill,
    required this.badgeBorder,
    required this.hoverBorder,
    required this.hoverFill,
    required this.hoverGlow,
  });

  /// The 400 shade: badge icon.
  final Color accent;

  /// The 300 shade: subtitle.
  final Color soft;
  final Color badgeFill;
  final Color badgeBorder;
  final Color hoverBorder;
  final Color hoverFill;
  final BoxShadow hoverGlow;
}

const _cyan = SkillToneStyle(
  accent: AppColors.cyan400,
  soft: AppColors.cyan300,
  badgeFill: AppColors.skillCyanBadgeFill,
  badgeBorder: AppColors.skillCyanBadgeBorder,
  hoverBorder: AppColors.skillCyanChipBorder,
  hoverFill: AppColors.skillCyanChipFill,
  hoverGlow: BoxShadow(
    color: AppColors.skillCyanChipGlow,
    blurRadius: 14,
    spreadRadius: -2,
  ),
);

const _blue = SkillToneStyle(
  accent: AppColors.blue400,
  soft: AppColors.blue300,
  badgeFill: AppColors.skillBlueBadgeFill,
  badgeBorder: AppColors.skillBlueBadgeBorder,
  hoverBorder: AppColors.skillBlueChipBorder,
  hoverFill: AppColors.skillBlueChipFill,
  hoverGlow: BoxShadow(
    color: AppColors.skillBlueChipGlow,
    blurRadius: 14,
    spreadRadius: -2,
  ),
);

const _indigo = SkillToneStyle(
  accent: AppColors.indigo400,
  soft: AppColors.indigo300,
  badgeFill: AppColors.skillIndigoBadgeFill,
  badgeBorder: AppColors.skillIndigoBadgeBorder,
  hoverBorder: AppColors.skillIndigoChipBorder,
  hoverFill: AppColors.skillIndigoChipFill,
  hoverGlow: BoxShadow(
    color: AppColors.skillIndigoChipGlow,
    blurRadius: 14,
    spreadRadius: -2,
  ),
);

const _amber = SkillToneStyle(
  accent: AppColors.amber400,
  soft: AppColors.amber300,
  badgeFill: AppColors.skillAmberBadgeFill,
  badgeBorder: AppColors.skillAmberBadgeBorder,
  hoverBorder: AppColors.skillAmberChipBorder,
  hoverFill: AppColors.skillAmberChipFill,
  hoverGlow: BoxShadow(
    color: AppColors.skillAmberChipGlow,
    blurRadius: 14,
    spreadRadius: -2,
  ),
);

/// The colours for [tone].
SkillToneStyle toneStyle(SkillTone tone) => switch (tone) {
  SkillTone.cyan => _cyan,
  SkillTone.blue => _blue,
  SkillTone.indigo => _indigo,
  SkillTone.amber => _amber,
};

/// The icon for a [SkillGlyph].
AppIcon skillGlyphIcon(SkillGlyph glyph) => switch (glyph) {
  SkillGlyph.architecture => AppIcon.layers,
  SkillGlyph.database => AppIcon.database,
  SkillGlyph.network => AppIcon.zap,
  SkillGlyph.delivery => AppIcon.rocket,
};
