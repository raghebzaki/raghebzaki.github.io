import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../cubit/navigation_cubit.dart';
import '../section_id.dart';
import 'brand_mark.dart';
import 'nav_link.dart';

/// Sticky site header: brand on the left, navigation on the right.
class SiteHeader extends StatelessWidget {
  const SiteHeader({required this.scrolled, required this.menuOpen, super.key});

  /// Below this content width the inline links collapse into a menu button.
  /// The full row needs about 600px at 14px text, and the prototype's wrapped
  /// links are about 37px tall, which is under the 44px tap target.
  static const double compactBelow = 640;

  /// Whether the page is scrolled away from the top (shows the bottom border).
  final ValueListenable<bool> scrolled;

  /// Whether the compact menu panel is open.
  final ValueNotifier<bool> menuOpen;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppLayout.maxContent),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s20,
                  horizontal: AppLayout.gutter,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < compactBelow;
                    return Row(
                      children: [
                        const Flexible(child: BrandMark()),
                        if (compact) ...[
                          const Spacer(),
                          _MenuToggle(menuOpen: menuOpen),
                        ] else ...[
                          const SizedBox(width: AppSpacing.s16),
                          const Expanded(child: _InlineNav()),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 1,
            child: ValueListenableBuilder<bool>(
              valueListenable: scrolled,
              builder: (context, isScrolled, _) => AnimatedOpacity(
                duration: AppDurations.fast,
                opacity: isScrolled ? 1 : 0,
                child: const ColoredBox(color: AppColors.borderSubtle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineNav extends StatelessWidget {
  const _InlineNav();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      buildWhen: (previous, current) => previous.active != current.active,
      builder: (context, state) {
        return Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.s20,
          children: [
            for (final id in SectionId.navItems)
              NavLink(section: id, active: id == state.active),
          ],
        );
      },
    );
  }
}

class _MenuToggle extends StatelessWidget {
  const _MenuToggle({required this.menuOpen});

  final ValueNotifier<bool> menuOpen;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: menuOpen,
      builder: (context, open, _) {
        return Tooltip(
          message: open ? 'Close menu' : 'Open menu',
          child: Semantics(
            button: true,
            expanded: open,
            child: InkWell(
              borderRadius: AppRadii.buttonBorder,
              onTap: () => menuOpen.value = !open,
              child: SizedBox.square(
                dimension: AppLayout.minTapTarget,
                child: Icon(
                  open ? Icons.close_rounded : Icons.menu_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
