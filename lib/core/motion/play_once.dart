/// Session-scoped registry of one-shot animations (e.g. count-up) so they do
/// not replay when their widget is rebuilt after scrolling away and back.
final class PlayOnce {
  final Set<String> _played = <String>{};

  /// Returns true the first time [key] is claimed, false afterwards.
  bool claim(String key) => _played.add(key);

  bool hasPlayed(String key) => _played.contains(key);
}
