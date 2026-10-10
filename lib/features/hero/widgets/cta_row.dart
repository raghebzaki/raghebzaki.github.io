import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/link.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/site_links.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/repositories/portfolio_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../shell/cubit/navigation_cubit.dart';
import '../../shell/section_id.dart';

/// Download CV, GitHub, LinkedIn and Contact actions.
class CtaRow extends StatelessWidget {
  const CtaRow({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioRepository>().profile;
    final github = profile.socialOf(SocialType.github);
    final linkedin = profile.socialOf(SocialType.linkedin);

    return Wrap(
      spacing: AppLayout.ctaGap,
      runSpacing: AppLayout.ctaGap,
      alignment: WrapAlignment.center,
      children: [
        Link(
          uri: resolveSiteUrl(profile.resumePath),
          target: LinkTarget.blank,
          builder: (context, follow) => AppButton.primary(
            label: 'Download CV',
            icon: AppIcon.download,
            onPressed: follow,
            isLink: true,
          ),
        ),
        if (github != null) _socialButton(github, AppIcon.github),
        if (linkedin != null) _socialButton(linkedin, AppIcon.linkedin),
        AppButton.secondary(
          label: 'Contact',
          icon: AppIcon.mail,
          onPressed: () =>
              context.read<NavigationCubit>().scrollTo(SectionId.contact),
        ),
      ],
    );
  }

  static Widget _socialButton(SocialLink social, AppIcon icon) => Link(
    uri: Uri.parse(social.url),
    target: LinkTarget.blank,
    builder: (context, follow) => AppButton.secondary(
      label: social.label,
      icon: icon,
      onPressed: follow,
      isLink: true,
    ),
  );
}
