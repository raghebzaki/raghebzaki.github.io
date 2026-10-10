import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';
import 'package:ragheb_portfolio/features/shell/cubit/navigation_cubit.dart';
import 'package:ragheb_portfolio/features/shell/portfolio_page.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';

/// flutter_test renders every font as Ahem unless the app fonts are loaded;
/// size-sensitive tests need the real metrics.
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

NavigationCubit navigationOf(WidgetTester tester) =>
    BlocProvider.of<NavigationCubit>(
      tester.element(find.byType(PortfolioPage)),
    );

/// Pumps the whole app at [size] and scrolls to [section].
Future<void> pumpSection(
  WidgetTester tester,
  SectionId section, {
  Size size = const Size(1440, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle();
  navigationOf(tester).scrollTo(section);
  await tester.pumpAndSettle();
}
