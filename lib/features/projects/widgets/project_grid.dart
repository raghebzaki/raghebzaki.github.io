import 'package:flutter/widgets.dart';

import '../../../core/responsive/responsive_value.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/equal_height_row.dart';
import 'project_card.dart';

/// Columns for the projects grid: 1 or 2, mirroring
/// `repeat(auto-fit, minmax(min(540px, 100%), 1fr))` with a 20px gap.
int projectColumns(double width) => AutoFit.columns(
  width,
  minTile: AppLayout.projectMinTile,
  gap: AppLayout.gridGap,
  maxColumns: 2,
);

/// Flagship-first grid of [ProjectCard]s (the first project is the flagship).
class ProjectGrid extends StatelessWidget {
  const ProjectGrid({required this.projects, super.key});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = projectColumns(constraints.maxWidth);
        Widget cardAt(int index) =>
            ProjectCard(project: projects[index], flagship: index == 0);
        if (columns == 1) {
          return Column(
            spacing: AppLayout.gridGap,
            children: [
              for (var i = 0; i < projects.length; i++)
                SizedBox(width: double.infinity, child: cardAt(i)),
            ],
          );
        }
        return Column(
          spacing: AppLayout.gridGap,
          children: [
            for (var start = 0; start < projects.length; start += columns)
              EqualHeightRow(
                gap: AppLayout.gridGap,
                children: [
                  for (var c = 0; c < columns; c++)
                    start + c < projects.length
                        ? cardAt(start + c)
                        : const SizedBox.shrink(),
                ],
              ),
          ],
        );
      },
    );
  }
}
