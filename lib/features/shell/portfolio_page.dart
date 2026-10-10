import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../contact/contact_section.dart';
import '../ecosystem/ecosystem_section.dart';
import '../hero/hero_section.dart';
import '../projects/projects_section.dart';
import '../skills/skills_section.dart';
import '../timeline/timeline_section.dart';
import 'cubit/navigation_cubit.dart';
import 'scroll_spy.dart';
import 'section_id.dart';
import 'widgets/compact_menu.dart';
import 'widgets/site_header.dart';

/// The single-page portfolio: sticky header over a section list.
///
/// Lives inside a `ShellRoute`, so route changes update [routeSection] on the
/// same state object and the scroll position survives.
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    required this.routeSection,
    required this.child,
    super.key,
  });

  final SectionId routeSection;

  /// The shell route's navigator. Mounted off-stage; sections are rendered
  /// by the list, not by routes.
  final Widget child;

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();
  final _scrollOffsetController = ScrollOffsetController();
  final _scrolled = ValueNotifier<bool>(false);
  final _menuOpen = ValueNotifier<bool>(false);
  final _pageFocus = FocusNode(debugLabel: 'PortfolioPage');
  final _listAreaKey = GlobalKey();

  /// The last path written to, or received from, the browser URL.
  late String _lastPath = widget.routeSection.path;

  late final NavigationCubit _cubit = context.read<NavigationCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.restore(widget.routeSection);
    _itemPositionsListener.itemPositions.addListener(_onPositions);
  }

  @override
  void didUpdateWidget(PortfolioPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.routeSection != oldWidget.routeSection &&
        widget.routeSection.path != _lastPath) {
      // Browser back/forward or external navigation.
      _lastPath = widget.routeSection.path;
      _cubit.scrollTo(widget.routeSection, origin: ScrollOrigin.route);
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onPositions);
    _scrolled.dispose();
    _menuOpen.dispose();
    _pageFocus.dispose();
    super.dispose();
  }

  void _onPositions() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final top = positions.where((p) => p.index == 0);
    _scrolled.value = !(top.isNotEmpty && top.first.itemLeadingEdge >= -0.001);

    final id = resolveActiveSection(
      positions,
      sectionCount: SectionId.values.length,
    );
    if (id != null) _cubit.sectionVisible(id);

    if (_menuOpen.value) _menuOpen.value = false;
  }

  int _currentTopIndex() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return 0;
    return positions.map((p) => p.index).reduce((a, b) => a < b ? a : b);
  }

  Future<void> _handleScrollRequest(NavigationState state) async {
    final target = state.target;
    if (target == null || !_itemScrollController.isAttached) return;
    final requestId = state.requestId;

    if (MediaQuery.disableAnimationsOf(context)) {
      _itemScrollController.jumpTo(index: target.index);
    } else {
      final distance = (target.index - _currentTopIndex()).abs();
      final ms = (450 + 90 * distance).clamp(450, 900);
      await _itemScrollController.scrollTo(
        index: target.index,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeInOutCubic,
      );
    }
    // A newer request owns the in-flight state.
    if (mounted && _cubit.state.requestId == requestId) {
      _cubit.scrollCompleted();
    }
  }

  void _syncUrl(SectionId active) {
    if (active.path == _lastPath) return;
    _lastPath = active.path;
    unawaited(
      SystemNavigator.routeInformationUpdated(
        uri: Uri(path: active.path),
        replace: true,
      ),
    );
  }

  static const double _arrowStep = 64;
  static const double _pageStep = 0.85;

  /// Page-level keyboard scrolling. The list is not focused by default, so
  /// Flutter's built-in scroll shortcuts never fire; this handles them for
  /// the whole page while leaving focused links alone (Space activates a
  /// focused link, Enter/Tab are never handled here).
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape) {
      if (!_menuOpen.value) return KeyEventResult.ignored;
      _menuOpen.value = false;
      return KeyEventResult.handled;
    }

    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isAltPressed) {
      return KeyEventResult.ignored;
    }

    final viewport =
        _listAreaKey.currentContext?.size?.height ??
        MediaQuery.sizeOf(context).height;
    double? delta;
    if (key == LogicalKeyboardKey.arrowDown) {
      delta = _arrowStep;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      delta = -_arrowStep;
    } else if (key == LogicalKeyboardKey.pageDown) {
      delta = viewport * _pageStep;
    } else if (key == LogicalKeyboardKey.pageUp) {
      delta = -viewport * _pageStep;
    } else if (key == LogicalKeyboardKey.space) {
      // Space on a focused control activates it instead.
      final focused = FocusManager.instance.primaryFocus?.context;
      if (focused?.findAncestorWidgetOfExactType<InkResponse>() != null) {
        return KeyEventResult.ignored;
      }
      delta = keyboard.isShiftPressed
          ? -viewport * _pageStep
          : viewport * _pageStep;
    } else if (key == LogicalKeyboardKey.home) {
      _cubit.scrollTo(SectionId.hero);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.end) {
      _cubit.scrollTo(SectionId.contact);
      return KeyEventResult.handled;
    }
    if (delta == null) return KeyEventResult.ignored;

    unawaited(
      _scrollOffsetController.animateScroll(
        offset: delta,
        duration: AppDurations.fast,
        curve: Curves.easeOut,
      ),
    );
    return KeyEventResult.handled;
  }

  Widget _buildSection(BuildContext context, int index) {
    return switch (SectionId.values[index]) {
      SectionId.hero => const HeroSection(),
      SectionId.projects => const ProjectsSection(),
      SectionId.ecosystem => const EcosystemSection(),
      SectionId.skills => const SkillsSection(),
      SectionId.timeline => const TimelineSection(),
      SectionId.contact => const ContactSection(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NavigationCubit, NavigationState>(
          listenWhen: (previous, current) =>
              previous.requestId != current.requestId && current.target != null,
          listener: (context, state) => unawaited(_handleScrollRequest(state)),
        ),
        BlocListener<NavigationCubit, NavigationState>(
          listenWhen: (previous, current) => previous.active != current.active,
          listener: (context, state) => _syncUrl(state.active),
        ),
      ],
      child: Focus(
        focusNode: _pageFocus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SiteHeader(scrolled: _scrolled, menuOpen: _menuOpen),
              Expanded(
                child: Stack(
                  key: _listAreaKey,
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: SelectionArea(
                        child: ScrollablePositionedList.builder(
                          itemCount: SectionId.values.length,
                          initialScrollIndex: widget.routeSection.index,
                          itemScrollController: _itemScrollController,
                          itemPositionsListener: _itemPositionsListener,
                          scrollOffsetController: _scrollOffsetController,
                          itemBuilder: _buildSection,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CompactMenuPanel(menuOpen: _menuOpen),
                    ),
                    Offstage(child: widget.child),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
