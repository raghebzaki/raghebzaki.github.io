import 'package:flutter/widgets.dart';

import '../../../core/responsive/responsive_value.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/project.dart';
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
        final rows = <Widget>[];
        for (var start = 0; start < projects.length; start += columns) {
          final cells = <Widget>[];
          for (var c = 0; c < columns; c++) {
            final index = start + c;
            if (c > 0) cells.add(const SizedBox(width: AppLayout.gridGap));
            cells.add(
              Expanded(
                child: index < projects.length
                    ? ProjectCard(
                        project: projects[index],
                        flagship: index == 0,
                      )
                    : const SizedBox.shrink(),
              ),
            );
          }
          if (rows.isNotEmpty) {
            rows.add(const SizedBox(height: AppLayout.gridGap));
          }
          rows.add(
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells),
          );
        }
        return Column(children: rows);
      },
    );
  }
}
