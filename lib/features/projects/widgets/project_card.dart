import 'package:flutter/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/project.dart';
import 'mockups/mockup_for.dart';
import 'phone_frame.dart';
import 'project_info.dart';

/// Whether the phone sits beside the text for a card of [innerWidth]
/// (content width inside the padding).
bool phoneBesideText(double innerWidth) =>
    innerWidth >=
    AppLayout.phoneWidth + AppLayout.cardPadding + AppLayout.cardInfoMin;

/// One featured project: phone mockup plus copy, highlighted on hover or when
/// keyboard focus is inside.
class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.project, required this.flagship, super.key});

  final Project project;
  final bool flagship;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  bool _focusInside = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final highlighted = _hovered || _focusInside;

    final phone = PhoneFrame(
      accent: project.accent,
      lifted: highlighted && !reduceMotion,
      screen: mockupFor(project),
    );

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: (value) => setState(() => _focusInside = value),
          child: AnimatedContainer(
            duration: reduceMotion ? Duration.zero : AppDurations.fast,
            padding: const EdgeInsets.all(AppLayout.cardPadding),
            decoration: BoxDecoration(
              color: widget.flagship ? null : AppColors.surface,
              gradient: widget.flagship ? AppGradients.surfaceCard : null,
              borderRadius: AppRadii.cardBorder,
              boxShadow: highlighted ? AppShadows.cardHover : const [],
            ),
            // Painted over the box so the 1px border takes no layout space
            // (the card is exactly phoneHeight + 2 x padding tall).
            foregroundDecoration: BoxDecoration(
              borderRadius: AppRadii.cardBorder,
              border: Border.all(
                color: highlighted
                    ? AppColors.cyanBorderHover
                    : AppColors.borderSubtle,
              ),
            ),
            child: LayoutBuilder(
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
            ),
          ),
        ),
      ),
    );
  }
}
