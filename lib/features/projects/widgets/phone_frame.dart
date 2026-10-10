import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/project.dart';
import '../accent_style.dart';
import 'mockups/mock_primitives.dart';

/// A decorative phone. Structure is Transform -> RepaintBoundary -> phone, so
/// the hover lift only moves a cached layer.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    required this.accent,
    required this.lifted,
    required this.screen,
    super.key,
  });

  final AccentTone accent;
  final bool lifted;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppDurations.phoneLift;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: lifted ? 1 : 0),
      duration: duration,
      curve: AppCurves.phoneLift,
      child: RepaintBoundary(
        child: SizedBox(
          width: AppLayout.phoneWidth,
          height: AppLayout.phoneHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.phoneBody,
              borderRadius: AppRadii.phoneOuterBorder,
              border: Border.all(color: AppColors.phoneBorder),
              boxShadow: phoneShadowFor(accent),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppLayout.phoneInset),
              child: ClipRRect(
                borderRadius: AppRadii.phoneInnerBorder,
                child: ColoredBox(
                  color: AppColors.phoneScreen,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Decorative: fixed text scale so system text size can't
                      // overflow it, and hidden from assistive tech.
                      ExcludeSemantics(
                        child: MediaQuery.withNoTextScaling(child: screen),
                      ),
                      const Positioned(
                        top: AppLayout.notchTop,
                        left: 0,
                        right: 0,
                        child: Center(child: MockNotch()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      builder: (context, t, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.translationValues(0, -AppLayout.phoneLift * t, 0)
          ..rotateZ(AppLayout.phoneLiftAngle * t),
        child: child,
      ),
    );
  }
}
