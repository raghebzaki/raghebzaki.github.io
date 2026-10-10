import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/ecosystem.dart';
import '../cubit/ecosystem_filter_cubit.dart';
import '../ecosystem_logic.dart';

/// The segmented "Filter apps" radio group.
class EcosystemFilterBar extends StatelessWidget {
  const EcosystemFilterBar({required this.ecosystem, super.key});

  final Ecosystem ecosystem;

  @override
  Widget build(BuildContext context) {
    final options = filterOptions(ecosystem);
    return BlocBuilder<EcosystemFilterCubit, EcosystemFilter>(
      builder: (context, selected) {
        return Semantics(
          container: true,
          label: 'Filter apps',
          role: SemanticsRole.radioGroup,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceInset,
              borderRadius: AppRadii.segmentGroupBorder,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Wrap(
                spacing: AppSpacing.s4,
                runSpacing: AppSpacing.s4,
                children: [
                  for (final option in options)
                    _FilterOptionButton(
                      option: option,
                      selected: option.filter == selected,
                      onSelect: () => context
                          .read<EcosystemFilterCubit>()
                          .select(option.filter),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterOptionButton extends StatefulWidget {
  const _FilterOptionButton({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final FilterOption option;
  final bool selected;
  final VoidCallback onSelect;

  @override
  State<_FilterOptionButton> createState() => _FilterOptionButtonState();
}

class _FilterOptionButtonState extends State<_FilterOptionButton> {
  static const double _ringWidth = 2;
  static const double _ringGap = 2;

  bool _hovered = false;
  bool _focused = false;

  bool get _showRing =>
      _focused &&
      FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppDurations.fast;
    final selected = widget.selected;
    final textColor = selected || _hovered
        ? AppColors.textBright
        : AppColors.textSecondary;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      selected: selected,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: widget.onSelect,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: AppRadii.segmentBorder,
            mouseCursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeOut,
              constraints: const BoxConstraints(
                minHeight: AppLayout.minTapTarget,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
              decoration: BoxDecoration(
                color: selected ? AppColors.segmentActive : null,
                borderRadius: AppRadii.segmentBorder,
                border: Border.all(
                  color: selected ? AppColors.borderStrong : Colors.transparent,
                ),
              ),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: duration,
                      style: AppTextStyles.segment.copyWith(color: textColor),
                      child: Text(widget.option.label),
                    ),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      widget.option.count,
                      style: AppTextStyles.chip.copyWith(
                        color: textColor.withValues(
                          alpha: AppOpacity.filterCount,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showRing)
            Positioned(
              left: -(_ringGap + _ringWidth),
              top: -(_ringGap + _ringWidth),
              right: -(_ringGap + _ringWidth),
              bottom: -(_ringGap + _ringWidth),
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppRadii.segment + _ringGap + _ringWidth,
                    ),
                    border: Border.all(
                      color: AppColors.cyan400,
                      width: _ringWidth,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
