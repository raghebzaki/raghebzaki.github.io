import 'package:flutter/widgets.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      top: AppLayout.defaultTop,
      child: SectionHeader.text(
        SectionId.skills,
        'Architecture first. Stores last.',
      ),
    );
  }
}
