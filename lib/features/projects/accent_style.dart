import 'package:flutter/painting.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/project.dart';

/// Phone mockup shadow (drop shadow plus accent glow) for an accent tone.
List<BoxShadow> phoneShadowFor(AccentTone accent) {
  switch (accent) {
    case AccentTone.cyan:
      return AppShadows.phoneCyan;
    case AccentTone.blue:
      return AppShadows.phoneBlue;
  }
}
