import 'package:flutter/widgets.dart';
import 'package:url_launcher/link.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/project.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_icon.dart';

/// Publisher-page button label for a store.
String publisherStoreLabel(StoreType store) => switch (store) {
  StoreType.appStore => 'App Store',
  StoreType.playStore => 'Google Play',
  StoreType.appGallery => 'AppGallery',
  StoreType.windows => 'Windows',
  StoreType.webApp => 'Web App',
  StoreType.website => 'Website',
};

/// "CloudSoft5 on" followed by a button per store developer page.
class PublisherLinks extends StatelessWidget {
  const PublisherLinks({required this.links, super.key});

  final List<StoreLink> links;

  static const String caption = 'CloudSoft5 on';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(caption, style: AppTextStyles.caption),
        for (final link in links) _PublisherButton(link: link),
      ],
    );
  }
}

class _PublisherButton extends StatelessWidget {
  const _PublisherButton({required this.link});

  final StoreLink link;

  @override
  Widget build(BuildContext context) {
    final label = publisherStoreLabel(link.store);
    return Link(
      uri: Uri.parse(link.url),
      target: LinkTarget.blank,
      builder: (context, follow) => AppButton.secondary(
        label: label,
        trailingIcon: AppIcon.arrowUpRight,
        onPressed: follow,
        isLink: true,
        compact: true,
        semanticLabel: 'CloudSoft5 apps on $label',
      ),
    );
  }
}
