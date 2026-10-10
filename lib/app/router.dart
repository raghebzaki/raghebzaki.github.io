import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/shell/portfolio_page.dart';
import '../features/shell/section_id.dart';

/// Builds the app router.
///
/// A single [ShellRoute] keeps [PortfolioPage] (and its scroll position)
/// alive across route changes; the child routes render nothing, because the
/// sections are rendered by the page's list.
GoRouter createRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: (context, state) {
      final path = state.uri.path;
      final known = SectionId.values.any((id) => id.path == path);
      return known ? null : SectionId.hero.path;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => PortfolioPage(
          routeSection: SectionId.fromPath(state.uri.path),
          child: child,
        ),
        routes: [
          for (final id in SectionId.values)
            GoRoute(
              path: id.path,
              pageBuilder: (context, state) =>
                  const NoTransitionPage<void>(child: SizedBox.shrink()),
            ),
        ],
      ),
    ],
  );
}
