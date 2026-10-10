import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/skill.dart';
import '../../../../shared/widgets/tag_pill.dart';

/// Tags above a row of bars (static; motion comes later).
class TagPulseView extends StatelessWidget {
  const TagPulseView({required this.visual, super.key});

  final TagPulse visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final tag in visual.hotTags) TagPill(tag, tone: TagTone.hot),
            for (final tag in visual.neutralTags) TagPill(tag),
          ],
        ),
        const SizedBox(height: AppSpacing.s20),
        ExcludeSemantics(
          child: SizedBox(
            height: AppLayout.skillBarsHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < visual.bars.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.s5),
                  Expanded(child: _Bar(visual.bars[i])),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar(this.bar);

  final SkillBar bar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bar.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bar.highlighted ? null : AppColors.skeleton,
          gradient: bar.highlighted ? AppGradients.highlight : null,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
      ),
    );
  }
}
