import 'package:equatable/equatable.dart';

/// Accent colour family of a skill category.
enum SkillTone { cyan, blue, indigo, amber }

/// Which icon represents a skill category.
enum SkillGlyph { architecture, database, network, delivery }

/// A group of related skills with a short description.
final class SkillCategory extends Equatable {
  const SkillCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.skills,
    required this.tone,
    required this.glyph,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> skills;
  final SkillTone tone;
  final SkillGlyph glyph;

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    description,
    skills,
    tone,
    glyph,
  ];
}
