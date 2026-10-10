import 'package:flutter/widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum TagTone { neutral, hot }

enum TagSize { regular, large }

/// A small pill label.
class TagPill extends StatelessWidget {
  const TagPill(
    this.label, {
    this.tone = TagTone.neutral,
    this.size = TagSize.regular,
    super.key,
  });

  final String label;
  final TagTone tone;
  final TagSize size;

  @override
  Widget build(BuildContext context) {
    final large = size == TagSize.large;
    final hot = tone == TagTone.hot;
    final style = (large ? AppTextStyles.tagLarge : AppTextStyles.tag).copyWith(
      color: hot ? AppColors.cyan300 : AppColors.textSecondary,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: hot ? AppColors.cyanTint : AppColors.surfaceInset,
        borderRadius: AppRadii.pillBorder,
        border: Border.all(
          color: hot ? AppColors.cyanBorderHover : AppColors.borderTag,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: large ? 32 : 26),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: large ? 14 : 10),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(label, textAlign: TextAlign.center, style: style),
          ),
        ),
      ),
    );
  }
}
