import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/responsive/breakpoints.dart';

void main() {
  group('Breakpoints.of', () {
    test('mobile below 600', () {
      expect(Breakpoints.of(0), ScreenType.mobile);
      expect(Breakpoints.of(599), ScreenType.mobile);
    });

    test('tablet from 600 to 1023', () {
      expect(Breakpoints.of(600), ScreenType.tablet);
      expect(Breakpoints.of(1023), ScreenType.tablet);
    });

    test('desktop from 1024', () {
      expect(Breakpoints.of(1024), ScreenType.desktop);
      expect(Breakpoints.of(1920), ScreenType.desktop);
    });
  });
}
