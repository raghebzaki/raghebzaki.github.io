import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/features/timeline/widgets/role_card.dart';
import 'package:ragheb_portfolio/shared/widgets/tag_pill.dart';

import '../../support/app_harness.dart';

final roles = const StaticPortfolioRepository().experience;

Finder get cards => find.byType(RoleCard);
Finder pill(String label) => find.widgetWithText(TagPill, label);

void main() {
  setUpAll(loadAppFonts);

  testWidgets('four cards in repository order with full company names', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline);
    expect(cards, findsNWidgets(4));
    expect(roles.map((r) => r.company), [
      'CloudSoft5',
      'Sutum ICT Consulting',
      'Coddiv',
      'Sejall Technology',
    ]);
    for (var i = 0; i < roles.length; i++) {
      expect(
        find.descendant(of: cards.at(i), matching: find.text(roles[i].company)),
        findsOneWidget,
      );
    }
    // Cards are stacked newest first.
    final tops = [
      for (var i = 0; i < 4; i++) tester.getTopLeft(cards.at(i)).dy,
    ];
    expect([...tops]..sort(), tops);
  });

  testWidgets('shows role and period for every card', (tester) async {
    await pumpSection(tester, SectionId.timeline);
    const periods = [
      'Dec 2024 – Present',
      'Sep 2024 – Jan 2025',
      'Jun 2023 – Sep 2025',
      'Aug 2021 – Dec 2021',
    ];
    for (var i = 0; i < periods.length; i++) {
      expect(
        find.descendant(
          of: cards.at(i),
          matching: find.text('Flutter Developer · ${periods[i]}'),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('only CloudSoft5 is marked Current', (tester) async {
    await pumpSection(tester, SectionId.timeline);
    final current = find.descendant(
      of: find.byType(RoleCard),
      matching: pill('Current'),
    );
    expect(current, findsOneWidget);
    expect(
      find.descendant(of: cards.at(0), matching: pill('Current')),
      findsOneWidget,
    );
  });

  testWidgets('Coddiv shows both engagement pills and locations', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline);
    final coddiv = cards.at(2);
    for (final label in [
      'Full-time · Jun 2023 – Dec 2024',
      'Part-time · Jan 2025 – Sep 2025',
      'Cairo, Egypt',
    ]) {
      expect(
        find.descendant(of: coddiv, matching: pill(label)),
        findsOneWidget,
      );
    }
    expect(
      find.descendant(of: cards.at(1), matching: pill('Saudi Arabia')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: cards.at(3), matching: pill('Giza, Egypt')),
      findsOneWidget,
    );
  });

  testWidgets('every highlight is rendered', (tester) async {
    await pumpSection(tester, SectionId.timeline);
    for (var i = 0; i < roles.length; i++) {
      for (final highlight in roles[i].highlights) {
        expect(
          find.descendant(of: cards.at(i), matching: find.text(highlight)),
          findsOneWidget,
          reason: highlight,
        );
      }
    }
  });

  testWidgets('dots are centered on the rail; the first one glows', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline);
    final rail = tester.getRect(find.byKey(const ValueKey('timeline-rail')));
    expect(rail.width, 2);
    for (var i = 0; i < 4; i++) {
      final dotFinder = find.byKey(ValueKey('timeline-dot-$i'));
      final dot = tester.getRect(dotFinder);
      expect(dot.size, const Size.square(12));
      expect(dot.center.dx, closeTo(rail.center.dx, 0.5));
      // 30px below the card top.
      expect(dot.top - tester.getTopLeft(cards.at(i)).dy, closeTo(30, 0.5));
      final decoration =
          tester.widget<DecoratedBox>(dotFinder).decoration as BoxDecoration;
      expect(
        decoration.color,
        [
          AppColors.cyan400,
          AppColors.sky400,
          AppColors.blue500,
          AppColors.blue700,
        ][i],
      );
      expect(
        decoration.boxShadow,
        i == 0 ? AppShadows.timelineDotActive : AppShadows.timelineDot,
      );
    }
  });

  group('no overflow', () {
    for (final width in [360.0, 768.0, 1440.0]) {
      for (final scale in [1.0, 1.5]) {
        testWidgets('${width.toInt()}px at ${scale}x text', (tester) async {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await pumpSection(tester, SectionId.timeline, size: Size(width, 900));
          expect(cards, findsWidgets);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
