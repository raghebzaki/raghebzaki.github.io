import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/motion/play_once.dart';

void main() {
  test('first claim wins, later claims lose', () {
    final once = PlayOnce();
    expect(once.hasPlayed('a'), isFalse);
    expect(once.claim('a'), isTrue);
    expect(once.hasPlayed('a'), isTrue);
    expect(once.claim('a'), isFalse);
  });

  test('keys are independent', () {
    final once = PlayOnce();
    expect(once.claim('a'), isTrue);
    expect(once.claim('b'), isTrue);
    expect(once.hasPlayed('c'), isFalse);
  });
}
