import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_icon.dart';

/// Screen padding inside the phone: status/notch area on top, 12 on the sides.
const EdgeInsets mockScreenPadding = EdgeInsets.fromLTRB(12, 40, 12, 0);

/// Same, with a bottom inset (POS keeps its receipt off the edge).
const EdgeInsets mockScreenPaddingBottom = EdgeInsets.fromLTRB(12, 40, 12, 12);

/// Vertical rhythm between screen blocks.
const double mockGap = 10;

/// The phone's camera notch.
class MockNotch extends StatelessWidget {
  const MockNotch({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.phoneNotch,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        width: AppLayout.notchWidth,
        height: AppLayout.notchHeight,
      ),
    );
  }
}

/// A rounded solid bar (text placeholder).
class MockBar extends StatelessWidget {
  const MockBar({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 4,
    super.key,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Skeleton text bar; [highlight] paints the cyan to blue gradient.
class SkeletonBar extends StatelessWidget {
  const SkeletonBar({
    required this.width,
    required this.height,
    this.highlight = false,
    super.key,
  });

  final double width;
  final double height;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: highlight ? null : AppColors.skeleton,
          gradient: highlight ? AppGradients.highlight : null,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
      ),
    );
  }
}

/// Category pill: solid cyan when [active], otherwise a muted input fill.
class MockPill extends StatelessWidget {
  const MockPill({this.active = false, required this.skeletonWidth, super.key});

  final bool active;
  final double skeletonWidth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? AppColors.cyan400 : AppColors.phoneInput,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7.5),
        child: active
            ? MockBar(
                width: skeletonWidth,
                height: 5,
                color: AppColors.onAccent,
                radius: 3,
              )
            : SkeletonBar(width: skeletonWidth, height: 5),
      ),
    );
  }
}

/// A row of [MockPill]s.
class MockPillRow extends StatelessWidget {
  const MockPillRow({required this.skeletonWidths, super.key});

  /// Widths for each pill; the first one is the active pill.
  final List<double> skeletonWidths;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        for (var i = 0; i < skeletonWidths.length; i++)
          MockPill(active: i == 0, skeletonWidth: skeletonWidths[i]),
      ],
    );
  }
}

/// A raised tile. [selected] draws the inset cyan ring.
class MockTile extends StatelessWidget {
  const MockTile({
    required this.radius,
    required this.padding,
    required this.child,
    this.selected = false,
    super.key,
  });

  final double radius;
  final double padding;
  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.phoneTile,
        borderRadius: borderRadius,
      ),
      position: DecorationPosition.background,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: selected
              ? Border.all(color: AppColors.phoneSelectedRing)
              : null,
        ),
        position: DecorationPosition.foreground,
        child: Padding(padding: EdgeInsets.all(padding), child: child),
      ),
    );
  }
}

/// The product image placeholder.
class MockImage extends StatelessWidget {
  const MockImage({
    required this.height,
    required this.radius,
    this.selected = false,
    super.key,
  });

  final double height;
  final double radius;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: selected
              ? AppGradients.phoneImageSelected
              : AppGradients.phoneImage,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A 24px rounded square tinted with an accent and an optional icon.
class MockTintBox extends StatelessWidget {
  const MockTintBox({required this.tint, this.icon, this.iconColor, super.key});

  final Color tint;
  final AppIcon? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    return SizedBox.square(
      dimension: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tint,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: icon == null
            ? null
            : Center(child: AppIconView(icon, size: 14, color: iconColor!)),
      ),
    );
  }
}

/// A list row: tinted box, skeleton and trailing chevron.
class MockListRow extends StatelessWidget {
  const MockListRow({
    required this.tint,
    required this.skeletonWidth,
    super.key,
  });

  final Color tint;
  final double skeletonWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.phoneTile,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            spacing: 10,
            children: [
              MockTintBox(tint: tint),
              SkeletonBar(width: skeletonWidth, height: 6),
              const Spacer(),
              const AppIconView(
                AppIcon.chevronRight,
                size: 12,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
