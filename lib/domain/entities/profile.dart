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
    required this.avatarAsset,
    required this.avatarLabel,
    required this.statusLabel,
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

  /// Bundled asset path of the portrait shown in the hero.
  final String avatarAsset;

  /// Accessible description of the portrait.
  final String avatarLabel;

  /// Availability status shown on (and announced for) the avatar's dot.
  final String statusLabel;
  final List<Stat> stats;
  final List<SocialLink> socials;

  /// The first social link of [type], if any.
  SocialLink? socialOf(SocialType type) {
    for (final social in socials) {
      if (social.type == type) return social;
    }
    return null;
  }

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
    avatarAsset,
    avatarLabel,
    statusLabel,
    stats,
    socials,
  ];
}
