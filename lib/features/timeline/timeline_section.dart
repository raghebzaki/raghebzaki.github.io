import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';
import 'widgets/role_card.dart';

/// Career timeline: a gradient rail with one dotted card per role.
class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = context.read<PortfolioRepository>().experience;
    return SectionContainer(
      top: AppLayout.defaultTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader.text(SectionId.timeline, 'Where the work happened.'),
          Semantics(
            container: true,
            child: Stack(
              children: [
                const Positioned(
                  left: AppLayout.timelineRailLeft,
                  top: AppLayout.timelineRailInset,
                  bottom: AppLayout.timelineRailInset,
                  width: AppLayout.timelineRailWidth,
                  child: ExcludeSemantics(
                    child: DecoratedBox(
                      key: ValueKey('timeline-rail'),
                      decoration: BoxDecoration(
                        gradient: AppGradients.timelineRail,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppLayout.timelineGutter,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < roles.length; i++) ...[
                        if (i > 0) const SizedBox(height: AppSpacing.s16),
                        RoleCard(experience: roles[i], index: i),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
