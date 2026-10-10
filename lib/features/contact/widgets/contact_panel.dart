import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/link.dart';

import '../../../core/responsive/responsive_context.dart';
import '../../../core/responsive/responsive_value.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/repositories/portfolio_repository.dart';
import '../../../shared/painters/elliptical_glow.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/gradient_text.dart';
import 'copy_value_button.dart';
import 'phone_links.dart';

/// The closing call-to-action panel.
class ContactPanel extends StatelessWidget {
  const ContactPanel({super.key});

  static const FluidValue _verticalPadding = FluidValue(32, 72, 0.06);
  static const FluidValue _horizontalPadding = FluidValue(24, 56, 0.05);

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioRepository>().profile;
    final width = context.viewportWidth;
    final github = profile.socialOf(SocialType.github);
    final linkedin = profile.socialOf(SocialType.linkedin);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: AppRadii.panelBorder,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: RepaintBoundary(
                  child: CustomPaint(painter: ContactGlowPainter()),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: _verticalPadding.resolve(width),
              horizontal: _horizontalPadding.resolve(width),
            ),
            // Full width: a shrink-wrapped Column would sit at the Stack's
            // top-left instead of centering its content in the panel.
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HighlightedTitle(
                    lead: "Let's build your next ",
                    highlight: 'Flutter app',
                    trail: '.',
                    textAlign: TextAlign.center,
                    style: context.typography.ctaTitle,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppLayout.ctaTextMax,
                    ),
                    child: Text(
                      profile.availability,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  Wrap(
                    spacing: AppLayout.ctaGap,
                    runSpacing: AppLayout.ctaGap,
                    alignment: WrapAlignment.center,
                    children: [
                      Link(
                        uri: Uri(scheme: 'mailto', path: profile.email),
                        target: LinkTarget.self,
                        builder: (context, follow) => AppButton.primary(
                          label: profile.email,
                          icon: AppIcon.mail,
                          onPressed: follow,
                          isLink: true,
                          semanticLabel: 'Email ${profile.email}',
                        ),
                      ),
                      CopyValueButton(
                        value: profile.email,
                        idleLabel: 'Copy email',
                        announcement: 'Email address copied',
                      ),
                      Link(
                        uri: Uri.https(
                          'wa.me',
                          dialable(profile.whatsappPhone).replaceFirst('+', ''),
                        ),
                        target: LinkTarget.blank,
                        builder: (context, follow) => AppButton.secondary(
                          label: 'WhatsApp',
                          icon: AppIcon.message,
                          onPressed: follow,
                          isLink: true,
                          semanticLabel: 'WhatsApp ${profile.whatsappPhone}',
                        ),
                      ),
                      CopyValueButton(
                        value: profile.whatsappPhone,
                        idleLabel: 'Copy phone',
                        icon: AppIcon.phone,
                        announcement: 'Phone number copied',
                      ),
                      if (github != null) _socialButton(github, AppIcon.github),
                      if (linkedin != null)
                        _socialButton(linkedin, AppIcon.linkedin),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  PhoneLinks(phones: profile.phones),
                ],
              ),
            ),
          ),
        ],
      ),
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

/// CSS `radial-gradient(60% 90% at 50% 0%, cyan .12, transparent 70%)`.
class ContactGlowPainter extends CustomPainter {
  const ContactGlowPainter();

  static EllipticalGlow glowFor(Size size) => EllipticalGlow(
    center: Offset(size.width / 2, 0),
    radii: Offset(0.6 * size.width, 0.9 * size.height),
    colors: const [AppColors.contactGlow, AppColors.contactGlowEnd],
    stops: const [0, 0.7],
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final glow = glowFor(size);
    if (glow.isEmpty) return;
    canvas.drawRect(Offset.zero & size, Paint()..shader = glow.createShader());
  }

  @override
  bool shouldRepaint(ContactGlowPainter oldDelegate) => false;
}
