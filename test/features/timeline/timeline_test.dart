import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/features/timeline/widgets/company_link.dart';
import 'package:ragheb_portfolio/features/timeline/widgets/role_card.dart';
import 'package:ragheb_portfolio/shared/widgets/app_icon.dart';
import 'package:ragheb_portfolio/shared/widgets/tag_pill.dart';
import 'package:url_launcher/link.dart';

import '../../support/app_harness.dart';
import '../../support/settle.dart';

final roles = const StaticPortfolioRepository().experience;

Finder get cards => find.byType(RoleCard);
Finder pill(String label) => find.widgetWithText(TagPill, label);
Finder inCard(int i, Finder matching) =>
    find.descendant(of: cards.at(i), matching: matching);

const _dotColors = [
  AppColors.cyan400,
  AppColors.sky400,
  AppColors.blue500,
  AppColors.indigo400,
  AppColors.blue700,
];

BoxDecoration badgeDecorationOf(WidgetTester tester, int i) =>
    tester
            .widget<AnimatedContainer>(
              inCard(i, find.byKey(const ValueKey('company-badge'))),
            )
            .decoration!
        as BoxDecoration;

Color arrowColorOf(WidgetTester tester, int i) => tester
    .widget<AppIconView>(
      find.descendant(
        of: inCard(i, find.byType(CompanyLink)),
        matching: find.byType(AppIconView),
      ),
    )
    .color;

void main() {
  setUpAll(loadAppFonts);

  testWidgets('five cards in repository order with full company names', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline);
    expect(cards, findsNWidgets(5));
    expect(roles.map((r) => r.company), [
      'Cairo Photo Club',
      'CloudSoft5',
      'Sutum ICT Consulting',
      'Coddiv',
      'Sejall Technology',
    ]);
    for (var i = 0; i < roles.length; i++) {
      expect(inCard(i, find.text(roles[i].company)), findsOneWidget);
      expect(
        inCard(i, find.byKey(const ValueKey('company-badge'))),
        findsOneWidget,
      );
    }
    // Cards are stacked newest first.
    final tops = [
      for (var i = 0; i < 5; i++) tester.getTopLeft(cards.at(i)).dy,
    ];
    expect([...tops]..sort(), tops);
  });

  testWidgets('shows role and period for every card', (tester) async {
    await pumpSection(tester, SectionId.timeline);
    const metas = [
      'Senior Flutter Developer (Part-time) · Aug 2026 – Present',
      'Flutter Developer · Dec 2024 – Present',
      'Flutter Developer · Sep 2024 – Jan 2025',
      'Flutter Developer · Jun 2023 – Sep 2025',
      'Flutter Developer · Aug 2021 – Dec 2021',
    ];
    for (var i = 0; i < metas.length; i++) {
      expect(inCard(i, find.text(metas[i])), findsOneWidget);
    }
  });

  testWidgets('Cairo Photo Club and CloudSoft5 are Current; CPC is Part-time', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline);
    expect(
      find.descendant(of: cards, matching: pill('Current')),
      findsNWidgets(2),
    );
    expect(inCard(0, pill('Current')), findsOneWidget);
    expect(inCard(1, pill('Current')), findsOneWidget);
    expect(inCard(0, pill('Part-time')), findsOneWidget);
    expect(inCard(0, pill('Cairo, Egypt / Remote')), findsOneWidget);
    // Pill order: location, type, Current.
    final xs = [
      for (final label in ['Cairo, Egypt / Remote', 'Part-time', 'Current'])
        tester.getTopLeft(inCard(0, pill(label))).dx,
    ];
    expect([...xs]..sort(), xs);
  });

  testWidgets('Coddiv shows both engagement pills and locations', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline);
    for (final label in [
      'Full-time · Jun 2023 – Dec 2024',
      'Part-time · Jan 2025 – Sep 2025',
      'Cairo, Egypt',
    ]) {
      expect(inCard(3, pill(label)), findsOneWidget);
    }
    expect(inCard(2, pill('Saudi Arabia')), findsOneWidget);
    expect(inCard(4, pill('Giza, Egypt')), findsOneWidget);
  });

  testWidgets('every highlight is rendered', (tester) async {
    await pumpSection(tester, SectionId.timeline);
    for (var i = 0; i < roles.length; i++) {
      for (final highlight in roles[i].highlights) {
        expect(inCard(i, find.text(highlight)), findsOneWidget);
      }
    }
  });

  testWidgets('dots sit on the rail, level with the company badge', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.timeline, size: const Size(1440, 2400));
    final rail = tester.getRect(find.byKey(const ValueKey('timeline-rail')));
    expect(rail.width, 2);
    for (var i = 0; i < 5; i++) {
      final dotFinder = find.byKey(ValueKey('timeline-dot-$i'));
      final dot = tester.getRect(dotFinder);
      expect(dot.size, const Size.square(12));
      expect(dot.center.dx, closeTo(rail.center.dx, 0.5));
      final badge = tester.getRect(
        inCard(i, find.byKey(const ValueKey('company-badge'))),
      );
      expect(badge.size, const Size.square(AppLayout.companyBadgeSize));
      expect(dot.center.dy, closeTo(badge.center.dy, 0.5));
      final decoration =
          tester.widget<DecoratedBox>(dotFinder).decoration as BoxDecoration;
      expect(decoration.color, _dotColors[i]);
      expect(
        decoration.boxShadow,
        roles[i].isCurrent
            ? AppShadows.timelineDotActive
            : AppShadows.timelineDot,
      );
    }
  });

  group('company links', () {
    testWidgets('each company opens its LinkedIn page in a new tab', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpSection(tester, SectionId.timeline);
      const urls = [
        'https://www.linkedin.com/company/cairo-photo-club',
        'https://www.linkedin.com/company/cloudsoft5/',
        'https://www.linkedin.com/company/sutum-ict-consulting/',
        'https://www.linkedin.com/company/coddiv/',
        'https://www.linkedin.com/company/sejall-technology/',
      ];
      for (var i = 0; i < 5; i++) {
        final link = tester.widget<Link>(
          find.descendant(
            of: inCard(i, find.byType(CompanyLink)),
            matching: find.byType(Link),
          ),
        );
        expect(link.uri, Uri.parse(urls[i]));
        expect(link.target, LinkTarget.blank);
        final label = 'Visit ${roles[i].company} on LinkedIn';
        expect(inCard(i, find.byTooltip(label)), findsOneWidget);
        expect(find.bySemanticsLabel(label), findsOneWidget);
        // The link is its own node: the rest of the card must not merge into
        // its label (regression: the whole card read as one link).
        final node = tester.getSemantics(find.bySemanticsLabel(label));
        expect(node.label, label);
      }
      semantics.dispose();
    });

    testWidgets('hover lights the badge in the role colour and the arrow', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.timeline);
      expect(
        badgeDecorationOf(tester, 1).border!.top.color,
        AppColors.borderTag,
      );
      expect(arrowColorOf(tester, 1), AppColors.textMuted);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(
        tester.getCenter(
          inCard(1, find.byKey(const ValueKey('company-badge'))),
        ),
      );
      await settle(tester);

      final hovered = badgeDecorationOf(tester, 1);
      expect(
        hovered.border!.top.color,
        _dotColors[1].withValues(alpha: AppOpacity.companyBadgeHoverBorder),
      );
      expect(hovered.boxShadow, isNotEmpty);
      expect(arrowColorOf(tester, 1), AppColors.cyan300);

      await gesture.moveTo(const Offset(1, 1));
      await settle(tester);
      expect(
        badgeDecorationOf(tester, 1).border!.top.color,
        AppColors.borderTag,
      );
      expect(arrowColorOf(tester, 1), AppColors.textMuted);
    });

    testWidgets('keyboard focus highlights the link and shows the ring', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.timeline);
      // A key press puts the focus system in keyboard (traditional) mode.
      await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
      final inkWell = find.descendant(
        of: inCard(0, find.byType(CompanyLink)),
        matching: find.byType(InkWell),
      );
      Focus.of(
        tester.element(
          find.descendant(of: inkWell, matching: find.text(roles[0].company)),
        ),
      ).requestFocus();
      await settle(tester);

      expect(arrowColorOf(tester, 0), AppColors.cyan300);
      expect(
        badgeDecorationOf(tester, 0).border!.top.color,
        _dotColors[0].withValues(alpha: AppOpacity.companyBadgeHoverBorder),
      );
      // The focus ring is a positioned cyan outline around the link.
      final ring = find.descendant(
        of: inCard(0, find.byType(CompanyLink)),
        matching: find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).border?.top.color ==
                  AppColors.cyan400,
        ),
      );
      expect(ring, findsOneWidget);
    });
  });

  group('company logos', () {
    String? assetOf(Image image) {
      final provider = image.image;
      final inner = provider is ResizeImage ? provider.imageProvider : provider;
      return inner is AssetImage ? inner.assetName : null;
    }

    testWidgets('each badge shows its company logo', (tester) async {
      await pumpSection(tester, SectionId.timeline);
      for (var i = 0; i < 5; i++) {
        final image = tester.widget<Image>(
          inCard(
            i,
            find.descendant(
              of: find.byKey(const ValueKey('company-badge')),
              matching: find.byType(Image),
            ),
          ),
        );
        expect(assetOf(image), roles[i].logoAsset);
        expect(image.fit, BoxFit.contain);
      }
    });

    Future<void> pumpBadge(WidgetTester tester, String asset) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CompanyLink(
                company: 'Acme',
                url: 'https://www.linkedin.com/company/acme/',
                monogram: 'AC',
                accent: AppColors.cyan400,
                logoAsset: asset,
              ),
            ),
          ),
        ),
      );
      // Real image decoding needs real async time.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)),
      );
      await tester.pump();
    }

    final logoTile = find.byWidgetPredicate(
      (w) => w is ColoredBox && w.color == AppColors.logoTile,
    );

    testWidgets('a loaded logo sits on a white tile inside the 44px badge', (
      tester,
    ) async {
      await pumpBadge(tester, roles.first.logoAsset!);
      expect(logoTile, findsOneWidget);
      expect(find.byKey(const ValueKey('company-monogram')), findsNothing);
      expect(
        tester.getSize(find.byKey(const ValueKey('company-badge'))),
        const Size.square(AppLayout.companyBadgeSize),
      );
    });

    testWidgets('a missing logo falls back to the monogram', (tester) async {
      await pumpBadge(tester, 'assets/images/companies/missing_logo.jpeg');
      expect(find.byKey(const ValueKey('company-monogram')), findsOneWidget);
      expect(find.text('AC'), findsOneWidget);
      expect(logoTile, findsNothing);
      expect(tester.takeException(), isNull);
    });
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
