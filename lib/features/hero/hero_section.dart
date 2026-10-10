import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/gradient_text.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/tag_pill.dart';
import 'widgets/cta_row.dart';
import 'widgets/hero_avatar.dart';
import 'widgets/hero_backdrop.dart';
import 'widgets/stats_bar.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    // Decode the portrait at its display size so it is ready with the first
    // hero paint. A missing asset falls back to the initials in the avatar.
    final profile = context.read<PortfolioRepository>().profile;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    precacheImage(
      ResizeImage(
        AssetImage(profile.avatarAsset),
        width: (AppLayout.avatarPhoto * pixelRatio).ceil(),
      ),
      context,
      onError: (error, stackTrace) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioRepository>().profile;
    final typography = context.typography;
    return Stack(
      children: [
        const Positioned.fill(child: HeroBackdrop()),
        SectionContainer(
          top: AppSpacing.s72,
          bottom: AppSpacing.s40,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppLayout.heroMax),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroAvatar(profile),
                  const SizedBox(height: AppSpacing.s24),
                  TagPill(
                    profile.title,
                    tone: TagTone.hot,
                    size: TagSize.large,
                  ),
                  const SizedBox(height: AppSpacing.s28),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    child: GradientText(
                      profile.name,
                      textAlign: TextAlign.center,
                      style: typography.display,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppLayout.leadMax,
                    ),
                    child: Text(
                      profile.summary,
                      textAlign: TextAlign.center,
                      style: typography.lead,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s28),
                  const CtaRow(),
                  const SizedBox(height: AppSpacing.s64),
                  StatsBar(stats: profile.stats),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
