import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/data/content/experience.dart';
import 'package:ragheb_portfolio/domain/entities/year_month.dart';

void main() {
  group('YearMonth', () {
    test('orders by year then month', () {
      expect(
        const YearMonth(2024, 12).compareTo(const YearMonth(2025, 1)),
        lessThan(0),
      );
      expect(
        const YearMonth(2025, 1).compareTo(const YearMonth(2024, 12)),
        greaterThan(0),
      );
      expect(const YearMonth(2024, 5).compareTo(const YearMonth(2024, 5)), 0);
      expect(
        const YearMonth(2025, 1).isAfter(const YearMonth(2024, 12)),
        isTrue,
      );
      expect(
        const YearMonth(2024, 12).isAfter(const YearMonth(2024, 12)),
        isFalse,
      );
    });

    test('label', () {
      expect(const YearMonth(2024, 12).label, 'Dec 2024');
      expect(const YearMonth(2021, 1).label, 'Jan 2021');
    });

    test('value equality', () {
      expect(const YearMonth(2024, 3), const YearMonth(2024, 3));
    });
  });

  group('Experience.period', () {
    test('current role shows Present', () {
      expect(experience.first.isCurrent, isTrue);
      expect(experience.first.period, 'Dec 2024 – Present');
    });

    test('finished role shows end date', () {
      expect(experience.last.isCurrent, isFalse);
      expect(experience.last.period, 'Aug 2021 – Dec 2021');
    });
  });
}
