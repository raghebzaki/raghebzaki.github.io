import 'package:flutter_test/flutter_test.dart';

/// Pumps long enough for every finite animation in the app (the longest is
/// the 900 ms smooth scroll) to finish.
///
/// `pumpAndSettle` cannot be used while the hero is mounted: its status-dot
/// halo repeats forever, so the framework never reports "no more frames".
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
