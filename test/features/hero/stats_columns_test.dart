import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/features/hero/widgets/stats_bar.dart';

void main() {
  test('row only when all three fit', () {
    expect(statsColumns(662, 3), 3);
    expect(statsColumns(1000, 3), 3);
    expect(statsColumns(661, 3), 1);
    expect(statsColumns(500, 3), 1);
    expect(statsColumns(300, 3), 1);
  });

  test('never a 2 + 1 split', () {
    for (var w = 200; w <= 1200; w++) {
      expect(statsColumns(w.toDouble(), 3), anyOf(1, 3), reason: 'width $w');
    }
  });
}
