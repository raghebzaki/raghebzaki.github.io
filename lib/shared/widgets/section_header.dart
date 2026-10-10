import 'package:flutter/widgets.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/shell/section_id.dart';

/// Eyebrow label plus title, shared by every titled section.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.section, required this.title, super.key});

  /// Title using the standard section title style.
  SectionHeader.text(this.section, String title, {super.key})
    : title = _SectionTitleText(title);

  final SectionId section;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.eyebrow!.toUpperCase(), style: AppTextStyles.eyebrow),
          const SizedBox(height: AppSpacing.s12),
          title,
        ],
      ),
    );
  }
}

class _SectionTitleText extends StatelessWidget {
  const _SectionTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.typography.sectionTitle);
  }
}
