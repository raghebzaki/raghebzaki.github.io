import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../cubit/navigation_cubit.dart';
import '../section_id.dart';

/// Overlay navigation for narrow viewports. Place it as a fill child of the
/// list-area [Stack]; it passes pointer events through while closed.
class CompactMenuPanel extends StatelessWidget {
  const CompactMenuPanel({required this.menuOpen, super.key});

  final ValueNotifier<bool> menuOpen;

  static const double rowHeight = 52;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppDurations.fast;
    return ValueListenableBuilder<bool>(
      valueListenable: menuOpen,
      builder: (context, open, _) {
        return AnimatedSwitcher(
          duration: duration,
          reverseDuration: duration,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.04),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          layoutBuilder: (current, previous) =>
              Stack(fit: StackFit.expand, children: [...previous, ?current]),
          child: open
              ? _OpenMenu(
                  key: const ValueKey('open'),
                  onClose: () => menuOpen.value = false,
                )
              : const SizedBox.shrink(key: ValueKey('closed')),
        );
      },
    );
  }
}

class _OpenMenu extends StatelessWidget {
  const _OpenMenu({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Tap-outside scrim.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: const SizedBox.expand(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surfaceRaised,
              border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
              boxShadow: AppShadows.menuPanel,
            ),
            child: BlocBuilder<NavigationCubit, NavigationState>(
              buildWhen: (previous, current) =>
                  previous.active != current.active,
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final id in SectionId.navItems)
                      _MenuRow(
                        section: id,
                        active: id == state.active,
                        onSelected: () {
                          onClose();
                          context.read<NavigationCubit>().scrollTo(id);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.section,
    required this.active,
    required this.onSelected,
  });

  final SectionId section;
  final bool active;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      selected: active,
      child: InkWell(
        onTap: onSelected,
        child: SizedBox(
          height: CompactMenuPanel.rowHeight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppLayout.gutter),
            child: Row(
              children: [
                Text(
                  section.navLabel!,
                  style: AppTextStyles.navLarge.copyWith(
                    color: active
                        ? AppColors.textBright
                        : AppColors.textSecondary,
                  ),
                ),
                if (active) ...[
                  const SizedBox(width: AppSpacing.s12),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.cyan400,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: 6),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
