import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/features/hero/widgets/stats_bar.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';

import '../../support/app_harness.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final scale in [1.0, 2.0]) {
    testWidgets('row cells are equal height at ${scale}x text', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpSection(tester, SectionId.hero);

      final cells = find.descendant(
        of: find.byType(StatsBar),
        matching: find.byWidgetPredicate(
          (w) => w is ColoredBox && w.color == AppColors.surfaceRaised,
        ),
      );
      expect(cells, findsNWidgets(3));
      final rects = [for (var i = 0; i < 3; i++) tester.getRect(cells.at(i))];
      expect(rects[1].top, rects[0].top);
      expect(rects[2].top, rects[0].top);
      expect(rects[1].height, rects[0].height);
      expect(rects[2].height, rects[0].height);
      // 1px dividers between cells.
      expect(rects[1].left - rects[0].right, closeTo(1, 0.001));
      expect(rects[2].left - rects[1].right, closeTo(1, 0.001));
      expect(tester.takeException(), isNull);
    });
  }
}
