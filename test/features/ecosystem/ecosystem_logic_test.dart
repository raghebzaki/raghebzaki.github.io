import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/ecosystem.dart';
import 'package:ragheb_portfolio/features/ecosystem/cubit/ecosystem_filter_cubit.dart';
import 'package:ragheb_portfolio/features/ecosystem/ecosystem_logic.dart';

void main() {
  final ecosystem = const StaticPortfolioRepository().ecosystem;

  group('EcosystemFilterCubit', () {
    test('starts on all', () {
      expect(EcosystemFilterCubit().state, EcosystemFilter.all);
    });

    blocTest<EcosystemFilterCubit, EcosystemFilter>(
      'select(erp) emits erp',
      build: EcosystemFilterCubit.new,
      act: (cubit) => cubit.select(EcosystemFilter.erp),
      expect: () => [EcosystemFilter.erp],
    );

    blocTest<EcosystemFilterCubit, EcosystemFilter>(
      're-selecting the same filter emits nothing',
      build: EcosystemFilterCubit.new,
      act: (cubit) => cubit
        ..select(EcosystemFilter.erp)
        ..select(EcosystemFilter.erp)
        ..select(EcosystemFilter.all)
        ..select(EcosystemFilter.all),
      expect: () => [EcosystemFilter.erp, EcosystemFilter.all],
    );
  });

  group('chipDimmed', () {
    const table = <(EcosystemFilter, AppFamilyId, bool)>[
      (EcosystemFilter.all, AppFamilyId.erp, false),
      (EcosystemFilter.all, AppFamilyId.serviceCenter, false),
      (EcosystemFilter.erp, AppFamilyId.erp, false),
      (EcosystemFilter.erp, AppFamilyId.serviceCenter, true),
      (EcosystemFilter.serviceCenter, AppFamilyId.erp, true),
      (EcosystemFilter.serviceCenter, AppFamilyId.serviceCenter, false),
    ];
    for (final (filter, family, expected) in table) {
      test('$filter x $family -> $expected', () {
        expect(chipDimmed(filter, family), expected);
      });
    }
  });

  test('filterOptions reads labels and counts from data', () {
    final options = filterOptions(ecosystem);
    expect(
      [for (final o in options) '${o.label} · ${o.count}'],
      ['All · 32+', 'CloudSoft5 ERP · 22+', 'Service Center · 10+'],
    );
    expect(
      [for (final o in options) o.filter],
      [EcosystemFilter.all, EcosystemFilter.erp, EcosystemFilter.serviceCenter],
    );
  });

  test('visibleCount', () {
    expect(visibleCount(EcosystemFilter.all, ecosystem), 34);
    expect(visibleCount(EcosystemFilter.erp, ecosystem), 24);
    expect(visibleCount(EcosystemFilter.serviceCenter, ecosystem), 10);
  });

  test('filterAnnouncement', () {
    expect(
      filterAnnouncement(EcosystemFilter.all, ecosystem),
      'Showing all 34 apps',
    );
    expect(
      filterAnnouncement(EcosystemFilter.erp, ecosystem),
      'Showing 24 CloudSoft5 ERP apps',
    );
    expect(
      filterAnnouncement(EcosystemFilter.serviceCenter, ecosystem),
      'Showing 10 Service Center apps',
    );
  });
}
