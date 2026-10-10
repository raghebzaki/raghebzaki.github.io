import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../domain/entities/skill.dart';
import '../../../../shared/widgets/app_icon.dart';

/// Steps joined by arrows, with the active step highlighted.
class StateFlowView extends StatelessWidget {
  const StateFlowView({required this.visual, super.key});

  final StateFlow visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < visual.steps.length; i++) ...[
              if (i > 0)
                const AppIconView(
                  AppIcon.arrowRight,
                  color: AppColors.cyan400,
                  size: 20,
                  height: 12,
                ),
              _Step(label: visual.steps[i], active: i == visual.activeIndex),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.s20),
        Text(visual.caption, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? AppColors.flowActiveFill : AppColors.surfaceInset,
        borderRadius: AppRadii.segmentBorder,
        border: Border.all(
          color: active ? AppColors.flowActiveBorder : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s14,
          vertical: AppSpacing.s10,
        ),
        child: Text(
          label,
          style: AppTextStyles.flowStep.copyWith(
            color: active ? AppColors.cyan300 : AppColors.textEmphasis,
          ),
        ),
      ),
    );
  }
}
