import '../entities/ecosystem.dart';
import '../entities/experience.dart';
import '../entities/profile.dart';
import '../entities/project.dart';

abstract interface class PortfolioRepository {
  Profile get profile;
  List<Project> get featuredProjects;
  Ecosystem get ecosystem;

  /// Newest start first.
  List<Experience> get experience;
}
