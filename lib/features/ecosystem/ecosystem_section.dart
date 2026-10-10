import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/responsive/responsive_value.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/ecosystem.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/glow_card.dart';
import '../../shared/widgets/gradient_text.dart';
import '../../shared/widgets/section_container.dart';
import '../shell/section_id.dart';
import 'widgets/app_chip_cloud.dart';
import 'widgets/ecosystem_filter_bar.dart';
import 'widgets/more_apps.dart';
import 'widgets/publisher_links.dart';

const _cardPadding = FluidValue(24, 48, 0.04);

class EcosystemSection extends StatelessWidget {
  const EcosystemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ecosystem = context.read<PortfolioRepository>().ecosystem;
    final padding = _cardPadding.resolve(context.viewportWidth);
    return SectionContainer(
      top: AppLayout.defaultTop,
      child: GlowCard(
        clip: true,
        padding: EdgeInsets.all(padding),
        // The glow is placed relative to the card edge (as in the prototype),
        // so its offsets subtract the padding; the Stack must not clip, or the
        // circle is cut into a hard-edged rectangle at the content box. The
        // card's own rounded clip trims it instead.
        builder: (context, _) => Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: AppLayout.ecosystemGlowTop - padding,
              right: AppLayout.ecosystemGlowRight - padding,
              width: AppLayout.ecosystemGlowSize,
              height: AppLayout.ecosystemGlowSize,
              child: const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.ecosystemGlow,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(ecosystem: ecosystem),
                const SizedBox(height: AppSpacing.s32),
                AppChipCloud(ecosystem: ecosystem),
                MoreApps(showcase: ecosystem.moreApps),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Title block on the left, filter on the right; the filter wraps below when
/// they do not fit (CSS `flex-wrap` + `space-between` + `align-items: end`).
class _Header extends StatelessWidget {
  const _Header({required this.ecosystem});

  final Ecosystem ecosystem;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: AppSpacing.s24,
      runSpacing: AppSpacing.s24,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.ecosystemHeaderMax,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SectionId.ecosystem.eyebrow!.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: AppSpacing.s12),
              HighlightedTitle(
                lead: 'One engineering system, ',
                highlight: '${ecosystem.totalLabel} apps',
                trail: '.',
                style: context.typography.ecosystemTitle,
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(ecosystem.summary, style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.s16),
              PublisherLinks(links: ecosystem.publisherLinks),
            ],
          ),
        ),
        EcosystemFilterBar(ecosystem: ecosystem),
      ],
    );
  }
}
