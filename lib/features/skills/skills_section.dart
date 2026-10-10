import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';
import 'widgets/skills_grid.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = context.read<PortfolioRepository>().skills;
    return SectionContainer(
      top: AppLayout.defaultTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader.text(
            SectionId.skills,
            'Architecture first. Stores last.',
          ),
          SkillsGrid(categories: skills),
        ],
      ),
    );
  }
}
