import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/app_icon.dart';

/// The icon for a [ProjectGlyph].
AppIcon glyphIcon(ProjectGlyph glyph) => switch (glyph) {
  ProjectGlyph.cart => AppIcon.cart,
  ProjectGlyph.modules => AppIcon.board,
  ProjectGlyph.register => AppIcon.ledger,
  ProjectGlyph.members => AppIcon.users,
};

/// A squircle "app icon" tile with a tinted gradient fill and a glyph.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({required this.glyph, required this.accent, super.key});

  final ProjectGlyph glyph;
  final AccentTone accent;

  @override
  Widget build(BuildContext context) {
    final cyan = accent == AccentTone.cyan;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: AppLayout.appIconBadgeSize,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            gradient: cyan
                ? AppGradients.appIconCyan
                : AppGradients.appIconBlue,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.appIconBorder,
              side: BorderSide(
                color: cyan
                    ? AppColors.cyanBorderHover
                    : AppColors.chipScBorder,
              ),
            ),
          ),
          child: Center(
            child: AppIconView(
              glyphIcon(glyph),
              color: cyan ? AppColors.cyan300 : AppColors.blue300,
              size: AppLayout.appIconGlyphSize,
            ),
          ),
        ),
      ),
    );
  }
}
