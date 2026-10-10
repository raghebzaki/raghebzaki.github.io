import 'package:flutter/widgets.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      top: AppLayout.defaultTop,
      child: SectionHeader.text(SectionId.timeline, 'Where the work happened.'),
    );
  }
}
