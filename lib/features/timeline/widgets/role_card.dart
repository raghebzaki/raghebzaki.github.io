import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/experience.dart';
import '../../../shared/widgets/glow_card.dart';
import '../../../shared/widgets/tag_pill.dart';

/// One role: its card plus the dot that sits on the timeline rail.
class RoleCard extends StatelessWidget {
  const RoleCard({required this.experience, required this.index, super.key});

  final Experience experience;

  /// Position in the list; picks the dot colour.
  final int index;

  static const List<Color> dotColors = [
    AppColors.cyan400,
    AppColors.sky400,
    AppColors.blue500,
    AppColors.blue700,
  ];

  static const double _dotLeft =
      AppLayout.timelineRailLeft +
      AppLayout.timelineRailWidth / 2 -
      AppLayout.timelineDotSize / 2 -
      AppLayout.timelineGutter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GlowCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s24,
            horizontal: AppLayout.cardPadding,
          ),
          builder: (context, highlighted) => _RoleBody(experience),
        ),
        Positioned(
          left: _dotLeft,
          top: AppLayout.timelineDotTop,
          width: AppLayout.timelineDotSize,
          height: AppLayout.timelineDotSize,
          child: ExcludeSemantics(
            child: DecoratedBox(
              key: ValueKey('timeline-dot-$index'),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColors[index % dotColors.length],
                boxShadow: experience.isCurrent
                    ? AppShadows.timelineDotActive
                    : AppShadows.timelineDot,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleBody extends StatelessWidget {
  const _RoleBody(this.experience);

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s24,
          runSpacing: AppSpacing.s8,
          children: [
            Semantics(
              header: true,
              child: Text(experience.company, style: AppTextStyles.tileTitle),
            ),
            Text(
              '${experience.role} · ${experience.period}',
              style: AppTextStyles.timelineMeta,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            TagPill(experience.location),
            if (experience.isCurrent)
              const TagPill('Current', tone: TagTone.hot),
            for (final engagement in experience.engagements)
              TagPill(
                '${engagement.type.label} · ${engagement.start.label} – '
                '${engagement.end?.label ?? 'Present'}',
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        for (var i = 0; i < experience.highlights.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s10),
          _Highlight(experience.highlights[i]),
        ],
      ],
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: AppLayout.timelineBulletTop),
          child: ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.timelineBullet,
              ),
              child: SizedBox.square(dimension: AppLayout.timelineBulletSize),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}
