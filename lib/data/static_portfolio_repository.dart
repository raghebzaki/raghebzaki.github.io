import '../domain/entities/ecosystem.dart';
import '../domain/entities/experience.dart';
import '../domain/entities/profile.dart';
import '../domain/entities/project.dart';
import '../domain/entities/skill.dart';
import '../domain/repositories/portfolio_repository.dart';
import 'content/enterprise.dart' as content;
import 'content/experience.dart' as content;
import 'content/profile.dart' as content;
import 'content/projects.dart' as content;
import 'content/skills.dart' as content;

/// Serves the compile-time constant content. Ordering is guaranteed by the
/// content files and enforced by tests (no runtime sorting).
final class StaticPortfolioRepository implements PortfolioRepository {
  const StaticPortfolioRepository();

  @override
  Profile get profile => content.profile;

  @override
  List<Project> get featuredProjects => content.featuredProjects;

  @override
  Ecosystem get ecosystem => content.ecosystem;

  @override
  List<SkillTile> get skills => content.skills;

  @override
  List<Experience> get experience => content.experience;
}
