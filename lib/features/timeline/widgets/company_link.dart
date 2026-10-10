import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_icon.dart';

/// The company badge, name and ↗ of a timeline role, as one link to the
/// company's page (opens in a new tab). Highlights on hover and keyboard
/// focus; the arrow is always visible so touch users can tell it is a link.
class CompanyLink extends StatefulWidget {
  const CompanyLink({
    required this.company,
    required this.url,
    required this.monogram,
    required this.accent,
    this.logoAsset,
    super.key,
  });

  final String company;
  final String url;
  final String monogram;

  /// Company logo; [monogram] is the fallback when absent or it fails to load.
  final String? logoAsset;

  /// The role's rail-dot colour, reused for the badge accent.
  final Color accent;

  @override
  State<CompanyLink> createState() => _CompanyLinkState();
}

class _CompanyLinkState extends State<CompanyLink> {
  static const double _ringWidth = 2;
  static const double _ringGap = 2;

  bool _hovered = false;
  bool _focused = false;

  bool get _active => _hovered || _focused;

  bool get _showRing =>
      _focused &&
      FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppDurations.fast;
    final label = 'Visit ${widget.company} on LinkedIn';
    final accent = widget.accent;

    return Link(
      uri: Uri.parse(widget.url),
      target: LinkTarget.blank,
      builder: (context, follow) => Tooltip(
        message: label,
        excludeFromSemantics: true,
        // Its own node: without `container` the rest of the card (meta, pills,
        // highlights) merged into this link's label.
        child: Semantics(
          container: true,
          link: true,
          label: label,
          excludeSemantics: true,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: follow,
                onHover: (value) => setState(() => _hovered = value),
                onFocusChange: (value) => setState(() => _focused = value),
                mouseCursor: SystemMouseCursors.click,
                borderRadius: AppRadii.buttonBorder,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      key: const ValueKey('company-badge'),
                      duration: duration,
                      width: AppLayout.companyBadgeSize,
                      height: AppLayout.companyBadgeSize,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceInset,
                        borderRadius: AppRadii.buttonBorder,
                        border: Border.all(
                          color: _active
                              ? accent.withValues(
                                  alpha: AppOpacity.companyBadgeHoverBorder,
                                )
                              : AppColors.borderTag,
                        ),
                        boxShadow: _active
                            ? [
                                BoxShadow(
                                  color: accent.withValues(
                                    alpha: AppOpacity.companyBadgeGlow,
                                  ),
                                  blurRadius: 16,
                                  spreadRadius: -4,
                                ),
                              ]
                            : const [],
                      ),
                      child: ClipRRect(
                        // Inside the 1px border.
                        borderRadius: BorderRadius.circular(
                          AppRadii.button - 1,
                        ),
                        child: _BadgeContent(
                          logoAsset: widget.logoAsset,
                          monogram: _Monogram(widget.monogram, accent: accent),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s14),
                    Flexible(
                      child: AnimatedDefaultTextStyle(
                        duration: duration,
                        style: AppTextStyles.tileTitle.copyWith(
                          color: _active
                              ? AppColors.cyan300
                              : AppColors.textPrimary,
                        ),
                        child: Text(widget.company),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s6),
                    AppIconView(
                      AppIcon.arrowUpRight,
                      size: AppLayout.companyArrowSize,
                      color: _active ? AppColors.cyan300 : AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              if (_showRing)
                Positioned(
                  left: -(_ringGap + _ringWidth),
                  top: -(_ringGap + _ringWidth),
                  right: -(_ringGap + _ringWidth),
                  bottom: -(_ringGap + _ringWidth),
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppRadii.button + _ringGap + _ringWidth,
                        ),
                        border: Border.all(
                          color: AppColors.cyan400,
                          width: _ringWidth,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The logo on a white tile (the logos are drawn on white), or [monogram] when
/// there is no logo, while it loads, or if it fails to load.
class _BadgeContent extends StatelessWidget {
  const _BadgeContent({required this.logoAsset, required this.monogram});

  final String? logoAsset;
  final Widget monogram;

  @override
  Widget build(BuildContext context) {
    final asset = logoAsset;
    if (asset == null) return monogram;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      cacheWidth: (AppLayout.companyBadgeSize * dpr).ceil(),
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null && !wasSynchronouslyLoaded) return monogram;
        return ColoredBox(
          color: AppColors.logoTile,
          child: Padding(
            padding: const EdgeInsets.all(AppLayout.companyLogoPadding),
            child: child,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => monogram,
    );
  }
}

class _Monogram extends StatelessWidget {
  const _Monogram(this.text, {required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('company-monogram'),
      child: Text(
        text,
        // Lifted toward the text colour so dark accents (blue700) stay
        // legible on the dark badge.
        style: AppTextStyles.companyMonogram.copyWith(
          color: Color.lerp(accent, AppColors.textPrimary, 0.35),
        ),
      ),
    );
  }
}
