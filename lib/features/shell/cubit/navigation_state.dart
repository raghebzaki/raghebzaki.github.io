import 'package:equatable/equatable.dart';

import '../section_id.dart';

/// What caused a scroll request.
enum ScrollOrigin { navTap, route }

final class NavigationState extends Equatable {
  const NavigationState({
    required this.active,
    this.target,
    this.requestId = 0,
    this.origin,
  });

  /// Highlighted link; drives the URL.
  final SectionId active;

  /// In-flight scroll request, if any.
  final SectionId? target;

  /// Increments on every request, so re-tapping the same section still
  /// scrolls.
  final int requestId;

  final ScrollOrigin? origin;

  NavigationState copyWith({
    SectionId? active,
    SectionId? target,
    bool clearTarget = false,
    int? requestId,
    ScrollOrigin? origin,
  }) {
    return NavigationState(
      active: active ?? this.active,
      target: clearTarget ? null : (target ?? this.target),
      requestId: requestId ?? this.requestId,
      origin: origin ?? this.origin,
    );
  }

  @override
  List<Object?> get props => [active, target, requestId, origin];
}
