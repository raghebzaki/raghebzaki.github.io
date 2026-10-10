import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/repositories/portfolio_repository.dart';
import '../cubit/navigation_cubit.dart';
import '../section_id.dart';

/// Logo + name; scrolls back to the top.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  static const double _size = 30;

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioRepository>().profile;
    return Semantics(
      link: true,
      label: '${profile.name}, back to top',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: AppRadii.brandBorder,
        onTap: () => context.read<NavigationCubit>().scrollTo(SectionId.hero),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: AppRadii.brandBorder,
              ),
              child: SizedBox.square(
                dimension: _size,
                child: Center(
                  child: Text(
                    profile.initials,
                    style: AppTextStyles.buttonPrimary.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Flexible(
              child: Text(
                profile.name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.brand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
