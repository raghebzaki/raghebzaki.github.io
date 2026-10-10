import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_icon.dart';
import 'mock_primitives.dart';

/// Al-Riyada: Arabic storefront with search, banner, categories and products.
class StorefrontScreen extends StatelessWidget {
  const StorefrontScreen({required this.title, super.key});

  /// Store name shown in the header (the project's native name).
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: mockScreenPadding,
      child: Column(
        spacing: mockGap,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.mockStoreTitle,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const AppIconView(
                AppIcon.cart,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const _SearchField(),
          const _Banner(),
          const Align(
            alignment: Alignment.centerLeft,
            child: MockPillRow(skeletonWidths: [24, 28, 22]),
          ),
          const Row(
            spacing: 8,
            children: [
              Expanded(child: _ProductTile(titleWidth: 60, priceWidth: 32)),
              Expanded(child: _ProductTile(titleWidth: 50, priceWidth: 38)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.phoneInput,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            spacing: 6,
            children: [
              AppIconView(AppIcon.search, size: 12, color: AppColors.textMuted),
              SkeletonBar(width: 70, height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 78,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.banner,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              MockBar(width: 90, height: 8, color: AppColors.white85),
              MockBar(width: 54, height: 6, color: AppColors.white45),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.titleWidth, required this.priceWidth});

  final double titleWidth;
  final double priceWidth;

  @override
  Widget build(BuildContext context) {
    return MockTile(
      radius: 12,
      padding: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          const MockImage(height: 56, radius: 8),
          SkeletonBar(width: titleWidth, height: 5),
          SkeletonBar(width: priceWidth, height: 5, highlight: true),
        ],
      ),
    );
  }
}
