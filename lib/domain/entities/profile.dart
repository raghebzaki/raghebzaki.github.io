import 'package:equatable/equatable.dart';

class Stat extends Equatable {
  const Stat({required this.value, required this.suffix, required this.label});

  final int value;
  final String suffix;
  final String label;

  /// e.g. `100K+`.
  String get display => '$value$suffix';

  @override
  List<Object?> get props => [value, suffix, label];
}

enum SocialType { github, linkedin, email }

class SocialLink extends Equatable {
  const SocialLink({
    required this.type,
    required this.label,
    required this.url,
  });

  final SocialType type;
  final String label;
  final String url;

  @override
  List<Object?> get props => [type, label, url];
}

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.initials,
    required this.title,
    required this.summary,
    required this.email,
    required this.location,
    required this.availability,
    required this.resumePath,
    required this.stats,
    required this.socials,
  });

  final String name;
  final String initials;
  final String title;
  final String summary;
  final String email;
  final String location;
  final String availability;

  /// Relative path (respects the document base-href).
  final String resumePath;
  final List<Stat> stats;
  final List<SocialLink> socials;

  @override
  List<Object?> get props => [
    name,
    initials,
    title,
    summary,
    email,
    location,
    availability,
    resumePath,
    stats,
    socials,
  ];
}
