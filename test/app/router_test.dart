import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';
import 'package:ragheb_portfolio/features/shell/cubit/navigation_cubit.dart';
import 'package:ragheb_portfolio/features/shell/portfolio_page.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/features/shell/widgets/compact_menu.dart';
import 'package:ragheb_portfolio/features/shell/widgets/site_header.dart';
import 'package:ragheb_portfolio/features/timeline/timeline_section.dart';

Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
  String initialLocation = '/',
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(PortfolioApp(initialLocation: initialLocation));
  await tester.pumpAndSettle();
}

NavigationCubit cubitOf(WidgetTester tester) =>
    BlocProvider.of<NavigationCubit>(
      tester.element(find.byType(PortfolioPage)),
    );

void main() {
  testWidgets('desktop shows inline nav and scrolls to Timeline', (
    tester,
  ) async {
    // Height 600 (not 900): the placeholder section bodies are still short, so
    // on a taller viewport "Timeline" cannot reach the top and the page ends
    // at the bottom, where the spy correctly reports Contact.
    await pumpApp(tester, size: const Size(1440, 600));
    // Scoped to the header: the hero also has a "Contact" button.
    Finder inHeader(String label) => find.descendant(
      of: find.byType(SiteHeader),
      matching: find.text(label),
    );
    for (final label in [
      'Projects',
      'Ecosystem',
      'Skills',
      'Timeline',
      'Contact',
    ]) {
      expect(inHeader(label), findsOneWidget);
    }
    expect(find.byTooltip('Open menu'), findsNothing);

    await tester.tap(find.text('Timeline'));
    await tester.pumpAndSettle();

    final state = cubitOf(tester).state;
    expect(state.active, SectionId.timeline);
    expect(state.target, isNull);
    expect(find.text('Where the work happened.'), findsOneWidget);
    expect(find.byType(TimelineSection), findsOneWidget);
  });

  testWidgets('nav tap rewrites the URL without navigating the router', (
    tester,
  ) async {
    final written = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.navigation,
      (call) async {
        if (call.method == 'routeInformationUpdated') {
          final args = call.arguments as Map<Object?, Object?>;
          written.add((args['uri'] ?? args['location'])! as String);
        }
        return true;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.navigation,
        null,
      ),
    );
    await pumpApp(tester, size: const Size(1440, 600));
    written.clear();
    await tester.tap(find.text('Skills'));
    await tester.pumpAndSettle();
    expect(written, ['/skills']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deep link opens directly at the section', (tester) async {
    // Height 600: the Skills body is still a placeholder shorter than 35% of a
    // 900px viewport, so the spy would correctly report Timeline instead.
    await pumpApp(
      tester,
      size: const Size(1440, 600),
      initialLocation: '/skills',
    );
    expect(cubitOf(tester).state.active, SectionId.skills);
    expect(find.text('Architecture first. Stores last.'), findsOneWidget);
  });

  testWidgets('unknown path lands on hero', (tester) async {
    await pumpApp(tester, initialLocation: '/nope');
    expect(cubitOf(tester).state.active, SectionId.hero);
  });

  testWidgets('mobile menu opens, navigates and closes', (tester) async {
    await pumpApp(tester, size: const Size(390, 844));
    expect(find.text('Projects'), findsNothing);
    expect(find.byTooltip('Open menu'), findsOneWidget);

    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    Finder inMenu(String label) => find.descendant(
      of: find.byType(CompactMenuPanel),
      matching: find.text(label),
    );
    for (final label in [
      'Projects',
      'Ecosystem',
      'Skills',
      'Timeline',
      'Contact',
    ]) {
      expect(inMenu(label), findsOneWidget);
    }

    await tester.tap(inMenu('Contact'));
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsNothing);
    expect(cubitOf(tester).state.active, SectionId.contact);
    expect(cubitOf(tester).state.target, isNull);
  });

  testWidgets('Escape closes the open menu', (tester) async {
    await pumpApp(tester, size: const Size(390, 844));
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsNothing);
  });

  final keys = {
    'PageDown': LogicalKeyboardKey.pageDown,
    'Space': LogicalKeyboardKey.space,
    'ArrowDown': LogicalKeyboardKey.arrowDown,
  };
  for (final entry in keys.entries) {
    testWidgets('${entry.key} scrolls the page', (tester) async {
      await pumpApp(tester);
      final before = tester.getTopLeft(find.text('Ragheb Zaki').last).dy;
      await tester.sendKeyEvent(entry.value);
      await tester.pumpAndSettle();
      final after = tester.getTopLeft(find.text('Ragheb Zaki').last).dy;
      expect(after, lessThan(before));
    });
  }

  testWidgets('End then Home scroll to contact and hero', (tester) async {
    await pumpApp(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pumpAndSettle();
    expect(cubitOf(tester).state.active, SectionId.contact);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    expect(cubitOf(tester).state.active, SectionId.hero);
  });

  for (final width in [360.0, 768.0, 1440.0]) {
    testWidgets('no overflow at ${width.toInt()}px', (tester) async {
      await pumpApp(tester, size: Size(width, 900));
      expect(tester.takeException(), isNull);
      cubitOf(tester).scrollTo(SectionId.contact);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
