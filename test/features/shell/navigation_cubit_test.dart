import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/features/shell/cubit/navigation_cubit.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';

void main() {
  test('initial state is hero with requestId 0', () {
    final state = NavigationCubit().state;
    expect(state.active, SectionId.hero);
    expect(state.target, isNull);
    expect(state.requestId, 0);
  });

  blocTest<NavigationCubit, NavigationState>(
    'scrollTo emits active, target and requestId 1',
    build: NavigationCubit.new,
    act: (c) => c.scrollTo(SectionId.skills),
    expect: () => [
      const NavigationState(
        active: SectionId.skills,
        target: SectionId.skills,
        requestId: 1,
        origin: ScrollOrigin.navTap,
      ),
    ],
  );

  blocTest<NavigationCubit, NavigationState>(
    'scrollTo the same section twice increments requestId to 2',
    build: NavigationCubit.new,
    act: (c) {
      c
        ..scrollTo(SectionId.skills)
        ..scrollTo(SectionId.skills);
    },
    verify: (c) => expect(c.state.requestId, 2),
  );

  blocTest<NavigationCubit, NavigationState>(
    'sectionVisible is ignored while a target is pending',
    build: NavigationCubit.new,
    act: (c) {
      c
        ..scrollTo(SectionId.skills)
        ..sectionVisible(SectionId.projects);
    },
    verify: (c) => expect(c.state.active, SectionId.skills),
  );

  blocTest<NavigationCubit, NavigationState>(
    'scrollCompleted clears target, then sectionVisible works',
    build: NavigationCubit.new,
    act: (c) {
      c
        ..scrollTo(SectionId.skills)
        ..scrollCompleted()
        ..sectionVisible(SectionId.projects);
    },
    verify: (c) {
      expect(c.state.target, isNull);
      expect(c.state.active, SectionId.projects);
      expect(c.state.requestId, 1);
    },
  );

  blocTest<NavigationCubit, NavigationState>(
    'sectionVisible with the current active emits nothing',
    build: NavigationCubit.new,
    act: (c) => c.sectionVisible(SectionId.hero),
    expect: () => <NavigationState>[],
  );

  blocTest<NavigationCubit, NavigationState>(
    'restore sets active with no target and no requestId change',
    build: NavigationCubit.new,
    act: (c) => c.restore(SectionId.timeline),
    expect: () => [const NavigationState(active: SectionId.timeline)],
  );
}
