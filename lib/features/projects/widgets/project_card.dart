import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/glow_card.dart';
import '../../../shared/widgets/store_link_button.dart';
import '../../../shared/widgets/tag_pill.dart';
import 'app_icon_badge.dart';

/// Whether the badge sits at the right end of the header (rather than under
/// the title) for a header of [headerWidth].
bool badgeBesideTitle(double headerWidth) =>
    headerWidth >= AppLayout.projectBadgeBeside;

/// One featured project as an app-icon card, highlighted on hover or when
/// keyboard focus is inside (see [GlowCard]).
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, required this.flagship, super.key});

  final Project project;
  final bool flagship;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      color: AppColors.surface,
      gradient: flagship ? AppGradients.surfaceCard : null,
      builder: (context, _) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopGroup(project: project),
          _StoreRow(project: project),
        ],
      ),
    );
  }
}

class _TopGroup extends StatelessWidget {
  const _TopGroup({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s20,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => _Header(
            project: project,
            badgeBeside: badgeBesideTitle(constraints.maxWidth),
          ),
        ),
        Text(project.description, style: AppTextStyles.body),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: [
            for (final item in project.stack) TagPill(item),
            for (final platform in AppPlatform.values)
              if (project.platforms.contains(platform)) TagPill(platform.label),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.project, required this.badgeBeside});

  final Project project;
  final bool badgeBeside;

  @override
  Widget build(BuildContext context) {
    final nativeName = project.nativeName;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBadge(glyph: project.glyph, accent: project.accent),
        const SizedBox(width: AppSpacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.name, style: AppTextStyles.projectTitle),
              if (nativeName != null)
                Text(
                  nativeName,
                  style: AppTextStyles.nativeName,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.left,
                ),
              if (!badgeBeside) ...[
                const SizedBox(height: AppSpacing.s10),
                TagPill(project.badge, tone: TagTone.hot),
              ],
            ],
          ),
        ),
        if (badgeBeside) ...[
          const SizedBox(width: AppSpacing.s16),
          TagPill(project.badge, tone: TagTone.hot),
        ],
      ],
    );
  }
}

class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          const SizedBox(
            height: 1,
            child: ColoredBox(color: AppColors.borderSubtle),
          ),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            alignment: WrapAlignment.end,
            children: [
              for (final link in project.links)
                StoreLinkButton(ownerName: project.name, link: link),
            ],
          ),
        ],
      ),
    );
  }
}
