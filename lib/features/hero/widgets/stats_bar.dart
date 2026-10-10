import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/motion/play_once.dart';
import '../../../core/responsive/responsive_value.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/profile.dart';
import 'animated_stat_value.dart';

/// Number of columns for the stats bar: all [count] in one row, or one column
/// (never a 2 + 1 split). [width] is the inner width inside the 1px frame.
int statsColumns(double width, int count) {
  final n = AutoFit.columns(
    width,
    minTile: AppLayout.statsMinTile,
    gap: 1,
    maxColumns: count,
  );
  return n >= count ? count : 1;
}

class StatsBar extends StatefulWidget {
  const StatsBar({required this.stats, super.key});

  final List<Stat> stats;

  @override
  State<StatsBar> createState() => _StatsBarState();
}

class _StatsBarState extends State<StatsBar> {
  bool _animate = false;
  bool _claimed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_claimed) return;
    _claimed = true;
    final first = context.read<PlayOnce>().claim('hero.stats');
    _animate = first && !MediaQuery.disableAnimationsOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.heroMax),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.borderSubtle,
            borderRadius: AppRadii.cardBorder,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.card - 1),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final row =
                    statsColumns(constraints.maxWidth, stats.length) > 1;
                final cells = [
                  for (final stat in stats) _StatCell(stat, animate: _animate),
                ];
                if (row) {
                  // Cells hold identical content structure, so their heights
                  // match; GradientText's LayoutBuilder rules out
                  // IntrinsicHeight here.
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < cells.length; i++) ...[
                        if (i > 0) const SizedBox(width: 1),
                        Expanded(child: cells[i]),
                      ],
                    ],
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < cells.length; i++) ...[
                      if (i > 0) const SizedBox(height: 1),
                      cells[i],
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell(this.stat, {required this.animate});

  final Stat stat;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: '${stat.display} ${stat.label}',
      child: ColoredBox(
        color: AppColors.surfaceRaised,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s28,
            horizontal: AppSpacing.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedStatValue(stat: stat, animate: animate),
              const SizedBox(height: AppSpacing.s6),
              Text(stat.label, style: AppTextStyles.statLabel),
            ],
          ),
        ),
      ),
    );
  }
}
