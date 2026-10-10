import 'package:flutter/widgets.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// Icons compiled at build time (see `assets/icons`).
enum AppIcon {
  download('assets/icons/download.svg'),
  github('assets/icons/github.svg'),
  linkedin('assets/icons/linkedin.svg'),
  mail('assets/icons/mail.svg'),
  cart('assets/icons/cart.svg'),
  users('assets/icons/users.svg'),
  message('assets/icons/message.svg'),
  ledger('assets/icons/ledger.svg'),
  board('assets/icons/board.svg'),
  arrowUpRight('assets/icons/arrow_up_right.svg'),
  copy('assets/icons/copy.svg'),
  check('assets/icons/check.svg'),
  phone('assets/icons/phone.svg'),
  layers('assets/icons/layers.svg'),
  database('assets/icons/database.svg'),
  zap('assets/icons/zap.svg'),
  rocket('assets/icons/rocket.svg'),
  camera('assets/icons/camera.svg');

  const AppIcon(this.assetPath);

  final String assetPath;
}

/// A decorative, single-colour icon.
class AppIconView extends StatelessWidget {
  const AppIconView(
    this.icon, {
    required this.color,
    this.size = 16,
    this.height,
    super.key,
  });

  final AppIcon icon;
  final double size;

  /// Height when the icon is not square (defaults to [size]).
  final double? height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: height ?? size,
        child: VectorGraphic(
          loader: AssetBytesLoader(icon.assetPath),
          width: size,
          height: height ?? size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
