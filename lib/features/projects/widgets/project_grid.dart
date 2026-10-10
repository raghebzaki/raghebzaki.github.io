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

/// Index rows for the projects grid. With two columns the first (flagship)
/// project gets a full-width spotlight row and the rest pair up; with one
/// column every project gets its own row. e.g. (5, 2) → [[0], [1, 2], [3, 4]].
List<List<int>> projectRows(int count, int columns) {
  if (count <= 0) return const [];
  if (columns <= 1) {
    return [
      for (var i = 0; i < count; i++) [i],
    ];
  }
  return [
    [0],
    for (var start = 1; start < count; start += columns)
      [for (var i = start; i < start + columns && i < count; i++) i],
  ];
}

/// Flagship-first grid of [ProjectCard]s: a full-width spotlight card, then
/// equal-height pairs.
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
        return Column(
          spacing: AppLayout.gridGap,
          children: [
            for (final row in projectRows(projects.length, columns))
              if (row.length == 1 && (columns == 1 || row.first == 0))
                SizedBox(width: double.infinity, child: cardAt(row.first))
              else
                EqualHeightRow(
                  gap: AppLayout.gridGap,
                  children: [
                    for (var c = 0; c < columns; c++)
                      c < row.length ? cardAt(row[c]) : const SizedBox.shrink(),
                  ],
                ),
          ],
        );
      },
    );
  }
}
