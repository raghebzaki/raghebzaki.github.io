import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';

void main() {
  for (final size in const [Size(390, 844), Size(1440, 900)]) {
    testWidgets('renders at ${size.width.toInt()}x${size.height.toInt()}', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const PortfolioApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Ragheb Zaki'), findsOneWidget);
    });
  }
}
