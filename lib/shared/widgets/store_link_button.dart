import 'package:flutter/widgets.dart';
import 'package:url_launcher/link.dart';

import '../../domain/entities/project.dart';
import 'app_button.dart';
import 'app_icon.dart';

/// Short button label for a store (the domain label stays untouched).
String storeShortLabel(StoreType store) {
  switch (store) {
    case StoreType.playStore:
      return 'Play Store';
    case StoreType.appStore:
      return 'App Store';
    case StoreType.appGallery:
      return 'AppGallery';
    case StoreType.windows:
      return 'Windows';
  }
}

/// Opens a store listing of the app called [ownerName] in a new tab.
class StoreLinkButton extends StatelessWidget {
  const StoreLinkButton({
    required this.ownerName,
    required this.link,
    super.key,
  });

  final String ownerName;
  final StoreLink link;

  @override
  Widget build(BuildContext context) {
    final label = storeShortLabel(link.store);
    return Link(
      uri: Uri.parse(link.url),
      target: LinkTarget.blank,
      builder: (context, follow) => AppButton.secondary(
        label: label,
        trailingIcon: AppIcon.arrowUpRight,
        onPressed: follow,
        isLink: true,
        compact: true,
        semanticLabel: '$ownerName on $label',
      ),
    );
  }
}
