import 'package:equatable/equatable.dart';

import 'project.dart';

enum AppFamilyId { erp, serviceCenter }

class AppFamily extends Equatable {
  const AppFamily({
    required this.id,
    required this.title,
    required this.countLabel,
    required this.apps,
  });

  final AppFamilyId id;
  final String title;
  final String countLabel;
  final List<String> apps;

  @override
  List<Object?> get props => [id, title, countLabel, apps];
}

/// A client app shown in the "also shipped" block.
final class ShowcaseApp extends Equatable {
  const ShowcaseApp({required this.name, this.nativeName, required this.links});

  final String name;
  final String? nativeName;
  final List<StoreLink> links;

  @override
  List<Object?> get props => [name, nativeName, links];
}

final class AppShowcase extends Equatable {
  const AppShowcase({
    required this.title,
    required this.subtitle,
    required this.apps,
  });

  final String title;
  final String subtitle;
  final List<ShowcaseApp> apps;

  @override
  List<Object?> get props => [title, subtitle, apps];
}

class Ecosystem extends Equatable {
  const Ecosystem({
    required this.totalLabel,
    required this.summary,
    required this.families,
    required this.publisherLinks,
    required this.moreApps,
  });

  final String totalLabel;
  final String summary;
  final List<AppFamily> families;

  /// The CloudSoft5 developer pages on each store.
  final List<StoreLink> publisherLinks;
  final AppShowcase moreApps;

  int get appCount =>
      families.fold(0, (total, family) => total + family.apps.length);

  @override
  List<Object?> get props => [
    totalLabel,
    summary,
    families,
    publisherLinks,
    moreApps,
  ];
}
