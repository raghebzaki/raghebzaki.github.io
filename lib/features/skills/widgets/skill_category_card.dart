import 'package:flutter/widgets.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/skill.dart';
import '../../../shared/widgets/glow_card.dart';
import 'skill_icon_badge.dart';
import 'skill_pill.dart';
import 'skill_tone_style.dart';

/// One skill category: badge, title, subtitle, description and skill pills.
class SkillCategoryCard extends StatelessWidget {
  const SkillCategoryCard({required this.category, super.key});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    final style = toneStyle(category.tone);
    return GlowCard(
      padding: const EdgeInsets.all(AppLayout.skillCardPadding),
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SkillIconBadge(glyph: category.glyph, tone: category.tone),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      container: true,
                      child: Text(
                        category.title,
                        style: AppTextStyles.tileTitle,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      category.subtitle,
                      style: AppTextStyles.skillSubtitle.copyWith(
                        color: style.soft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(category.description, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.s20),
          Semantics(
            container: true,
            child: Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                for (final skill in category.skills)
                  SkillPill(skill, tone: category.tone),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
