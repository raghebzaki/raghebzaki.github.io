import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/gradient_text.dart';
import '../../shared/widgets/section_container.dart';

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
          Center(
            child: HighlightedTitle(
              lead: "Let's build your next ",
              highlight: 'Flutter app',
              trail: '.',
              textAlign: TextAlign.center,
              style: context.typography.ctaTitle,
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppLayout.ctaTextMax),
              child: Text(
                profile.availability,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(fontSize: 16),
              ),
            ),
          ),
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
              Text('© ${DateTime.now().year}', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
