import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';
import 'package:ragheb_portfolio/data/content/profile.dart';
import 'package:ragheb_portfolio/features/hero/hero_section.dart';
import 'package:ragheb_portfolio/features/hero/widgets/hero_backdrop.dart';
import 'package:ragheb_portfolio/features/hero/widgets/stats_bar.dart';
import 'package:ragheb_portfolio/features/shell/cubit/navigation_cubit.dart';
import 'package:ragheb_portfolio/features/shell/portfolio_page.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/shared/widgets/app_button.dart';
import 'package:ragheb_portfolio/shared/widgets/app_icon.dart';
import 'package:url_launcher/link.dart';

/// Pumps the app without settling, so animations can be observed.
Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PortfolioApp());
}

void disableAnimations(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

NavigationCubit cubitOf(WidgetTester tester) =>
    BlocProvider.of<NavigationCubit>(
      tester.element(find.byType(PortfolioPage)),
    );

void main() {
  testWidgets('hero shows the copy and the four actions', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text(profile.title), findsOneWidget);
    expect(find.text('Ragheb Zaki'), findsWidgets);
    expect(find.text(profile.summary), findsOneWidget);
    for (final label in ['Download CV', 'GitHub', 'LinkedIn', 'Contact']) {
      expect(find.widgetWithText(AppButton, label), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('links open in a new tab with the right destinations', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    // Scoped to the hero: the projects section below adds store links.
    final links = tester
        .widgetList<Link>(
          find.descendant(
            of: find.byType(HeroSection),
            matching: find.byType(Link),
          ),
        )
        .toList();
    expect(links, hasLength(3));
    expect(links.every((l) => l.target == LinkTarget.blank), isTrue);
    expect(
      links.any((l) => l.uri!.path.endsWith('/files/Ragheb_Zaki_CV.pdf')),
      isTrue,
    );
    expect(
      links.any((l) => l.uri == Uri.parse('https://github.com/raghebzaki')),
      isTrue,
    );
    expect(
      links.any(
        (l) =>
            l.uri ==
            Uri.parse('https://www.linkedin.com/in/ragheb-zaki-752472176/'),
      ),
      isTrue,
    );
  });

  testWidgets('Contact scrolls to the contact section', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppButton, 'Contact'));
    await tester.pumpAndSettle();
    expect(cubitOf(tester).state.active, SectionId.contact);
  });

  testWidgets('icons are compiled binary assets', (tester) async {
    for (final icon in AppIcon.values) {
      final data = (await tester.runAsync(
        () => rootBundle.load(icon.assetPath),
      ))!;
      expect(data.lengthInBytes, greaterThan(8), reason: icon.assetPath);
      // Raw SVG would start with '<'.
      expect(data.getUint8(0), isNot(0x3C), reason: icon.assetPath);
    }
  });

  group('stats', () {
    testWidgets('count up to the final values', (tester) async {
      await pumpApp(tester);
      await tester.pump();
      expect(find.text('100K+'), findsNothing);
      await tester.pumpAndSettle();
      for (final text in ['4+', '30+', '100K+']) {
        expect(find.text(text), findsOneWidget);
      }
    });

    testWidgets('show final values immediately without animations', (
      tester,
    ) async {
      disableAnimations(tester);
      await pumpApp(tester);
      for (final text in ['4+', '30+', '100K+']) {
        expect(find.text(text), findsOneWidget);
      }
    });

    testWidgets('semantics read the final value mid-animation', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('100K+'), findsNothing, reason: 'still counting');
      expect(find.bySemanticsLabel('100K+ Flagship Installs'), findsOneWidget);
      expect(find.bySemanticsLabel('4+ Years Experience'), findsOneWidget);
      expect(find.bySemanticsLabel('30+ Shipped Live Apps'), findsOneWidget);
      await tester.pumpAndSettle();
      handle.dispose();
    });

    testWidgets('do not replay after scrolling away and back', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle();
      expect(find.text('100K+'), findsOneWidget);

      cubitOf(tester).scrollTo(SectionId.contact);
      await tester.pumpAndSettle();
      expect(find.byType(StatsBar), findsNothing, reason: 'hero is unmounted');

      cubitOf(tester).scrollTo(SectionId.hero);
      var frames = 0;
      while (find.byType(StatsBar).evaluate().isEmpty) {
        await tester.pump(const Duration(milliseconds: 50));
        expect(++frames, lessThan(100));
      }
      // First frame after the hero rebuilt: already final.
      expect(find.text('100K+'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    for (final width in [360.0, 768.0, 1440.0]) {
      testWidgets('lay out without errors at ${width.toInt()}px', (
        tester,
      ) async {
        await pumpApp(tester, size: Size(width, 900));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        final dys = [
          for (final text in ['4+', '30+', '100K+'])
            tester.getTopLeft(find.text(text)).dy,
        ];
        if (width >= 760) {
          expect(dys.toSet(), hasLength(1), reason: 'row');
        } else {
          expect(dys.toSet(), hasLength(3), reason: 'stacked');
        }
      });
    }
  });

  group('backdrop', () {
    testWidgets('is isolated in a repaint boundary', (tester) async {
      await pumpApp(tester);
      await tester.pumpAndSettle();
      final painted = find.byWidgetPredicate(
        (w) => w is CustomPaint && w.painter is HeroBackdropPainter,
      );
      expect(painted, findsOneWidget);
      expect(
        find.ancestor(of: painted, matching: find.byType(RepaintBoundary)),
        findsWidgets,
      );
    });

    test('never repaints on its own', () {
      expect(
        const HeroBackdropPainter().shouldRepaint(const HeroBackdropPainter()),
        isFalse,
      );
    });
  });
}
