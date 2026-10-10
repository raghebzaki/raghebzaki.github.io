import '../entities/ecosystem.dart';
import '../entities/experience.dart';
import '../entities/profile.dart';
import '../entities/project.dart';
import '../entities/skill.dart';

abstract interface class PortfolioRepository {
  Profile get profile;
  List<Project> get featuredProjects;
  Ecosystem get ecosystem;

  /// The skill categories, in display order.
  List<SkillCategory> get skills;

  /// Newest start first.
  List<Experience> get experience;
}
