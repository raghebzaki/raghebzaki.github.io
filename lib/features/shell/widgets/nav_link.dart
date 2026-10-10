import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../cubit/navigation_cubit.dart';
import '../section_id.dart';

/// A header navigation link.
class NavLink extends StatefulWidget {
  const NavLink({required this.section, required this.active, super.key});

  final SectionId section;
  final bool active;

  @override
  State<NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = _hovered || widget.active;
    return Semantics(
      link: true,
      selected: widget.active,
      child: InkWell(
        onHover: (value) => setState(() => _hovered = value),
        onTap: () => context.read<NavigationCubit>().scrollTo(widget.section),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s10,
            horizontal: AppSpacing.s4,
          ),
          child: AnimatedDefaultTextStyle(
            duration: AppDurations.fast,
            style: AppTextStyles.nav.copyWith(
              color: highlighted
                  ? AppColors.textBright
                  : AppColors.textSecondary,
            ),
            child: Text(widget.section.navLabel!),
          ),
        ),
      ),
    );
  }
}
