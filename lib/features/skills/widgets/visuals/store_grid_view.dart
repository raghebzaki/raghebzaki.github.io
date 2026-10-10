import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../domain/entities/skill.dart';
import '../../../../shared/widgets/equal_height_row.dart';

/// Store tiles in two columns; tiles in a row share a height.
class StoreGridView extends StatelessWidget {
  const StoreGridView({required this.visual, super.key});

  final StoreGrid visual;

  static const int _columns = 2;

  @override
  Widget build(BuildContext context) {
    final stores = visual.stores;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var start = 0; start < stores.length; start += _columns) ...[
          if (start > 0) const SizedBox(height: AppSpacing.s8),
          EqualHeightRow(
            gap: AppSpacing.s8,
            children: [
              for (var i = start; i < start + _columns; i++)
                if (i < stores.length)
                  _StoreTile(stores[i])
                else
                  const SizedBox.shrink(),
            ],
          ),
        ],
      ],
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceInset,
        borderRadius: AppRadii.buttonBorder,
        border: Border.all(color: AppColors.borderTag),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s14),
        child: Text(name, style: AppTextStyles.layerName),
      ),
    );
  }
}
