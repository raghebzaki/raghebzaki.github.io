import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/features/shell/widgets/site_header.dart';

import '../support/app_harness.dart';
import '../support/settle.dart';

/// Regressions caught in the browser: the header nav sat mid-row and
/// start-aligned section headers were centered as a block.
void main() {
  const width = 1440.0;
  // Left/right edge of the padded 1200px content column.
  const columnLeft = (width - AppLayout.maxContent) / 2 + AppLayout.gutter;
  const columnRight = width - columnLeft;

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const PortfolioApp());
    await settle(tester);
  }

  testWidgets('header nav ends at the right edge of the content column', (
    tester,
  ) async {
    await pump(tester);
    final contact = find.descendant(
      of: find.byType(SiteHeader),
      matching: find.text('Contact'),
    );
    // NavLink adds 4px of horizontal padding around its label.
    expect(tester.getRect(contact).right, closeTo(columnRight - 4, 1));
  });

  testWidgets('section header starts at the left edge of the content column', (
    tester,
  ) async {
    await pump(tester);
    // The taller hero (avatar) pushes the Projects header below the first
    // viewport, where the list has not built it yet.
    navigationOf(tester).scrollTo(SectionId.projects);
    await settle(tester);
    final eyebrow = find.text('01 / FEATURED PROJECTS');
    expect(eyebrow, findsOneWidget);
    expect(tester.getRect(eyebrow).left, closeTo(columnLeft, 1));
  });
}
