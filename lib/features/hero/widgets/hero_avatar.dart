import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/profile.dart';

/// The hero portrait: a cyan ring with a soft glow, the photo (initials when
/// the asset cannot be loaded) and a pulsing "open to opportunities" dot.
class HeroAvatar extends StatefulWidget {
  const HeroAvatar(this.profile, {super.key});

  final Profile profile;

  @override
  State<HeroAvatar> createState() => _HeroAvatarState();
}

class _HeroAvatarState extends State<HeroAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppDurations.statusPulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return SizedBox.square(
      dimension: AppLayout.avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              key: const ValueKey('avatar-ring'),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.cyanBorderHover,
                  width: AppLayout.avatarRing,
                ),
                boxShadow: AppShadows.avatarGlow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppLayout.avatarRing),
                child: ClipOval(
                  child: _AvatarPhoto(
                    profile: profile,
                    fadeDuration: reduceMotion
                        ? Duration.zero
                        : AppDurations.fast,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: AppLayout.statusDotInset,
            bottom: AppLayout.statusDotInset,
            child: Tooltip(
              message: profile.statusLabel,
              child: Semantics(
                label: profile.statusLabel,
                excludeSemantics: true,
                child: _StatusDot(pulse: reduceMotion ? null : _pulse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPhoto extends StatelessWidget {
  const _AvatarPhoto({required this.profile, required this.fadeDuration});

  final Profile profile;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return ColoredBox(
      color: AppColors.avatarFill,
      child: Image.asset(
        profile.avatarAsset,
        width: AppLayout.avatarPhoto,
        height: AppLayout.avatarPhoto,
        fit: BoxFit.cover,
        cacheWidth: (AppLayout.avatarPhoto * pixelRatio).ceil(),
        filterQuality: FilterQuality.medium,
        semanticLabel: profile.avatarLabel,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: fadeDuration,
            child: child,
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _InitialsFallback(profile.initials),
      ),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  const _InitialsFallback(this.initials);

  final String initials;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.primaryCss,
      ),
      child: SizedBox.square(
        dimension: AppLayout.avatarPhoto,
        child: Center(
          child: Text(
            initials,
            style: AppTextStyles.buttonPrimary.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// The 16px green dot with its page-coloured ring and, unless [pulse] is
/// null (reduced motion), an expanding fading halo behind it.
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.pulse});

  final Animation<double>? pulse;

  @override
  Widget build(BuildContext context) {
    const circle = BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.statusGreen,
    );
    final pulse = this.pulse;
    return SizedBox.square(
      dimension: AppLayout.statusDotSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (pulse != null)
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: pulse,
                  builder: (context, _) => Opacity(
                    opacity: AppOpacity.statusHalo * (1 - pulse.value),
                    child: Transform.scale(
                      key: const ValueKey('avatar-status-halo'),
                      scale: 1 + (AppLayout.statusHaloScale - 1) * pulse.value,
                      child: const DecoratedBox(decoration: circle),
                    ),
                  ),
                ),
              ),
            ),
          const Positioned.fill(
            child: DecoratedBox(
              key: ValueKey('avatar-status-dot'),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.statusGreen,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.background,
                    spreadRadius: AppLayout.statusDotRing,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
