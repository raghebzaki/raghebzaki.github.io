import '../entities/ecosystem.dart';
import '../entities/experience.dart';
import '../entities/profile.dart';
import '../entities/project.dart';
import '../entities/skill.dart';

abstract interface class PortfolioRepository {
  Profile get profile;
  List<Project> get featuredProjects;
  Ecosystem get ecosystem;

  /// The skills bento tiles, in display order.
  List<SkillTile> get skills;

  /// Newest start first.
  List<Experience> get experience;
}
