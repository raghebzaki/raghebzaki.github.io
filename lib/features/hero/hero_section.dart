import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/gradient_text.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/tag_pill.dart';
import 'widgets/cta_row.dart';
import 'widgets/hero_backdrop.dart';
import 'widgets/stats_bar.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

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
