import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/section_container.dart';
import 'widgets/contact_panel.dart';

/// Closing call to action plus the footer line.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioRepository>().profile;
    return SectionContainer(
      top: AppLayout.defaultTop,
      bottom: AppLayout.footerBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ContactPanel(),
          const SizedBox(height: AppSpacing.s28),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
            children: [
              Text(
                '${profile.name} · ${profile.title}',
                style: AppTextStyles.caption,
              ),
              Text(
                'Built with Flutter Web · © ${DateTime.now().year}',
                style: AppTextStyles.footerMono,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
