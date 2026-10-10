import 'package:flutter/widgets.dart';

import '../../../core/responsive/responsive_value.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/skill.dart';
import '../../../shared/widgets/equal_height_row.dart';
import 'skill_card.dart';

/// Columns of the skills grid: CSS `repeat(auto-fit, minmax(380px, 1fr))`
/// capped at two.
int skillsColumns(double width) => AutoFit.columns(
  width,
  minTile: AppLayout.skillMinTile,
  gap: AppLayout.gridGap,
  maxColumns: 2,
);

/// The bento grid. Each row is an [EqualHeightRow], like CSS grid stretch.
class SkillsGrid extends StatelessWidget {
  const SkillsGrid({required this.tiles, super.key});

  final List<SkillTile> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = skillsColumns(constraints.maxWidth);
        final rows = <Widget>[];
        for (var start = 0; start < tiles.length; start += columns) {
          final end = start + columns < tiles.length
              ? start + columns
              : tiles.length;
          final cells = <Widget>[
            for (var i = start; i < end; i++)
              SkillCard(key: ValueKey(tiles[i].id), tile: tiles[i]),
            // Keep the last row's cells the same width as the others.
            for (var i = end - start; i < columns; i++) const SizedBox.shrink(),
          ];
          if (rows.isNotEmpty) {
            rows.add(const SizedBox(height: AppLayout.gridGap));
          }
          rows.add(EqualHeightRow(gap: AppLayout.gridGap, children: cells));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}
