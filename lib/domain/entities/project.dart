import 'package:equatable/equatable.dart';

enum AppPlatform {
  android('Android'),
  ios('iOS'),
  huawei('Huawei'),
  windows('Windows');

  const AppPlatform(this.label);
  final String label;
}

enum StoreType {
  playStore('Play Store'),
  appStore('App Store'),
  appGallery('Huawei AppGallery'),
  windows('Windows');

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

enum ProjectMockup { storefront, erpModules, posRegister, memberPortal }

enum AccentTone { cyan, blue }

class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    this.nativeName,
    required this.badge,
    required this.summary,
    required this.description,
    required this.tags,
    required this.platforms,
    required this.links,
    required this.mockup,
    required this.accent,
  });

  final String id;
  final String name;
  final String? nativeName;
  final String badge;
  final String summary;
  final String description;
  final List<String> tags;
  final Set<AppPlatform> platforms;
  final List<StoreLink> links;
  final ProjectMockup mockup;
  final AccentTone accent;

  @override
  List<Object?> get props => [id];
}
