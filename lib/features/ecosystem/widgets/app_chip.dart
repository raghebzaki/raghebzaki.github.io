import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/ecosystem.dart';

class _ChipPalette {
  const _ChipPalette({
    required this.text,
    required this.border,
    required this.fill,
    required this.hoverFill,
  });

  final Color text;
  final Color border;
  final Color fill;
  final Color hoverFill;
}

const _erpPalette = _ChipPalette(
  text: AppColors.cyan300,
  border: AppColors.chipErpBorder,
  fill: AppColors.chipErpFill,
  hoverFill: AppColors.cyanTintStrong,
);

const _serviceCenterPalette = _ChipPalette(
  text: AppColors.blue300,
  border: AppColors.chipScBorder,
  fill: AppColors.blueTint,
  hoverFill: AppColors.blueTintStrong,
);

_ChipPalette _paletteFor(AppFamilyId family) => switch (family) {
  AppFamilyId.erp => _erpPalette,
  AppFamilyId.serviceCenter => _serviceCenterPalette,
};

/// One app name in the ecosystem cloud.
///
/// Dimming scales each colour's alpha instead of using `Opacity`, so 34 chips
/// do not each need an offscreen layer. Dimmed chips are hidden from
/// assistive technology.
class AppChip extends StatefulWidget {
  const AppChip({
    required this.label,
    required this.family,
    required this.dimmed,
    super.key,
  });

  final String label;
  final AppFamilyId family;
  final bool dimmed;

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final palette = _paletteFor(widget.family);
    final factor = widget.dimmed ? AppOpacity.chipDimmed : 1.0;
    Color scaled(Color c) => c.withValues(alpha: c.a * factor);

    return ExcludeSemantics(
      excluding: widget.dimmed,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : AppDurations.fast,
          transform: Matrix4.translationValues(
            0,
            _hovered ? -AppLayout.chipLift : 0,
            0,
          ),
          child: AnimatedContainer(
            duration: reduceMotion ? Duration.zero : AppDurations.medium,
            constraints: const BoxConstraints(
              minHeight: AppLayout.chipMinHeight,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
            decoration: BoxDecoration(
              color: scaled(_hovered ? palette.hoverFill : palette.fill),
              borderRadius: AppRadii.pillBorder,
              border: Border.all(color: scaled(palette.border)),
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: AnimatedDefaultTextStyle(
                duration: reduceMotion ? Duration.zero : AppDurations.medium,
                style: AppTextStyles.chip.copyWith(color: scaled(palette.text)),
                child: Text(widget.label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
