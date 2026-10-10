import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../domain/entities/skill.dart';

class _LayerTone {
  const _LayerTone(this.border, this.detail);

  final Color border;
  final Color detail;
}

const _tones = [
  _LayerTone(AppColors.cyanBorderHover, AppColors.cyan300),
  _LayerTone(AppColors.layerSkyBorder, AppColors.sky300),
  _LayerTone(AppColors.layerBlueBorder, AppColors.blue300),
];

/// Stacked layers, each indented one step further than the last.
class LayerStackView extends StatelessWidget {
  const LayerStackView({required this.visual, super.key});

  final LayerStack visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < visual.layers.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s8),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: i * AppLayout.skillLayerIndent,
            ),
            child: _LayerRow(
              key: ValueKey('layer-$i'),
              layer: visual.layers[i],
              tone: _tones[math.min(i, _tones.length - 1)],
            ),
          ),
        ],
      ],
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.layer, required this.tone, super.key});

  final SkillLayer layer;
  final _LayerTone tone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceInset,
        borderRadius: AppRadii.buttonBorder,
        border: Border.all(color: tone.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(layer.name, style: AppTextStyles.layerName),
            const SizedBox(width: AppSpacing.s8),
            Flexible(
              child: Text(
                layer.detail,
                textAlign: TextAlign.end,
                style: AppTextStyles.layerDetail.copyWith(color: tone.detail),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
