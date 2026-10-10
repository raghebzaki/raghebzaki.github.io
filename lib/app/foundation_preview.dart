import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/responsive/responsive_context.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../domain/repositories/portfolio_repository.dart';

/// Phase 1-2 token sheet. Replaced by the real page in Phase 5.
class FoundationPreview extends StatelessWidget {
  const FoundationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PortfolioRepository>();
    final profile = repo.profile;
    final type = context.typography;
    final width = context.viewportWidth;

    return Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppLayout.maxContent),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.gutter,
                  vertical: AppSpacing.s64,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FOUNDATION PREVIEW',
                      style: AppTextStyles.eyebrow,
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppGradients.text.createShader(bounds),
                      child: Text(profile.name, style: type.display),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(profile.title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: AppSpacing.s16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppLayout.leadMax,
                      ),
                      child: Text(profile.summary, style: type.lead),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      '${context.screen.name} · ${width.toStringAsFixed(0)} px',
                      style: AppTextStyles.tag,
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Text(
                      '${repo.featuredProjects.length} projects · '
                      '${repo.ecosystem.appCount} apps · '
                      '${repo.experience.length} roles',
                      style: AppTextStyles.tag,
                    ),
                    const SizedBox(height: AppSpacing.s64),
                    const _SectionLabel('Colors'),
                    const _SwatchGroup(
                      title: 'Background and surfaces',
                      swatches: [
                        _Swatch('background', AppColors.background),
                        _Swatch('surface', AppColors.surface),
                        _Swatch('surfaceRaised', AppColors.surfaceRaised),
                        _Swatch('surfaceInset', AppColors.surfaceInset),
                        _Swatch('surfaceHover', AppColors.surfaceHover),
                        _Swatch('segmentActive', AppColors.segmentActive),
                      ],
                    ),
                    const _SwatchGroup(
                      title: 'Text',
                      swatches: [
                        _Swatch('textPrimary', AppColors.textPrimary),
                        _Swatch('textEmphasis', AppColors.textEmphasis),
                        _Swatch('textSecondary', AppColors.textSecondary),
                        _Swatch('textMuted', AppColors.textMuted),
                        _Swatch('onAccent', AppColors.onAccent),
                      ],
                    ),
                    const _SwatchGroup(
                      title: 'Accents',
                      swatches: [
                        _Swatch('cyan400', AppColors.cyan400),
                        _Swatch('cyan300', AppColors.cyan300),
                        _Swatch('sky400', AppColors.sky400),
                        _Swatch('sky300', AppColors.sky300),
                        _Swatch('blue500', AppColors.blue500),
                        _Swatch('blue400', AppColors.blue400),
                        _Swatch('blue300', AppColors.blue300),
                        _Swatch('cyan700', AppColors.cyan700),
                        _Swatch('blue600', AppColors.blue600),
                        _Swatch('blue700', AppColors.blue700),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s48),
                    const _SectionLabel('Type scale'),
                    _TypeSample(
                      'display',
                      type.display,
                      'Ship fast, ship well',
                    ),
                    _TypeSample(
                      'lead',
                      type.lead,
                      'Scalable cross-platform apps',
                    ),
                    _TypeSample(
                      'sectionTitle',
                      type.sectionTitle,
                      'Featured work',
                    ),
                    _TypeSample(
                      'ecosystemTitle',
                      type.ecosystemTitle,
                      'The enterprise ecosystem',
                    ),
                    _TypeSample(
                      'ctaTitle',
                      type.ctaTitle,
                      "Let's build together",
                    ),
                    const _TypeSample(
                      'statValue',
                      AppTextStyles.statValue,
                      '100K+',
                    ),
                    const _TypeSample(
                      'cardTitle',
                      AppTextStyles.cardTitle,
                      'Al-Riyada',
                    ),
                    const _TypeSample(
                      'tileTitle',
                      AppTextStyles.tileTitle,
                      'ERP+ SPA',
                    ),
                    const _TypeSample(
                      'body',
                      AppTextStyles.body,
                      'Seamless browsing, checkout and tracking.',
                    ),
                    const _TypeSample(
                      'bodySmall',
                      AppTextStyles.bodySmall,
                      'Seamless browsing, checkout and tracking.',
                    ),
                    const _TypeSample(
                      'caption',
                      AppTextStyles.caption,
                      'Cairo, Egypt',
                    ),
                    const _TypeSample(
                      'button',
                      AppTextStyles.button,
                      'View work',
                    ),
                    const _TypeSample(
                      'buttonPrimary',
                      AppTextStyles.buttonPrimary,
                      'Download CV',
                      onAccent: true,
                    ),
                    const _TypeSample('nav', AppTextStyles.nav, 'Experience'),
                    const _TypeSample(
                      'brand',
                      AppTextStyles.brand,
                      'RZ  Portfolio',
                    ),
                    _TypeSample(
                      'eyebrow',
                      AppTextStyles.eyebrow,
                      'selected work'.toUpperCase(),
                    ),
                    const _TypeSample('tag', AppTextStyles.tag, 'E-Commerce'),
                    const _TypeSample(
                      'chip',
                      AppTextStyles.chip,
                      'HR ERP+ Tracking',
                    ),
                    const _TypeSample(
                      'segment',
                      AppTextStyles.segment,
                      'CloudSoft5 ERP',
                    ),
                    const _TypeSample(
                      'Arabic fallback (NotoSansArabic Bold)',
                      TextStyle(
                        fontFamily: AppFonts.sans,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      'متجر الريادة',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s20),
      child: Text(text, style: AppTextStyles.cardTitle),
    );
  }
}

class _Swatch {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  String get hex =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

class _SwatchGroup extends StatelessWidget {
  const _SwatchGroup({required this.title, required this.swatches});

  final String title;
  final List<_Swatch> swatches;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppLayout.gridGap,
            runSpacing: AppLayout.gridGap,
            children: [for (final s in swatches) _SwatchTile(s)],
          ),
        ],
      ),
    );
  }
}

class _SwatchTile extends StatelessWidget {
  const _SwatchTile(this.swatch);

  final _Swatch swatch;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: swatch.color,
              borderRadius: AppRadii.buttonBorder,
              border: Border.all(color: AppColors.border),
            ),
            child: const SizedBox(height: 56, width: double.infinity),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(swatch.name, style: AppTextStyles.caption),
          Text(swatch.hex, style: AppTextStyles.tag),
        ],
      ),
    );
  }
}

class _TypeSample extends StatelessWidget {
  const _TypeSample(
    this.name,
    this.style,
    this.sample, {
    this.onAccent = false,
  });

  final String name;
  final TextStyle style;
  final String sample;
  final bool onAccent;

  @override
  Widget build(BuildContext context) {
    final text = Text(sample, style: style);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.tag),
          const SizedBox(height: AppSpacing.s4),
          if (onAccent)
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: AppRadii.buttonBorder,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                  vertical: AppSpacing.s12,
                ),
                child: text,
              ),
            )
          else
            text,
        ],
      ),
    );
  }
}
