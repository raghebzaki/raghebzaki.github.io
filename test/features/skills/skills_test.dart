import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/skill.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skill_card.dart';
import 'package:ragheb_portfolio/features/skills/widgets/skills_grid.dart';
import 'package:ragheb_portfolio/shared/widgets/glow_card.dart';

import '../../support/app_harness.dart';
import '../../support/settle.dart';

final tiles = const StaticPortfolioRepository().skills;

Finder card(int i) => find.byType(SkillCard).at(i);

void main() {
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
  });

  group('content', () {
    test('four tiles with the expected titles and visuals', () {
      expect(tiles.map((t) => t.title), [
        'Clean Architecture',
        'BLoC / Cubit',
        'APIs & Real-Time',
        'DevOps & Stores',
      ]);
      expect(tiles.map((t) => t.id).toSet(), hasLength(4));
      expect(tiles[0].visual, isA<LayerStack>());
      expect(tiles[1].visual, isA<StateFlow>());
      expect(tiles[2].visual, isA<TagPulse>());
      expect(tiles[3].visual, isA<StoreGrid>());
    });

    test('visuals are well formed', () {
      final layers = tiles[0].visual as LayerStack;
      expect(layers.layers, hasLength(3));
      for (final layer in layers.layers) {
        expect(layer.name, isNotEmpty);
        expect(layer.detail, isNotEmpty);
      }
      final flow = tiles[1].visual as StateFlow;
      expect(flow.steps, ['Event', 'Bloc', 'State']);
      expect(flow.activeIndex, inInclusiveRange(0, flow.steps.length - 1));
      expect(flow.caption, isNotEmpty);
      final pulse = tiles[2].visual as TagPulse;
      expect(pulse.hotTags, ['REST', 'WebSockets']);
      expect(pulse.neutralTags, ['JSON', 'Live updates']);
      expect(pulse.bars, hasLength(8));
      expect(pulse.bars.where((b) => b.highlighted), hasLength(3));
      final stores = tiles[3].visual as StoreGrid;
      expect(stores.stores, hasLength(4));
    });
  });

  group('layout', () {
    testWidgets('1440: 2x2, rows equally tall, at least 300', (tester) async {
      await pumpSection(tester, SectionId.skills);
      expect(find.byType(SkillCard), findsNWidgets(4));
      final r = [for (var i = 0; i < 4; i++) tester.getRect(card(i))];
      expect(r[1].top, r[0].top);
      expect(r[3].top, r[2].top);
      expect(r[2].top, greaterThan(r[0].bottom));
      expect(r[2].top - r[0].bottom, AppLayout.gridGap);
      expect(r[1].left - r[0].right, AppLayout.gridGap);
      expect(r[1].height, r[0].height);
      expect(r[3].height, r[2].height);
      for (final rect in r) {
        expect(rect.height, greaterThanOrEqualTo(300));
        expect(rect.width, closeTo(r[0].width, 0.01));
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

    testWidgets('diagram sits at the bottom of the card', (tester) async {
      await pumpSection(tester, SectionId.skills);
      // Card 1 (flow) is shorter than its row mate?  Whichever is shorter
      // must still end its content at the bottom padding.
      for (var i = 0; i < 4; i++) {
        final cardRect = tester.getRect(card(i));
        final content = tester.getRect(
          find.descendant(of: card(i), matching: find.byType(Column)).first,
        );
        expect(
          cardRect.bottom - content.bottom,
          closeTo(AppLayout.skillCardPadding, 0.01),
          reason: 'card $i',
        );
      }
    });
  });

  group('visuals', () {
    testWidgets('layer indents are 0 / 14 / 28', (tester) async {
      await pumpSection(tester, SectionId.skills);
      final left = [
        for (var i = 0; i < 3; i++)
          tester
              .getTopLeft(
                find.descendant(
                  of: card(0),
                  matching: find.byKey(ValueKey('layer-$i')),
                ),
              )
              .dx,
      ];
      expect(left[1] - left[0], 14);
      expect(left[2] - left[0], 28);
      final right = [
        for (var i = 0; i < 3; i++)
          tester
              .getTopRight(
                find.descendant(
                  of: card(0),
                  matching: find.byKey(ValueKey('layer-$i')),
                ),
              )
              .dx,
      ];
      expect(right[0] - right[1], 14);
      expect(right[0] - right[2], 28);
    });

    testWidgets('flow steps are in order Event -> Bloc -> State', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.skills);
      final xs = [
        for (final step in ['Event', 'Bloc', 'State'])
          tester
              .getTopLeft(
                find.descendant(of: card(1), matching: find.text(step)),
              )
              .dx,
      ];
      expect(xs[0], lessThan(xs[1]));
      expect(xs[1], lessThan(xs[2]));
      expect(
        find.descendant(
          of: card(1),
          matching: find.text(
            'Predictable, testable state across every screen.',
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('four store tiles', (tester) async {
      await pumpSection(tester, SectionId.skills);
      for (final store in [
        'Play Store',
        'App Store',
        'Huawei AppGallery',
        'Windows',
      ]) {
        expect(
          find.descendant(of: card(3), matching: find.text(store)),
          findsOneWidget,
        );
      }
    });

    testWidgets('API tags are shown', (tester) async {
      await pumpSection(tester, SectionId.skills);
      for (final tag in ['REST', 'WebSockets', 'JSON', 'Live updates']) {
        expect(
          find.descendant(of: card(2), matching: find.text(tag)),
          findsOneWidget,
        );
      }
    });
  });

  group('no overflow', () {
    for (final width in [360.0, 768.0, 1024.0, 1440.0]) {
      for (final scale in [1.0, 1.5]) {
        testWidgets('${width.toInt()}px at ${scale}x text', (tester) async {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await pumpSection(tester, SectionId.skills, size: Size(width, 900));
          expect(tester.takeException(), isNull);
          final rects = [for (var i = 0; i < 4; i++) tester.getRect(card(i))];
          for (final r in rects) {
            expect(r.height, greaterThanOrEqualTo(300));
          }
        });
      }
    }
  });

  testWidgets('hover highlights a skills card through GlowCard', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.skills);
    Color border() {
      final container = tester.widget<AnimatedContainer>(
        find
            .descendant(
              of: find.byType(GlowCard).first,
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      return ((container.foregroundDecoration! as BoxDecoration).border!
              as Border)
          .top
          .color;
    }

    final before = border();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(card(0)));
    await settle(tester);
    expect(border(), isNot(before));
    await mouse.moveTo(const Offset(2, 2));
    await settle(tester);
    expect(border(), before);
  });
}
