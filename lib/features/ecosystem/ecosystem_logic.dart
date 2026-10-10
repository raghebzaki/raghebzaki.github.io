import 'package:equatable/equatable.dart';

import '../../domain/entities/ecosystem.dart';
import 'cubit/ecosystem_filter_cubit.dart';

/// One segment of the filter bar.
class FilterOption extends Equatable {
  const FilterOption({
    required this.filter,
    required this.label,
    required this.count,
  });

  final EcosystemFilter filter;
  final String label;
  final String count;

  @override
  List<Object?> get props => [filter, label, count];
}

/// The family a filter selects, or null for [EcosystemFilter.all].
AppFamilyId? familyOf(EcosystemFilter filter) => switch (filter) {
  EcosystemFilter.all => null,
  EcosystemFilter.erp => AppFamilyId.erp,
  EcosystemFilter.serviceCenter => AppFamilyId.serviceCenter,
};

EcosystemFilter filterFor(AppFamilyId family) => switch (family) {
  AppFamilyId.erp => EcosystemFilter.erp,
  AppFamilyId.serviceCenter => EcosystemFilter.serviceCenter,
};

/// "All" followed by one option per family, labels and counts from data.
List<FilterOption> filterOptions(Ecosystem ecosystem) => [
  FilterOption(
    filter: EcosystemFilter.all,
    label: 'All',
    count: ecosystem.totalLabel,
  ),
  for (final family in ecosystem.families)
    FilterOption(
      filter: filterFor(family.id),
      label: family.title,
      count: family.countLabel,
    ),
];

/// Whether chips of [family] are faded out under [filter].
bool chipDimmed(EcosystemFilter filter, AppFamilyId family) {
  final selected = familyOf(filter);
  return selected != null && selected != family;
}

AppFamily _family(Ecosystem ecosystem, AppFamilyId id) =>
    ecosystem.families.firstWhere((family) => family.id == id);

/// How many apps stay at full strength under [filter].
int visibleCount(EcosystemFilter filter, Ecosystem ecosystem) {
  final selected = familyOf(filter);
  if (selected == null) return ecosystem.appCount;
  return _family(ecosystem, selected).apps.length;
}

/// Screen-reader text for the current filter.
String filterAnnouncement(EcosystemFilter filter, Ecosystem ecosystem) {
  final selected = familyOf(filter);
  final count = visibleCount(filter, ecosystem);
  if (selected == null) return 'Showing all $count apps';
  return 'Showing $count ${_family(ecosystem, selected).title} apps';
}
