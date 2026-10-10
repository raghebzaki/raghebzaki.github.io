import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/project.dart';
import 'package:ragheb_portfolio/features/projects/accent_style.dart';
import 'package:ragheb_portfolio/features/projects/widgets/mockups/erp_modules_screen.dart';
import 'package:ragheb_portfolio/features/projects/widgets/mockups/member_portal_screen.dart';
import 'package:ragheb_portfolio/features/projects/widgets/mockups/mockup_for.dart';
import 'package:ragheb_portfolio/features/projects/widgets/mockups/pos_register_screen.dart';
import 'package:ragheb_portfolio/features/projects/widgets/mockups/storefront_screen.dart';
import 'package:ragheb_portfolio/features/projects/widgets/phone_frame.dart';
import 'package:ragheb_portfolio/features/projects/widgets/project_card.dart';
import 'package:ragheb_portfolio/features/projects/widgets/project_grid.dart';
import 'package:ragheb_portfolio/features/projects/widgets/project_info.dart';
import 'package:ragheb_portfolio/features/projects/widgets/store_link_button.dart';
import 'package:ragheb_portfolio/features/shell/cubit/navigation_cubit.dart';
import 'package:ragheb_portfolio/features/shell/portfolio_page.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/shared/widgets/tag_pill.dart';
import 'package:url_launcher/link.dart';

const repo = StaticPortfolioRepository();
final projects = repo.featuredProjects;

Future<void> pumpProjects(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle();
  BlocProvider.of<NavigationCubit>(tester.element(find.byType(PortfolioPage)))
      .scrollTo(SectionId.projects);
  await tester.pumpAndSettle();
}

Finder card(int i) => find.byType(ProjectCard).at(i);

Finder inCard(int i, Finder matching) =>
    find.descendant(of: card(i), matching: matching);

AnimatedContainer frameOf(WidgetTester tester, int i) => tester
    .widget<AnimatedContainer>(inCard(i, find.byType(AnimatedContainer)).first);

Color borderColorOf(WidgetTester tester, int i) {
  final decoration = frameOf(tester, i).foregroundDecoration! as BoxDecoration;
  return (decoration.border! as Border).top.color;
}

Finder phoneTransform() =>
    find.byWidgetPredicate((w) => w is Transform && w.child is RepaintBoundary);

Transform phoneTransformOf(WidgetTester tester, int i) =>
    tester.widget<Transform>(
      find.descendant(of: card(i), matching: phoneTransform()),
    );

/// flutter_test renders every font as Ahem unless the app fonts are loaded;
/// pixel-exact card heights need the real metrics.
Future<void> loadAppFonts() async {
  const families = <String, List<String>>{
    'Geist': ['Regular', 'Medium', 'SemiBold', 'Bold'],
    'GeistMono': ['Regular', 'Medium'],
    'NotoSansArabic': ['Regular', 'Bold'],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final weight in entry.value) {
      loader.addFont(rootBundle.load('assets/fonts/${entry.key}-$weight.ttf'));
    }
    await loader.load();
  }
}

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

    test('phoneBesideText', () {
      expect(phoneBesideText(456), isTrue);
      expect(phoneBesideText(455), isFalse);
    });

    test('phoneShadowFor', () {
      expect(phoneShadowFor(AccentTone.cyan), AppShadows.phoneCyan);
      expect(phoneShadowFor(AccentTone.blue), AppShadows.phoneBlue);
    });

    test('storeShortLabel', () {
      expect(storeShortLabel(StoreType.playStore), 'Play Store');
      expect(storeShortLabel(StoreType.appStore), 'App Store');
      expect(storeShortLabel(StoreType.appGallery), 'AppGallery');
      expect(storeShortLabel(StoreType.windows), 'Windows');
    });

    test('mockupFor returns a distinct screen per mockup', () {
      const expected = <ProjectMockup, Type>{
        ProjectMockup.storefront: StorefrontScreen,
        ProjectMockup.erpModules: ErpModulesScreen,
        ProjectMockup.posRegister: PosRegisterScreen,
        ProjectMockup.memberPortal: MemberPortalScreen,
      };
      final types = <Type>{};
      for (final mockup in ProjectMockup.values) {
        final project = Project(
          id: mockup.name,
          name: 'N',
          badge: 'b',
          summary: 's',
          description: 'd',
          tags: const [],
          platforms: const {},
          links: const [],
          mockup: mockup,
          accent: AccentTone.cyan,
        );
        final type = mockupFor(project).runtimeType;
        expect(type, expected[mockup]);
        types.add(type);
      }
      expect(types, hasLength(4));
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

    test('Al-Riyada tags', () {
      expect(projects.first.tags, ['E-Commerce', 'Android', 'iOS']);
    });
  });

  group('layout', () {
    testWidgets('1440: two columns, cards are 480 tall', (tester) async {
      await pumpProjects(tester);
      expect(find.byType(ProjectCard), findsNWidgets(4));
      final dy0 = tester.getTopLeft(card(0)).dy;
      expect(tester.getTopLeft(card(1)).dy, dy0);
      expect(tester.getTopLeft(card(2)).dy, greaterThan(dy0));
      expect(tester.getTopLeft(card(2)).dy, tester.getTopLeft(card(3)).dy);
      for (var i = 0; i < 4; i++) {
        expect(
          tester.getSize(card(i)).height,
          AppLayout.phoneHeight + 2 * AppLayout.cardPadding,
          reason: 'card $i',
        );
      }
    });

    for (final width in [1024.0, 768.0]) {
      testWidgets('${width.toInt()}: one column, phone beside the text', (
        tester,
      ) async {
        await pumpProjects(tester, size: Size(width, 900));
        expect(
          tester.getTopLeft(card(1)).dy,
          greaterThan(tester.getTopLeft(card(0)).dy),
        );
        for (var i = 0; i < 4; i++) {
          final phone = tester.getRect(inCard(i, find.byType(PhoneFrame)));
          final title = tester.getRect(
            inCard(i, find.text(projects[i].name)).first,
          );
          expect(phone.right, lessThan(title.left), reason: 'card $i');
        }
      });
    }

    for (final width in [390.0, 360.0]) {
      testWidgets('${width.toInt()}: one column, phone above the text', (
        tester,
      ) async {
        await pumpProjects(tester, size: Size(width, 800));
        for (var i = 0; i < 4; i++) {
          final cardRect = tester.getRect(card(i));
          final phone = tester.getRect(inCard(i, find.byType(PhoneFrame)));
          final title = tester.getRect(
            find
                .descendant(
                  of: card(i),
                  matching: find.descendant(
                    of: find.byType(ProjectInfo),
                    matching: find.text(projects[i].name),
                  ),
                )
                .first,
          );
          expect(phone.bottom, lessThan(title.top), reason: 'card $i');
          expect(phone.center.dx, closeTo(cardRect.center.dx, 1));
        }
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
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      });
    }
  });

  group('content in cards', () {
    testWidgets('shows copy, tags and the Arabic name', (tester) async {
      await pumpProjects(tester);
      for (var i = 0; i < 4; i++) {
        final p = projects[i];
        final info = find.descendant(
          of: card(i),
          matching: find.byType(ProjectInfo),
        );
        for (final text in [p.badge, p.name, p.summary]) {
          expect(
            find.descendant(of: info, matching: find.text(text)),
            findsOneWidget,
            reason: '${p.id}: $text',
          );
        }
        for (final tag in p.tags) {
          final pill = find.descendant(
            of: info,
            matching: find.widgetWithText(TagPill, tag),
          );
          expect(pill, findsOneWidget, reason: '${p.id}: $tag');
        }
        if (p.nativeName != null) {
          final native = tester.widget<Text>(
            find.descendant(of: info, matching: find.text(p.nativeName!)),
          );
          expect(native.textDirection, TextDirection.rtl);
        }
      }
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
        inCard(2, find.text('Huawei')),
        findsNWidgets(1),
        reason: 'tag only',
      );
      expect(inCard(2, find.text('AppGallery')), findsNothing);
      expect(inCard(1, find.text('AppGallery')), findsOneWidget);
      handle.dispose();
    });
  });

  group('mockups', () {
    Future<void> pumpScreen(
      WidgetTester tester,
      Widget screen, {
      double textScale = 1,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: SizedBox(
                  width: 192,
                  height: 408,
                  child: MediaQuery.withNoTextScaling(child: screen),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final screens = <String, (Widget, List<String>)>{
      'storefront': (
        StorefrontScreen(title: projects[0].nativeName!),
        [projects[0].nativeName!],
      ),
      'erp': (
        const ErpModulesScreen(),
        ['ERP', 'HR', 'CRM', 'Accounting', 'Projects'],
      ),
      'pos': (const PosRegisterScreen(), ['Sutumatic', 'POS', 'Charge']),
      'member': (
        const MemberPortalScreen(),
        ['CFI', 'Service Center', 'MEMBER'],
      ),
    };

    for (final entry in screens.entries) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('${entry.key} renders at text scale $scale', (
          tester,
        ) async {
          await pumpScreen(tester, entry.value.$1, textScale: scale);
          expect(tester.takeException(), isNull);
          for (final label in entry.value.$2) {
            expect(find.text(label), findsOneWidget, reason: label);
          }
        });
      }
    }

    testWidgets('phone ignores system text scale and hides its screen', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Center(
              child: PhoneFrame(
                accent: AccentTone.blue,
                lifted: false,
                screen: ErpModulesScreen(),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel('Accounting'), findsNothing);
      expect(
        find.ancestor(
          of: find.byType(ErpModulesScreen),
          matching: find.byType(ExcludeSemantics),
        ),
        findsWidgets,
      );
      final ctx = tester.element(find.byType(ErpModulesScreen));
      expect(MediaQuery.textScalerOf(ctx), TextScaler.noScaling);
      handle.dispose();
    });
  });

  group('interaction', () {
    Future<TestGesture> mouse(WidgetTester tester) async {
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(1, 1));
      addTearDown(gesture.removePointer);
      return gesture;
    }

    testWidgets('hover highlights the card and lifts the phone', (
      tester,
    ) async {
      await pumpProjects(tester);
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);
      var t = phoneTransformOf(tester, 0).transform;
      expect(t.getTranslation().y, 0);

      final gesture = await mouse(tester);
      await gesture.moveTo(tester.getCenter(card(0)));
      await tester.pumpAndSettle();

      expect(borderColorOf(tester, 0), AppColors.cyanBorderHover);
      expect(borderColorOf(tester, 1), AppColors.borderSubtle);
      t = phoneTransformOf(tester, 0).transform;
      expect(t.getTranslation().y, closeTo(-6, 0.01));
      final angle = math.atan2(t.storage[1], t.storage[0]);
      expect(angle * 180 / math.pi, closeTo(-1, 0.01));

      await gesture.moveTo(const Offset(1, 1));
      await tester.pumpAndSettle();
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);
      t = phoneTransformOf(tester, 0).transform;
      expect(t.getTranslation().y, closeTo(0, 0.01));
      expect(math.atan2(t.storage[1], t.storage[0]), closeTo(0, 1e-6));
    });

    testWidgets('reduced motion: no phone transform on hover', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpProjects(tester);
      final gesture = await mouse(tester);
      await gesture.moveTo(tester.getCenter(card(0)));
      await tester.pumpAndSettle();

      expect(borderColorOf(tester, 0), AppColors.cyanBorderHover);
      final t = phoneTransformOf(tester, 0).transform;
      expect(t.getTranslation().y, 0);
      expect(t.storage[1], 0);
    });

    testWidgets('keyboard focus inside a card highlights it', (tester) async {
      await pumpProjects(tester);
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);

      final label = find.descendant(
        of: inCard(0, find.byType(StoreLinkButton)).first,
        matching: find.text('Play Store'),
      );
      Focus.of(tester.element(label)).requestFocus();
      await tester.pumpAndSettle();

      expect(borderColorOf(tester, 0), AppColors.cyanBorderHover);
      expect(borderColorOf(tester, 1), AppColors.borderSubtle);

      FocusManager.instance.primaryFocus!.unfocus();
      await tester.pumpAndSettle();
      expect(borderColorOf(tester, 0), AppColors.borderSubtle);
    });
  });

  group('repaint isolation', () {
    testWidgets('phone sits in a boundary under its transform', (tester) async {
      await pumpProjects(tester);
      expect(phoneTransform(), findsNWidgets(4));
      for (var i = 0; i < 4; i++) {
        expect(
          find.descendant(
            of: card(i),
            matching: find.descendant(
              of: phoneTransform(),
              matching: find.byType(PhoneFrame),
            ),
          ),
          findsNothing,
        );
        expect(
          find.ancestor(
            of: inCard(i, phoneTransform()),
            matching: find.byType(RepaintBoundary),
          ),
          findsWidgets,
        );
      }
      expect(
        find.descendant(
          of: find.byType(PhoneFrame),
          matching: phoneTransform(),
        ),
        findsNWidgets(4),
      );
      // Each card is wrapped by a boundary.
      for (var i = 0; i < 4; i++) {
        expect(
          find.ancestor(
            of: find.byType(AnimatedContainer).at(i),
            matching: find.byType(RepaintBoundary),
          ),
          findsWidgets,
        );
      }
    });
  });
}
