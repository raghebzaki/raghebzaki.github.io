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
    this.engagements = const [],
    required this.highlights,
  });

  final String company;
  final String shortName;
  final String role;
  final String location;
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
    engagements,
    highlights,
  ];
}
