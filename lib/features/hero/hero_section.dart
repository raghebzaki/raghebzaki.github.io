import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/gradient_text.dart';
import '../../shared/widgets/section_container.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioRepository>().profile;
    final typography = context.typography;
    return SectionContainer(
      top: AppSpacing.s72,
      bottom: AppSpacing.s40,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppLayout.heroMax),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.cyanTint,
                  borderRadius: AppRadii.pillBorder,
                  border: Border.all(color: AppColors.cyanBorderHover),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 32),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: AppSpacing.s4,
                    ),
                    child: Text(
                      profile.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.chip.copyWith(
                        color: AppColors.cyan300,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s28),
              GradientText(
                profile.name,
                textAlign: TextAlign.center,
                style: typography.display,
              ),
              const SizedBox(height: AppSpacing.s28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppLayout.leadMax),
                child: Text(
                  profile.summary,
                  textAlign: TextAlign.center,
                  style: typography.lead,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
