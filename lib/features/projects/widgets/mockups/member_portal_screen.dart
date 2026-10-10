import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'mock_primitives.dart';

/// CFI Service Center: member card and service list.
class MemberPortalScreen extends StatelessWidget {
  const MemberPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: mockScreenPadding,
      child: Column(
        spacing: mockGap,
        children: [
          _Header(),
          _MemberCard(),
          Column(
            spacing: 7,
            children: [
              MockListRow(tint: AppColors.mockTintCyan, skeletonWidth: 70),
              MockListRow(tint: AppColors.mockTintBlue, skeletonWidth: 58),
              MockListRow(tint: AppColors.mockTintCyan, skeletonWidth: 76),
              MockListRow(tint: AppColors.mockTintBlue, skeletonWidth: 50),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 8,
      children: [
        SizedBox(
          height: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryCss,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                widthFactor: 1,
                child: Text('CFI', style: AppTextStyles.mockChip),
              ),
            ),
          ),
        ),
        Flexible(
          child: Text(
            'Service Center',
            style: AppTextStyles.mockServiceCenter,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 96,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.memberCard,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MEMBER', style: AppTextStyles.mockMember),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  MockBar(width: 100, height: 8, color: AppColors.white88),
                  MockBar(width: 64, height: 6, color: AppColors.white45),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
