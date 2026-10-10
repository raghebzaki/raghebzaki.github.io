import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/shared/widgets/equal_height_row.dart';

Widget host(Widget child, {double width = 400}) => Directionality(
  textDirection: TextDirection.ltr,
  child: Align(
    alignment: Alignment.topLeft,
    child: SizedBox(width: width, child: child),
  ),
);

void main() {
  testWidgets('children get the tallest height and equal widths', (
    tester,
  ) async {
    const keys = [Key('a'), Key('b'), Key('c')];
    await tester.pumpWidget(
      host(
        const EqualHeightRow(
          gap: 10,
          children: [
            SizedBox(key: Key('a'), height: 30),
            SizedBox(key: Key('b'), height: 80),
            SizedBox(key: Key('c'), height: 50),
          ],
        ),
      ),
    );
    for (final key in keys) {
      final size = tester.getSize(find.byKey(key));
      expect(size.width, closeTo((400 - 20) / 3, 0.001));
      expect(size.height, 80);
    }
    expect(tester.getSize(find.byType(EqualHeightRow)), const Size(400, 80));
  });

  testWidgets('gaps are respected', (tester) async {
    await tester.pumpWidget(
      host(
        const EqualHeightRow(
          gap: 20,
          children: [
            SizedBox(key: Key('a'), height: 10),
            SizedBox(key: Key('b'), height: 10),
          ],
        ),
        width: 420,
      ),
    );
    final a = tester.getRect(find.byKey(const Key('a')));
    final b = tester.getRect(find.byKey(const Key('b')));
    expect(a.width, 200);
    expect(b.left - a.right, 20);
    expect(b.right, 420);
  });

  testWidgets('works with LayoutBuilder children (no intrinsics)', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        EqualHeightRow(
          gap: 1,
          children: [
            LayoutBuilder(
              builder: (context, constraints) =>
                  SizedBox(key: const Key('lb'), height: constraints.maxWidth),
            ),
            const ColoredBox(
              key: Key('plain'),
              color: Color(0xFF000000),
              child: SizedBox(height: 20),
            ),
          ],
        ),
        width: 201,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(const Key('lb'))).height, 100);
    expect(tester.getSize(find.byKey(const Key('plain'))).height, 100);
  });

  testWidgets('hit testing reaches children', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        EqualHeightRow(
          gap: 10,
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps++,
              child: const SizedBox(key: Key('target'), height: 20),
            ),
          ],
        ),
      ),
    );
    // The second child is stretched to 40; tap its lower half.
    final rect = tester.getRect(find.byKey(const Key('target')));
    expect(rect.height, 40);
    await tester.tapAt(rect.bottomCenter - const Offset(0, 2));
    expect(taps, 1);
  });

  testWidgets('intrinsic queries fail with a clear error', (tester) async {
    await tester.pumpWidget(
      host(
        const IntrinsicHeight(
          child: EqualHeightRow(children: [SizedBox(height: 10)]),
        ),
      ),
    );
    final error = tester.takeException();
    expect(error, isNotNull);
  });

  testWidgets('gap can change', (tester) async {
    Widget row(double gap) => host(
      EqualHeightRow(
        gap: gap,
        children: const [
          SizedBox(key: Key('a'), height: 10),
          SizedBox(key: Key('b'), height: 10),
        ],
      ),
    );
    await tester.pumpWidget(row(0));
    expect(tester.getRect(find.byKey(const Key('b'))).left, 200);
    await tester.pumpWidget(row(40));
    expect(tester.getRect(find.byKey(const Key('b'))).left, 220);
  });
}
