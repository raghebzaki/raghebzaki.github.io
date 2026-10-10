import 'package:equatable/equatable.dart';

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

class Ecosystem extends Equatable {
  const Ecosystem({
    required this.totalLabel,
    required this.summary,
    required this.families,
  });

  final String totalLabel;
  final String summary;
  final List<AppFamily> families;

  int get appCount =>
      families.fold(0, (total, family) => total + family.apps.length);

  @override
  List<Object?> get props => [totalLabel, summary, families];
}
