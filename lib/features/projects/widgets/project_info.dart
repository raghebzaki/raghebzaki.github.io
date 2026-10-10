import 'package:flutter/widgets.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/tag_pill.dart';
import 'store_link_button.dart';

/// The copy column of a project card: badge, title, summary, tags, stores.
class ProjectInfo extends StatelessWidget {
  const ProjectInfo({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final nativeName = project.nativeName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s16,
      children: [
        TagPill(project.badge, tone: TagTone.hot),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s4,
          children: [
            Text(project.name, style: AppTextStyles.cardTitle),
            if (nativeName != null)
              Text(
                nativeName,
                style: AppTextStyles.nativeName,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.left,
              ),
          ],
        ),
        Text(project.summary, style: AppTextStyles.body),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [for (final tag in project.tags) TagPill(tag)],
        ),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final link in project.links)
              StoreLinkButton(project: project, link: link),
          ],
        ),
      ],
    );
  }
}
