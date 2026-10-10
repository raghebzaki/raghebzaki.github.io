import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';

void main() {
  test('fromPath resolves every path', () {
    for (final id in SectionId.values) {
      expect(SectionId.fromPath(id.path), id);
    }
  });

  test('fromPath normalises trailing slash and case', () {
    expect(SectionId.fromPath('/projects/'), SectionId.projects);
    expect(SectionId.fromPath('/SKILLS'), SectionId.skills);
  });

  test('unknown paths resolve to hero', () {
    expect(SectionId.fromPath('/nope'), SectionId.hero);
  });

  test('indices follow declaration order', () {
    for (var i = 0; i < SectionId.values.length; i++) {
      expect(SectionId.values[i].index, i);
    }
  });

  test('navItems are the five labelled sections', () {
    expect(SectionId.navItems.map((e) => e.navLabel), [
      'Projects',
      'Ecosystem',
      'Skills',
      'Timeline',
      'Contact',
    ]);
  });
}
