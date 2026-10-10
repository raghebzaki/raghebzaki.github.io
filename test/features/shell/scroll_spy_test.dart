import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/features/shell/scroll_spy.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

ItemPosition p(int index, double leading, double trailing) => ItemPosition(
  index: index,
  itemLeadingEdge: leading,
  itemTrailingEdge: trailing,
);

void main() {
  test('empty returns null', () {
    expect(resolveActiveSection(const []), isNull);
  });

  test('hero at top is hero', () {
    expect(resolveActiveSection([p(0, 0, 0.9)]), SectionId.hero);
  });

  test('projects past the threshold wins', () {
    expect(
      resolveActiveSection([p(0, -0.6, 0.3), p(1, 0.3, 1.4)]),
      SectionId.projects,
    );
  });

  test('projects below the threshold keeps hero', () {
    expect(
      resolveActiveSection([p(0, -0.5, 0.4), p(1, 0.4, 1.5)]),
      SectionId.hero,
    );
  });

  test('bottom reached resolves to contact', () {
    expect(
      resolveActiveSection([p(4, 0.2, 0.7), p(5, 0.7, 1.0)]),
      SectionId.contact,
    );
  });

  test('none past threshold falls back to the lowest visible', () {
    expect(
      resolveActiveSection([p(2, 0.5, 1.2), p(3, 1.2, 2.0)]),
      SectionId.ecosystem,
    );
  });
}
