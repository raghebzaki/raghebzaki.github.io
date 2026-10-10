import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'section_id.dart';

/// Picks the section the reader is currently in from the visible [positions].
///
/// [threshold] is the fraction of the viewport height below the top edge at
/// which a section counts as "reached".
SectionId? resolveActiveSection(
  Iterable<ItemPosition> positions, {
  double threshold = 0.35,
  int sectionCount = 6,
}) {
  if (positions.isEmpty) return null;
  final lastIndex = sectionCount - 1;

  // Bottom reached: the short footer section can never cross the threshold.
  for (final p in positions) {
    if (p.index == lastIndex && p.itemTrailingEdge <= 1.0 + 0.001) {
      return SectionId.values[lastIndex];
    }
  }

  ItemPosition? passed;
  ItemPosition? lowest;
  for (final p in positions) {
    if (lowest == null || p.index < lowest.index) lowest = p;
    if (p.itemLeadingEdge <= threshold &&
        (passed == null || p.index > passed.index)) {
      passed = p;
    }
  }
  final chosen = passed ?? lowest!;
  return SectionId.values[chosen.index.clamp(0, lastIndex)];
}
