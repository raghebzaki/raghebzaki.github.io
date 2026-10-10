import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_icon.dart';
import 'mock_primitives.dart';

/// ERP+ SPA: module launcher with a small chart card.
class ErpModulesScreen extends StatelessWidget {
  const ErpModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: mockScreenPadding,
      child: Column(
        spacing: mockGap,
        children: [
          _Header(),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: _ModuleTile(
                  label: 'HR',
                  icon: AppIcon.users,
                  tint: AppColors.mockTintCyan,
                  iconColor: AppColors.cyan400,
                ),
              ),
              Expanded(
                child: _ModuleTile(
                  label: 'CRM',
                  icon: AppIcon.message,
                  tint: AppColors.mockTintBlue,
                  iconColor: AppColors.blue400,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: _ModuleTile(
                  label: 'Accounting',
                  icon: AppIcon.ledger,
                  tint: AppColors.mockTintBlue,
                  iconColor: AppColors.blue400,
                ),
              ),
              Expanded(
                child: _ModuleTile(
                  label: 'Projects',
                  icon: AppIcon.board,
                  tint: AppColors.mockTintCyan,
                  iconColor: AppColors.cyan400,
                ),
              ),
            ],
          ),
          _ChartCard(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text('ERP', style: AppTextStyles.mockBrandTitle),
            Text('+', style: AppTextStyles.mockBrandPlus),
          ],
        ),
        SizedBox.square(
          dimension: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryCss,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.label,
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  final String label;
  final AppIcon icon;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return MockTile(
      radius: 12,
      padding: 10,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            MockTintBox(tint: tint, icon: icon, iconColor: iconColor),
            Text(
              label,
              style: AppTextStyles.mockModuleLabel,
              maxLines: 1,
              // Like the prototype's CSS: a long label ("Accounting") may run
              // past the tile edge rather than being clipped.
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  static const _bars = <(double, bool)>[
    (24, false),
    (36, false),
    (50, true),
    (30, false),
    (42, false),
    (34, true),
  ];

  @override
  Widget build(BuildContext context) {
    return MockTile(
      radius: 12,
      padding: 10,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            const SkeletonBar(width: 70, height: 6),
            SizedBox(
              height: 56,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 5,
                children: [
                  for (final (height, highlight) in _bars)
                    Expanded(
                      child: SkeletonBar(
                        width: double.infinity,
                        height: height,
                        highlight: highlight,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
