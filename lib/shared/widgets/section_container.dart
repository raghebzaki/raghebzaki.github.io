import 'package:flutter/widgets.dart';

import '../../core/theme/app_spacing.dart';

/// Centers [child], constrains it to [AppLayout.maxContent] and applies the
/// page gutter plus the section's vertical padding.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    this.top = AppLayout.defaultTop,
    this.bottom = 0,
    super.key,
  });

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppLayout.maxContent),
        // Always take the full column width so start-aligned content sits on
        // the column edge instead of shrinking and being centered.
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppLayout.gutter,
              top,
              AppLayout.gutter,
              bottom,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
