import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/project.dart';
import 'package:ragheb_portfolio/features/projects/widgets/app_icon_badge.dart';
import 'package:ragheb_portfolio/features/projects/widgets/project_card.dart';
import 'package:ragheb_portfolio/features/projects/widgets/project_grid.dart';
import 'package:ragheb_portfolio/features/shell/cubit/navigation_cubit.dart';
import 'package:ragheb_portfolio/features/shell/portfolio_page.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/shared/widgets/app_button.dart';
import 'package:ragheb_portfolio/shared/widgets/app_icon.dart';
import 'package:ragheb_portfolio/shared/widgets/store_link_button.dart';
import 'package:ragheb_portfolio/shared/widgets/tag_pill.dart';
import 'package:url_launcher/link.dart';

import '../../support/app_harness.dart';
import '../../support/settle.dart';

const repo = StaticPortfolioRepository();
final projects = repo.featuredProjects;

Future<void> pumpProjects(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
}) => pumpSection(tester, SectionId.projects, size: size);

Finder card(int i) => find.byType(ProjectCard).at(i);

Finder inCard(int i, Finder matching) =>
    find.descendant(of: card(i), matching: matching);

AnimatedContainer frameOf(WidgetTester tester, int i) => tester
    .widget<AnimatedContainer>(inCard(i, find.byType(AnimatedContainer)).first);

Color borderColorOf(WidgetTester tester, int i) {
  final decoration = frameOf(tester, i).foregroundDecoration! as BoxDecoration;
  return (decoration.border! as Border).top.color;
}

/// Bottom of the store buttons' wrap in card [i].
double storeBottom(WidgetTester tester, int i) => inCard(i, find.byType(Link))
    .evaluate()
    .map((e) => tester.getRect(find.byWidget(e.widget)).bottom)
    .reduce((a, b) => a > b ? a : b);

void main() {
  setUpAll(loadAppFonts);

  group('pure logic', () {
    test('projectColumns', () {
      expect(projectColumns(1100), 2);
      expect(projectColumns(1099), 1);
      expect(projectColumns(1152), 2);
      expect(projectColumns(342), 1);
      for (var w = 0.0; w <= 3000; w += 10) {
        expect(projectColumns(w), inInclusiveRange(1, 2), reason: '$w');
      }
    });

    test('badgeBesideTitle', () {
      expect(badgeBesideTitle(420), isTrue);
      expect(badgeBesideTitle(419), isFalse);
    });

    test('glyphIcon maps every glyph', () {
      const expected = {
        ProjectGlyph.cart: AppIcon.cart,
        ProjectGlyph.modules: AppIcon.board,
        ProjectGlyph.register: AppIcon.ledger,
        ProjectGlyph.members: AppIcon.users,
      };
      expect(expected.keys, unorderedEquals(ProjectGlyph.values));
      for (final glyph in ProjectGlyph.values) {
        expect(glyphIcon(glyph), expected[glyph], reason: '$glyph');
      }
    });

    test('storeShortLabel', () {
      expect(storeShortLabel(StoreType.playStore), 'Play Store');
      expect(storeShortLabel(StoreType.appStore), 'App Store');
      expect(storeShortLabel(StoreType.appGallery), 'AppGallery');
      expect(storeShortLabel(StoreType.windows), 'Windows');
    });
  });

  group('content', () {
    test('store links are absolute https on the right hosts', () {
      const hosts = {
        StoreType.playStore: 'play.google.com',
        StoreType.appStore: 'apps.apple.com',
        StoreType.appGallery: 'appgallery.huawei.com',
        StoreType.windows: 'www.sutumatic.com',
      };
      for (final p in projects) {
        for (final l in p.links) {
          final uri = Uri.parse(l.url);
          expect(uri.isAbsolute, isTrue, reason: l.url);
          expect(uri.scheme, 'https', reason: l.url);
          expect(uri.host, hosts[l.store], reason: l.url);
        }
      }
    });

    test('stack pills and glyphs', () {
      expect(projects.map((p) => p.stack), [
        ['E-Commerce', 'Payment integration', 'Real-time order tracking'],
        ['ERP', 'ERPplus5.com integration', 'HR · CRM · Accounting'],
        ['Retail POS', 'Real-time inventory', 'Offline/online sales reporting'],
        ['Member portal', 'Digital requests', 'Service tracking'],
      ]);
      expect(projects.map((p) => p.glyph), [
        ProjectGlyph.cart,
        ProjectGlyph.modules,
        ProjectGlyph.register,
        ProjectGlyph.members,
      ]);
    });
  });

  group('layout', () {
    testWidgets('1440: two columns, equal heights, store rows aligned', (
      tester,
    ) async {
      await pumpProjects(tester);
      expect(find.byType(ProjectCard), findsNWidgets(4));
      final dy0 = tester.getTopLeft(card(0)).dy;
      expect(tester.getTopLeft(card(1)).dy, dy0);
      expect(tester.getTopLeft(card(2)).dy, greaterThan(dy0));
      expect(tester.getTopLeft(card(2)).dy, tester.getTopLeft(card(3)).dy);
      for (final (a, b) in [(0, 1), (2, 3)]) {
        expect(
          tester.getSize(card(a)).height,
          closeTo(tester.getSize(card(b)).height, 0.5),
        );
        expect(
          storeBottom(tester, a),
          closeTo(storeBottom(tester, b), 0.5),
          reason: 'row $a/$b',
        );
      }
    });

    testWidgets('1024 and 768: one column', (tester) async {
      for (final width in [1024.0, 768.0]) {
        await pumpProjects(tester, size: Size(width, 900));
        expect(
          tester.getTopLeft(card(1)).dy,
          greaterThan(tester.getTopLeft(card(0)).dy),
          reason: '$width',
        );
        expect(tester.takeException(), isNull);
      }
    });

    for (final width in [390.0, 360.0]) {
      testWidgets('${width.toInt()}: one column, no overflow', (tester) async {
        await pumpProjects(tester, size: Size(width, 800));
        for (var i = 0; i < 4; i++) {
          expect(tester.getTopLeft(card(i)).dx, tester.getTopLeft(card(0)).dx);
          expect(tester.getRect(card(i)).right, lessThanOrEqualTo(width));
        }
        expect(tester.takeException(), isNull);
      });
    }

    for (final width in [360.0, 768.0, 1024.0, 1440.0]) {
      testWidgets('${width.toInt()}: no overflow', (tester) async {
        await pumpProjects(tester, size: Size(width, 900));
        expect(tester.takeException(), isNull);
        for (final id in [SectionId.hero, SectionId.projects]) {
          BlocProvider.of<NavigationCubit>(
            tester.element(find.byType(PortfolioPage)),
          ).scrollTo(id);
          await settle(tester);
          expect(tester.takeException(), isNull);
        }
      });
    }
  });

  group('content in cards', () {
    testWidgets('shows copy, pills and the Arabic name', (tester) async {
      await pumpProjects(tester);
      for (var i = 0; i < 4; i++) {
        final p = projects[i];
        for (final text in [p.badge, p.name, p.description]) {
          expect(inCard(i, find.text(text)), findsOneWidget, reason: text);
        }
        for (final pill in [
          ...p.stack,
          for (final platform in p.platforms) platform.label,
        ]) {
          expect(
            inCard(i, find.widgetWithText(TagPill, pill)),
            findsOneWidget,
            reason: '${p.id}: $pill',
          );
        }
        if (p.nativeName != null) {
          final native = tester.widget<Text>(
            inCard(i, find.text(p.nativeName!)),
          );
          expect(native.textDirection, TextDirection.rtl);
        }
      }
    });

    testWidgets('badge is beside the title in wide cards only', (tester) async {
      await pumpProjects(tester);
      var badge = tester.getRect(inCard(0, find.text(projects[0].badge)));
      var title = tester.getRect(inCard(0, find.text(projects[0].name)));
      expect(badge.left, greaterThan(title.right));
      expect(badge.top, lessThan(title.bottom));

      await pumpProjects(tester, size: const Size(390, 800));
      badge = tester.getRect(inCard(0, find.text(projects[0].badge)));
      title = tester.getRect(inCard(0, find.text(projects[0].name)));
      expect(badge.top, greaterThanOrEqualTo(title.bottom));
    });

    testWidgets('no phone mockup exists', (tester) async {
      await pumpProjects(tester);
      expect(find.byType(AppIconBadge), findsNWidgets(4));
      expect(
        find.byWidgetPredicate((w) => w.runtimeType.toString() == 'PhoneFrame'),
        findsNothing,
      );
    });
  });

  group('store buttons', () {
    testWidgets('match the data and open in a new tab', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpProjects(tester);
      for (var i = 0; i < 4; i++) {
        final p = projects[i];
        final links = tester
            .widgetList<Link>(inCard(i, find.byType(Link)))
            .toList();
        expect(links, hasLength(p.links.length));
        expect(links.length, [2, 3, 3, 2][i]);
        for (var j = 0; j < links.length; j++) {
          expect(links[j].uri, Uri.parse(p.links[j].url));
          expect(links[j].target, LinkTarget.blank);
          final label = storeShortLabel(p.links[j].store);
          expect(find.bySemanticsLabel('${p.name} on $label'), findsOneWidget);
        }
      }
      expect(
        inCard(2, find.widgetWithText(TagPill, 'Huawei')),
        findsOneWidget,
        reason: 'pill only',
      );
      expect(
        inCard(2, find.widgetWithText(AppButton, 'AppGallery')),
        findsNothing,
      );
      expect(inCard(1, find.text('AppGallery')), findsOneWidget);
      handle.dispose();
    });
  });

  group('interaction', () {
    testWidgets('hover highlights the card', (tester) async {
      await pumpProjects(tester);
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(1, 1));
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(card(0)));
      await settle(tester);

      expect(borderColorOf(tester, 0), AppColors.cyanBorderHover);
      expect(borderColorOf(tester, 1), AppColors.borderSubtle);

      await gesture.moveTo(const Offset(1, 1));
      await settle(tester);
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);
    });

    testWidgets('keyboard focus inside a card highlights it', (tester) async {
      await pumpProjects(tester);
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);

      final label = find.descendant(
        of: inCard(0, find.byType(StoreLinkButton)).first,
        matching: find.text('Play Store'),
      );
      Focus.of(tester.element(label)).requestFocus();
      await settle(tester);

      expect(borderColorOf(tester, 0), AppColors.cyanBorderHover);
      expect(borderColorOf(tester, 1), AppColors.borderSubtle);

      FocusManager.instance.primaryFocus!.unfocus();
      await settle(tester);
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);
    });
  });
}
