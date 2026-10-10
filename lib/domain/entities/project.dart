import 'package:equatable/equatable.dart';

/// Declaration order is the order platform pills are shown in.
enum AppPlatform {
  web('Web'),
  ios('iOS'),
  android('Android'),
  macos('macOS'),
  windows('Windows'),
  linux('Linux'),
  huawei('Huawei');

  const AppPlatform(this.label);
  final String label;
}

enum StoreType {
  playStore('Play Store'),
  appStore('App Store'),
  appGallery('Huawei AppGallery'),
  windows('Windows'),
  webApp('Web App'),
  website('Website');

  const StoreType(this.label);
  final String label;
}

class StoreLink extends Equatable {
  const StoreLink({required this.store, required this.url});

  final StoreType store;
  final String url;

  @override
  List<Object?> get props => [store, url];
}

/// What the app is about; presentation maps it to an app-icon glyph.
enum ProjectGlyph { cart, modules, register, members, camera }

enum AccentTone { cyan, blue }

class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    this.nativeName,
    required this.badge,
    required this.description,
    required this.stack,
    required this.platforms,
    required this.links,
    required this.glyph,
    required this.accent,
  });

  final String id;
  final String name;
  final String? nativeName;
  final String badge;
  final String description;

  /// Feature/tech pills shown on the card.
  final List<String> stack;
  final Set<AppPlatform> platforms;
  final List<StoreLink> links;
  final ProjectGlyph glyph;
  final AccentTone accent;

  @override
  List<Object?> get props => [id];
}
