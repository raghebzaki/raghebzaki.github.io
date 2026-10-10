import 'package:flutter/widgets.dart';
import 'package:url_launcher/link.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/profile.dart';

/// Every phone number as a `tel:` link, separated by dots.
class PhoneLinks extends StatelessWidget {
  const PhoneLinks({required this.phones, super.key});

  final List<String> phones;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s6,
      children: [
        for (var i = 0; i < phones.length; i++) ...[
          if (i > 0) const Text('·', style: AppTextStyles.caption),
          Link(
            uri: Uri(scheme: 'tel', path: dialable(phones[i])),
            builder: (context, follow) =>
                _PhoneLink(phone: phones[i], onPressed: follow),
          ),
        ],
      ],
    );
  }
}

class _PhoneLink extends StatefulWidget {
  const _PhoneLink({required this.phone, required this.onPressed});

  final String phone;
  final VoidCallback? onPressed;

  @override
  State<_PhoneLink> createState() => _PhoneLinkState();
}

class _PhoneLinkState extends State<_PhoneLink> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    return Semantics(
      link: true,
      label: 'Call ${widget.phone}',
      excludeSemantics: true,
      onTap: widget.onPressed,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppLayout.minTapTarget,
            ),
            child: Center(
              widthFactor: 1,
              child: Text(
                widget.phone,
                style: AppTextStyles.phoneLink.copyWith(
                  color: active ? AppColors.cyan300 : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
