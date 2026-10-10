import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/features/ecosystem/widgets/app_chip.dart';
import 'package:ragheb_portfolio/features/ecosystem/widgets/app_chip_cloud.dart';
import 'package:ragheb_portfolio/features/ecosystem/widgets/ecosystem_filter_bar.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';

import '../../support/app_harness.dart';
import '../../support/settle.dart';

final ecosystem = const StaticPortfolioRepository().ecosystem;
final names = [for (final family in ecosystem.families) ...family.apps];

Finder chip(String name) => find.widgetWithText(AppChip, name);

/// Alpha of the chip's rendered (animated) border.
double alphaOf(WidgetTester tester, String name) {
  final boxes = tester.widgetList<DecoratedBox>(
    find.descendant(of: chip(name), matching: find.byType(DecoratedBox)),
  );
  final decoration = boxes
      .map((box) => box.decoration)
      .whereType<BoxDecoration>()
      .firstWhere((d) => d.border != null);
  return (decoration.border! as Border).top.color.a;
}

Finder innerBox(String name) => find
    .descendant(of: chip(name), matching: find.byType(AnimatedContainer))
    .last;

Finder option(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(InkWell));

Future<void> select(WidgetTester tester, String label) async {
  await tester.tap(option(label));
  await settle(tester);
}

void main() {
  setUpAll(loadAppFonts);

  group('content', () {
    testWidgets('exactly the 34 data names as chips, in order', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      final shown = [
        for (final w in tester.widgetList<AppChip>(find.byType(AppChip)))
          w.label,
      ];
      expect(names, hasLength(34));
      expect(shown, names);
    });

    testWidgets('three filter options with their counts', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      final bar = find.byType(EcosystemFilterBar);
      for (final text in [
        'All',
        '32+',
        'CloudSoft5 ERP',
        '22+',
        'Service Center',
        '10+',
      ]) {
        expect(
          find.descendant(of: bar, matching: find.text(text)),
          findsOneWidget,
          reason: text,
        );
      }
      expect(
        find.descendant(of: bar, matching: find.byType(InkWell)),
        findsNWidgets(3),
      );
    });

    testWidgets('title, summary and eyebrow come from data', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      expect(find.text('02 / ENTERPRISE ECOSYSTEM'), findsOneWidget);
      expect(find.text(ecosystem.summary), findsOneWidget);
      expect(find.textContaining('One engineering system, '), findsOneWidget);
    });
  });

  group('filtering', () {
    testWidgets('ERP keeps 24 at full strength and dims 10', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      await select(tester, 'CloudSoft5 ERP');
      final erp = ecosystem.families[0].apps;
      final sc = ecosystem.families[1].apps;
      for (final name in erp) {
        expect(alphaOf(tester, name), closeTo(AppColors.chipErpBorder.a, 0.01));
      }
      for (final name in sc) {
        expect(
          alphaOf(tester, name),
          closeTo(AppColors.chipScBorder.a * AppOpacity.chipDimmed, 0.01),
        );
      }
    });

    testWidgets('Service Center does the reverse, All restores', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.ecosystem);
      await select(tester, 'Service Center');
      expect(
        alphaOf(tester, 'HR ERP+ Tracking'),
        closeTo(AppColors.chipErpBorder.a * AppOpacity.chipDimmed, 0.01),
      );
      expect(alphaOf(tester, 'CIT'), closeTo(AppColors.chipScBorder.a, 0.01));
      await select(tester, 'All');
      expect(
        alphaOf(tester, 'HR ERP+ Tracking'),
        closeTo(AppColors.chipErpBorder.a, 0.01),
      );
      expect(alphaOf(tester, 'CIT'), closeTo(AppColors.chipScBorder.a, 0.01));
    });

    testWidgets('chip positions never change', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      Map<String, Offset> positions() => {
        for (final name in names) name: tester.getTopLeft(chip(name)),
      };
      final before = positions();
      await select(tester, 'CloudSoft5 ERP');
      expect(positions(), before);
      await select(tester, 'Service Center');
      expect(positions(), before);
    });

    testWidgets('the filter survives scrolling away and back', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      await select(tester, 'Service Center');
      navigationOf(tester).scrollTo(SectionId.contact);
      await settle(tester);
      navigationOf(tester).scrollTo(SectionId.ecosystem);
      await settle(tester);
      expect(
        alphaOf(tester, 'HR ERP+ Tracking'),
        closeTo(AppColors.chipErpBorder.a * AppOpacity.chipDimmed, 0.01),
      );
      expect(alphaOf(tester, 'CIT'), closeTo(AppColors.chipScBorder.a, 0.01));
    });
  });

  group('accessibility', () {
    testWidgets('selected option, hidden dimmed chips, announcement', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSection(tester, SectionId.ecosystem);

      expect(find.bySemanticsLabel('Filter apps'), findsOneWidget);
      expect(find.bySemanticsLabel('Showing all 34 apps'), findsOneWidget);
      final all = tester.getSemantics(option('All'));
      expect(all.label, contains('All'));
      expect(all.label, contains('32+'));
      expect(all.flagsCollection.isSelected, Tristate.isTrue);
      expect(all.flagsCollection.isChecked, CheckedState.isTrue);
      expect(all.flagsCollection.isInMutuallyExclusiveGroup, isTrue);

      await select(tester, 'CloudSoft5 ERP');
      expect(
        find.bySemanticsLabel('Showing 24 CloudSoft5 ERP apps'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Showing all 34 apps'), findsNothing);
      expect(
        tester
            .getSemantics(option('CloudSoft5 ERP'))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      expect(
        tester.getSemantics(option('All')).flagsCollection.isSelected,
        Tristate.isFalse,
      );

      // Full-strength chips are announced, dimmed ones are not.
      final announced = tester
          .getSemantics(
            find.descendant(
              of: find.byType(AppChipCloud),
              matching: find.byType(Wrap),
            ),
          )
          .label
          .split('\n');
      expect(announced, ecosystem.families[0].apps);
      handle.dispose();
    });

    testWidgets('Tab then Enter selects a filter', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      // Focus the first option, then Tab to the second.
      Focus.of(tester.element(find.text('All'))).requestFocus();
      await settle(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await settle(tester);
      expect(
        alphaOf(tester, 'CIT'),
        closeTo(AppColors.chipScBorder.a * AppOpacity.chipDimmed, 0.01),
      );
      expect(
        alphaOf(tester, 'HR ERP+ Tracking'),
        closeTo(AppColors.chipErpBorder.a, 0.01),
      );
    });
  });

  group('motion', () {
    testWidgets('reduced motion: dimming is instant', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpSection(tester, SectionId.ecosystem);
      await tester.tap(option('CloudSoft5 ERP'));
      await tester.pump();
      expect(
        alphaOf(tester, 'CIT'),
        closeTo(AppColors.chipScBorder.a * AppOpacity.chipDimmed, 0.01),
      );
    });

    testWidgets('animated dimming is not instant', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      await tester.tap(option('CloudSoft5 ERP'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final mid = alphaOf(tester, 'CIT');
      expect(mid, lessThan(AppColors.chipScBorder.a));
      expect(
        mid,
        greaterThan(AppColors.chipScBorder.a * AppOpacity.chipDimmed),
      );
      await settle(tester);
    });

    testWidgets('mouse hover lifts a chip by 2px', (tester) async {
      await pumpSection(tester, SectionId.ecosystem);
      double lift() {
        final container = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: chip('Clubs App'),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        return container.transform?.getTranslation().y ?? 0;
      }

      expect(lift(), 0);
      final top = tester.getTopLeft(innerBox('Clubs App'));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(chip('Clubs App')));
      await settle(tester);
      expect(lift(), -AppLayout.chipLift);
      expect(tester.getTopLeft(innerBox('Clubs App')).dy, top.dy - 2);
      await mouse.moveTo(const Offset(2, 2));
      await settle(tester);
      expect(lift(), 0);
    });

    testWidgets('hover highlights the ecosystem card through GlowCard', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.ecosystem);
      final card = find.ancestor(
        of: find.byType(EcosystemFilterBar),
        matching: find.byType(AnimatedContainer),
      );
      Color border() {
        final c = tester.widget<AnimatedContainer>(card.last);
        return ((c.foregroundDecoration! as BoxDecoration).border! as Border)
            .top
            .color;
      }

      expect(border(), AppColors.borderSubtle);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(chip('Clubs App')));
      await settle(tester);
      expect(border(), AppColors.cyanBorderHover);
    });
  });

  group('header layout', () {
    testWidgets('1440: title block and filter share a row, bottoms aligned', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.ecosystem);
      final summary = tester.getRect(find.text(ecosystem.summary));
      final bar = tester.getRect(find.byType(EcosystemFilterBar));
      expect(bar.left, greaterThan(summary.right));
      expect(bar.bottom, closeTo(summary.bottom, 1));
    });

    testWidgets('768: the filter sits below the title block', (tester) async {
      await pumpSection(
        tester,
        SectionId.ecosystem,
        size: const Size(768, 900),
      );
      final summary = tester.getRect(find.text(ecosystem.summary));
      final bar = tester.getRect(find.byType(EcosystemFilterBar));
      expect(bar.top, greaterThanOrEqualTo(summary.bottom));
    });
  });

  group('no overflow', () {
    for (final width in [360.0, 390.0, 768.0, 1024.0, 1440.0]) {
      testWidgets('${width.toInt()}px', (tester) async {
        await pumpSection(tester, SectionId.ecosystem, size: Size(width, 900));
        expect(tester.takeException(), isNull);
        await select(tester, 'Service Center');
        expect(tester.takeException(), isNull);
      });
    }
  });
}
