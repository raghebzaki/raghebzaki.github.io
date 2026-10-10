import 'package:flutter/widgets.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      top: AppLayout.projectsTop,
      child: SectionHeader.text(
        SectionId.projects,
        'Shipped to real users, on real stores.',
      ),
    );
  }
}
