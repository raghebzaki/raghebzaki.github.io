import 'package:flutter/widgets.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// Icons compiled at build time (see `assets/icons`).
enum AppIcon {
  download('assets/icons/download.svg'),
  github('assets/icons/github.svg'),
  linkedin('assets/icons/linkedin.svg'),
  mail('assets/icons/mail.svg');

  const AppIcon(this.assetPath);

  final String assetPath;
}

/// A decorative, single-colour icon.
class AppIconView extends StatelessWidget {
  const AppIconView(
    this.icon, {
    required this.color,
    this.size = 16,
    super.key,
  });

  final AppIcon icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: VectorGraphic(
          loader: AssetBytesLoader(icon.assetPath),
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
