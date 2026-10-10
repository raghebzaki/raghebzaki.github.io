import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';
import 'widgets/project_grid.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.read<PortfolioRepository>().featuredProjects;
    return SectionContainer(
      top: AppLayout.projectsTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader.text(
            SectionId.projects,
            'Shipped to real users, on real stores.',
          ),
          ProjectGrid(projects: projects),
        ],
      ),
    );
  }
}
