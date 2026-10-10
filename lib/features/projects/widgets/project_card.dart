import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/glow_card.dart';
import 'mockups/mockup_for.dart';
import 'phone_frame.dart';
import 'project_info.dart';

/// Whether the phone sits beside the text for a card of [innerWidth]
/// (content width inside the padding).
bool phoneBesideText(double innerWidth) =>
    innerWidth >=
    AppLayout.phoneWidth + AppLayout.cardPadding + AppLayout.cardInfoMin;

/// One featured project: phone mockup plus copy, highlighted on hover or when
/// keyboard focus is inside (see [GlowCard]).
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, required this.flagship, super.key});

  final Project project;
  final bool flagship;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      color: AppColors.surface,
      gradient: flagship ? AppGradients.surfaceCard : null,
      builder: (context, highlighted) {
        final reduceMotion = MediaQuery.disableAnimationsOf(context);
        final phone = PhoneFrame(
          accent: project.accent,
          lifted: highlighted && !reduceMotion,
          screen: mockupFor(project),
        );
        return LayoutBuilder(
          builder: (context, constraints) {
            final info = ProjectInfo(project: project);
            if (phoneBesideText(constraints.maxWidth)) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppLayout.phoneHeight,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    phone,
                    const SizedBox(width: AppLayout.cardPadding),
                    Expanded(child: info),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: phone),
                const SizedBox(height: AppLayout.cardPadding),
                info,
              ],
            );
          },
        );
      },
    );
  }
}
