import 'package:flutter/widgets.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/skill.dart';
import '../../../shared/widgets/glow_card.dart';
import 'visuals/layer_stack_view.dart';
import 'visuals/state_flow_view.dart';
import 'visuals/store_grid_view.dart';
import 'visuals/tag_pulse_view.dart';

/// One skills tile: title at the top, diagram pinned to the bottom.
class SkillCard extends StatelessWidget {
  const SkillCard({required this.tile, super.key});

  final SkillTile tile;

  static const double _padding = AppLayout.skillCardPadding;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: const EdgeInsets.all(_padding),
      builder: (context, _) => ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppLayout.skillCardMinHeight - 2 * _padding,
        ),
        // `min` plus spaceBetween: natural height in the measuring pass, and
        // the diagram sinks to the bottom once the row gives a taller box.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tile.title, style: AppTextStyles.tileTitle),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s20),
              child: _visualFor(tile.visual),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _visualFor(SkillVisual visual) => switch (visual) {
  LayerStack() => LayerStackView(visual: visual),
  StateFlow() => StateFlowView(visual: visual),
  TagPulse() => TagPulseView(visual: visual),
  StoreGrid() => StoreGridView(visual: visual),
};
