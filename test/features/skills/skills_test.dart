import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/skill.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skill_category_card.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skill_icon_badge.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skill_pill.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skill_tone_style.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skills_grid.dart';
import 'package:ragheb_portfolio/shared/widgets/app_icon.dart';

import '../../support/app_harness.dart';
import '../../support/settle.dart';

final categories = const StaticPortfolioRepository().skills;

Finder card(int i) => find.byType(SkillCategoryCard).at(i);

Finder pill(String label) => find.widgetWithText(SkillPill, label);

BoxDecoration pillDecoration(WidgetTester tester, Finder pillFinder) {
  final container = tester.widget<AnimatedContainer>(
    find.descendant(of: pillFinder, matching: find.byType(AnimatedContainer)),
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  // Regression (seen in the browser): pills stretched to the full card width,
  // one per row, instead of wrapping as compact chips.
  testWidgets('skill pills shrink-wrap and share rows', (tester) async {
    await pumpSection(tester, SectionId.skills, size: const Size(1440, 1800));
    final pills = find.byType(SkillPill);
    expect(pills, findsWidgets);
    final card = tester.getRect(find.byType(SkillCategoryCard).first);
    final first = tester.getRect(pills.first);
    final second = tester.getRect(pills.at(1));
    expect(first.width, lessThan(card.width / 2));
    expect(second.top, first.top, reason: 'first two pills share a row');
  });

  setUpAll(loadAppFonts);

  group('pure logic', () {
    test('skillsColumns', () {
      expect(skillsColumns(780), 2);
      expect(skillsColumns(779), 1);
      expect(skillsColumns(1152), 2);
      expect(skillsColumns(312), 1);
      for (var w = 0.0; w <= 3000; w += 10) {
        expect(skillsColumns(w), inInclusiveRange(1, 2), reason: '$w');
      }
    });

    test('toneStyle returns each tone accent and distinct values', () {
      expect(toneStyle(SkillTone.cyan).accent, AppColors.cyan400);
      expect(toneStyle(SkillTone.blue).accent, AppColors.blue400);
      expect(toneStyle(SkillTone.indigo).accent, AppColors.indigo400);
      expect(toneStyle(SkillTone.amber).accent, AppColors.amber400);
      expect(toneStyle(SkillTone.cyan).soft, AppColors.cyan300);
      expect(toneStyle(SkillTone.blue).soft, AppColors.blue300);
      expect(toneStyle(SkillTone.indigo).soft, AppColors.indigo300);
      expect(toneStyle(SkillTone.amber).soft, AppColors.amber300);
      final styles = SkillTone.values.map(toneStyle).toList();
      for (final pick in <Object Function(SkillToneStyle)>[
        (s) => s.accent,
        (s) => s.soft,
        (s) => s.badgeFill,
        (s) => s.badgeBorder,
        (s) => s.hoverBorder,
        (s) => s.hoverFill,
        (s) => s.hoverGlow.color,
      ]) {
        expect(styles.map(pick).toSet(), hasLength(SkillTone.values.length));
      }
      for (final style in styles) {
        expect(style.hoverGlow.blurRadius, 14);
        expect(style.hoverGlow.spreadRadius, -2);
      }
    });

    test('glyphs map to their icons', () {
      expect(skillGlyphIcon(SkillGlyph.architecture), AppIcon.layers);
      expect(skillGlyphIcon(SkillGlyph.database), AppIcon.database);
      expect(skillGlyphIcon(SkillGlyph.network), AppIcon.zap);
      expect(skillGlyphIcon(SkillGlyph.delivery), AppIcon.rocket);
      for (final glyph in SkillGlyph.values) {
        expect(skillGlyphIcon(glyph).assetPath, endsWith('.svg'));
      }
    });
  });

  group('content', () {
    test('four categories with exact copy, in order', () {
      expect(categories.map((c) => c.id), [
        'architecture',
        'data',
        'backend',
        'delivery',
      ]);
      expect(categories.map((c) => c.title), [
        'State Management & Architecture',
        'Database & Data Persistence',
        'Backend Integration & Real-Time',
        'DevOps, Testing & Deployment',
      ]);
      expect(categories.map((c) => c.subtitle), [
        'Scalable Architecture & Reactive State',
        'Local Storage & Offline Engines',
        'Resilient Networking & APIs',
        'Automated Delivery & Ecosystem',
      ]);
      expect(categories.map((c) => c.description), [
        'Architecting modular enterprise codebases with decoupled business '
            'logic and strict design patterns.',
        'Secure device-level data persistence paired with resilient '
            'offline-first synchronization.',
        'Robust API pipelines with custom interceptors, automated token '
            'refresh, and live WebSocket streaming.',
        'End-to-end continuous integration, automated store code signing, '
            'and live Over-The-Air patching.',
      ]);
    });

    test('exact skill lists', () {
      expect(categories[0].skills, [
        'Clean Architecture',
        'BLoC',
        'Cubit',
        'Provider',
        'SOLID Principles',
        'Design Patterns',
        'Modular Architecture',
        'Repository Pattern',
      ]);
      expect(categories[1].skills, [
        'SQLite',
        'Hive',
        'Floor',
        'Shared Preferences',
        'Secure Storage',
        'Offline Sync & Caching',
        'Encrypted Storage',
      ]);
      expect(categories[2].skills, [
        'REST APIs',
        'Dio',
        'HTTP',
        'WebSockets',
        'Firebase (FCM, Auth)',
        'JSON Serialization',
        'Interceptors',
      ]);
      expect(categories[3].skills, [
        'GitHub Actions',
        'Git & GitHub',
        'Fastlane',
        'Shorebird (OTA)',
        'Unit Testing (bloc_test)',
        'Widget Testing',
        'Google Play Console',
        'App Store Connect',
        'Huawei AppGallery',
        'Postman',
        'Swagger',
        'Figma',
      ]);
      expect(categories.map((c) => c.skills.length), [8, 7, 7, 12]);
      for (final c in categories) {
        expect(c.skills.toSet(), hasLength(c.skills.length), reason: c.id);
      }
    });

    test('tones and glyphs', () {
      expect(categories.map((c) => c.tone), SkillTone.values);
      expect(categories.map((c) => c.glyph), SkillGlyph.values);
    });
  });

  group('layout', () {
    testWidgets('1440: 2x2 with equal-height rows', (tester) async {
      await pumpSection(tester, SectionId.skills);
      expect(find.byType(SkillCategoryCard), findsNWidgets(4));
      final r = [for (var i = 0; i < 4; i++) tester.getRect(card(i))];
      expect(r[1].top, closeTo(r[0].top, 0.5));
      expect(r[3].top, closeTo(r[2].top, 0.5));
      expect(r[2].top - r[0].bottom, closeTo(AppLayout.gridGap, 0.5));
      expect(r[1].left - r[0].right, closeTo(AppLayout.gridGap, 0.5));
      expect(r[1].height, closeTo(r[0].height, 0.5));
      expect(r[3].height, closeTo(r[2].height, 0.5));
      for (final rect in r) {
        expect(rect.width, closeTo(r[0].width, 0.5));
      }
    });

    testWidgets('900: two columns', (tester) async {
      await pumpSection(tester, SectionId.skills, size: const Size(900, 900));
      expect(tester.getTopLeft(card(1)).dy, tester.getTopLeft(card(0)).dy);
      expect(
        tester.getTopLeft(card(2)).dy,
        greaterThan(tester.getTopLeft(card(0)).dy),
      );
    });

    for (final width in [768.0, 360.0]) {
      testWidgets('${width.toInt()}: one column', (tester) async {
        await pumpSection(tester, SectionId.skills, size: Size(width, 900));
        for (var i = 1; i < 4; i++) {
          expect(
            tester.getTopLeft(card(i)).dy,
            greaterThan(tester.getBottomLeft(card(i - 1)).dy - 0.01),
          );
          expect(tester.getTopLeft(card(i)).dx, tester.getTopLeft(card(0)).dx);
        }
      });
    }

    for (final width in [360.0, 768.0, 1024.0, 1440.0]) {
      for (final scale in [1.0, 1.5]) {
        testWidgets('no overflow at ${width.toInt()}px, ${scale}x text', (
          tester,
        ) async {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await pumpSection(tester, SectionId.skills, size: Size(width, 900));
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('rendering', () {
    testWidgets('every title, subtitle, description and skill is shown', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.skills);
      for (var i = 0; i < categories.length; i++) {
        final c = categories[i];
        for (final text in [c.title, c.subtitle, c.description]) {
          expect(
            find.descendant(of: card(i), matching: find.text(text)),
            findsOneWidget,
            reason: text,
          );
        }
        for (final skill in c.skills) {
          expect(
            find.descendant(of: card(i), matching: find.text(skill)),
            findsOneWidget,
            reason: skill,
          );
        }
        expect(
          find.descendant(of: card(i), matching: find.byType(SkillPill)),
          findsNWidgets(c.skills.length),
        );
      }
      expect(find.byType(SkillPill), findsNWidgets(34));
    });

    testWidgets('each card has its icon badge', (tester) async {
      await pumpSection(tester, SectionId.skills);
      const icons = [
        AppIcon.layers,
        AppIcon.database,
        AppIcon.zap,
        AppIcon.rocket,
      ];
      for (var i = 0; i < 4; i++) {
        final badge = find.descendant(
          of: card(i),
          matching: find.byType(SkillIconBadge),
        );
        expect(badge, findsOneWidget);
        expect(tester.widget<SkillIconBadge>(badge).tone, categories[i].tone);
        final icon = tester.widget<AppIconView>(
          find.descendant(of: badge, matching: find.byType(AppIconView)),
        );
        expect(icon.icon, icons[i]);
        expect(icon.color, toneStyle(categories[i].tone).accent);
        expect(tester.getSize(badge), const Size.square(48));
      }
    });

    testWidgets('titles are semantic headers', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpSection(tester, SectionId.skills);
      for (final c in categories) {
        expect(
          tester.getSemantics(find.text(c.title)),
          matchesSemantics(label: c.title, isHeader: true),
        );
      }
      handle.dispose();
    });

    testWidgets('the old diagram widgets are gone', (tester) async {
      await pumpSection(tester, SectionId.skills);
      for (final name in [
        'LayerStackView',
        'StateFlowView',
        'TagPulseView',
        'StoreGridView',
        'SkillCard',
      ]) {
        expect(
          find.byWidgetPredicate((w) => w.runtimeType.toString() == name),
          findsNothing,
          reason: name,
        );
      }
    });
  });

  group('hover', () {
    Future<TestGesture> mouse(WidgetTester tester) async {
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(2, 2));
      addTearDown(gesture.removePointer);
      return gesture;
    }

    testWidgets('hovering a pill shows the tone border, fill and glow', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.skills, size: const Size(1440, 1800));
      final target = pill('Dio');
      final style = toneStyle(SkillTone.indigo);
      var decoration = pillDecoration(tester, target);
      final restBorder = (decoration.border! as Border).top.color;
      expect(restBorder, AppColors.borderTag);
      expect(decoration.boxShadow, isEmpty);

      final gesture = await mouse(tester);
      await gesture.moveTo(tester.getCenter(target));
      await settle(tester);
      decoration = pillDecoration(tester, target);
      expect((decoration.border! as Border).top.color, style.hoverBorder);
      expect(decoration.color, style.hoverFill);
      expect(decoration.boxShadow, [style.hoverGlow]);

      await gesture.moveTo(const Offset(2, 2));
      await settle(tester);
      decoration = pillDecoration(tester, target);
      expect((decoration.border! as Border).top.color, restBorder);
      expect(decoration.boxShadow, isEmpty);
    });

    testWidgets('with disableAnimations the change is immediate', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpSection(tester, SectionId.skills);
      final target = pill('Hive');
      final gesture = await mouse(tester);
      await gesture.moveTo(tester.getCenter(target));
      await tester.pump();
      final decoration = pillDecoration(tester, target);
      expect(
        (decoration.border! as Border).top.color,
        toneStyle(SkillTone.blue).hoverBorder,
      );
      expect(decoration.boxShadow, isNotEmpty);
      await gesture.moveTo(const Offset(2, 2));
      await tester.pump();
      expect(pillDecoration(tester, target).boxShadow, isEmpty);
    });
  });
}
