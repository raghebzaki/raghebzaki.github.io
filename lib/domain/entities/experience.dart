import 'package:equatable/equatable.dart';

import 'year_month.dart';

enum EmploymentType {
  fullTime('Full-time'),
  partTime('Part-time');

  const EmploymentType(this.label);
  final String label;
}

class Engagement extends Equatable {
  const Engagement({required this.type, required this.start, this.end});

  final EmploymentType type;
  final YearMonth start;
  final YearMonth? end;

  @override
  List<Object?> get props => [type, start, end];
}

class Experience extends Equatable {
  const Experience({
    required this.company,
    required this.shortName,
    required this.role,
    required this.location,
    required this.start,
    this.end,
    this.employmentType,
    this.engagements = const [],
    required this.highlights,
    required this.companyUrl,
    required this.monogram,
    this.logoAsset,
  });

  final String company;
  final String shortName;
  final String role;
  final String location;

  /// The company's public page (LinkedIn).
  final String companyUrl;

  /// Two-letter mark shown in the company badge when there is no logo (or it
  /// fails to load).
  final String monogram;

  /// The company logo shown in the badge.
  final String? logoAsset;

  /// A plain type badge (e.g. Part-time) for roles without [engagements].
  final EmploymentType? employmentType;
  final YearMonth start;

  /// `null` means the role is current ("Present").
  final YearMonth? end;
  final List<Engagement> engagements;
  final List<String> highlights;

  bool get isCurrent => end == null;

  /// e.g. `Dec 2024 – Present`.
  String get period => '${start.label} – ${end?.label ?? 'Present'}';

  @override
  List<Object?> get props => [
    company,
    shortName,
    role,
    location,
    start,
    end,
    employmentType,
    engagements,
    highlights,
    companyUrl,
    monogram,
    logoAsset,
  ];
}
