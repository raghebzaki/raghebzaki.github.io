import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'mock_primitives.dart';

/// Sutumatic POS: product grid with a receipt and charge button.
class PosRegisterScreen extends StatelessWidget {
  const PosRegisterScreen({super.key});

  static const _widths = <double>[26, 22, 28, 24, 30, 20];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: mockScreenPaddingBottom,
      child: Column(
        spacing: mockGap,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Sutumatic',
                  style: AppTextStyles.mockPosTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('POS', style: AppTextStyles.mockMono),
            ],
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: MockPillRow(skeletonWidths: [22, 26, 20]),
          ),
          for (var row = 0; row < 2; row++)
            Row(
              spacing: 6,
              children: [
                for (var col = 0; col < 3; col++)
                  Expanded(
                    child: _ProductTile(
                      index: row * 3 + col,
                      titleWidth: _widths[row * 3 + col],
                    ),
                  ),
              ],
            ),
          const Spacer(),
          const _Receipt(),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.index, required this.titleWidth});

  final int index;
  final double titleWidth;

  @override
  Widget build(BuildContext context) {
    return MockTile(
      radius: 10,
      padding: 5,
      selected: index == 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          MockImage(height: 34, radius: 7, selected: index == 1),
          SkeletonBar(width: titleWidth, height: 4),
        ],
      ),
    );
  }
}

class _Receipt extends StatelessWidget {
  const _Receipt();

  @override
  Widget build(BuildContext context) {
    return const MockTile(
      radius: 14,
      padding: 10,
      child: Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBar(width: 60, height: 5),
              SkeletonBar(width: 26, height: 5),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBar(width: 48, height: 5),
              SkeletonBar(width: 22, height: 5),
            ],
          ),
          SizedBox(
            height: 34,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.primaryCss,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text('Charge', style: AppTextStyles.mockCharge),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
