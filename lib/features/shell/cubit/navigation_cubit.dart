import 'package:flutter_bloc/flutter_bloc.dart';

import '../section_id.dart';
import 'navigation_state.dart';

export 'navigation_state.dart';

final class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(active: SectionId.hero));

  /// Initial deep link: the page opens at [id] without a scroll request.
  void restore(SectionId id) {
    emit(state.copyWith(active: id, clearTarget: true));
  }

  /// Requests a scroll to [id]; the highlighted link switches immediately.
  void scrollTo(SectionId id, {ScrollOrigin origin = ScrollOrigin.navTap}) {
    emit(
      state.copyWith(
        active: id,
        target: id,
        requestId: state.requestId + 1,
        origin: origin,
      ),
    );
  }

  /// Reported by the scroll spy. Ignored while a scroll request is in flight.
  void sectionVisible(SectionId id) {
    if (state.target != null || state.active == id) return;
    emit(state.copyWith(active: id));
  }

  void scrollCompleted() {
    if (state.target == null) return;
    emit(state.copyWith(clearTarget: true));
  }
}
