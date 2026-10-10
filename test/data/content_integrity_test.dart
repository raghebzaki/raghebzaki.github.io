import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/profile.dart';
import 'package:ragheb_portfolio/domain/entities/project.dart';

int _prefix(String label) =>
    int.parse(RegExp(r'^\d+').firstMatch(label)!.group(0)!);

void main() {
  const repo = StaticPortfolioRepository();

  test('4 featured projects with unique ids', () {
    final ids = repo.featuredProjects.map((p) => p.id).toList();
    expect(ids.length, 4);
    expect(ids.toSet().length, 4);
  });

  test('store links are https', () {
    for (final p in repo.featuredProjects) {
      for (final l in p.links) {
        expect(l.url, startsWith('https://'), reason: '${p.id} ${l.store}');
      }
    }
  });

  test('social links are https except email', () {
    for (final s in repo.profile.socials) {
      if (s.type == SocialType.email) {
        expect(s.url, startsWith('mailto:'));
      } else {
        expect(s.url, startsWith('https://'));
      }
    }
  });

  test('ecosystem families are consistent', () {
    final eco = repo.ecosystem;
    for (final f in eco.families) {
      expect(_prefix(f.countLabel), lessThanOrEqualTo(f.apps.length));
      expect(f.apps.toSet().length, f.apps.length, reason: f.title);
    }
    expect(eco.appCount, 34);
    expect(eco.appCount, greaterThanOrEqualTo(_prefix(eco.totalLabel)));
  });

  test('experience is strictly newest-first', () {
    final list = repo.experience;
    for (var i = 1; i < list.length; i++) {
      expect(
        list[i - 1].start.isAfter(list[i].start),
        isTrue,
        reason: '${list[i - 1].company} vs ${list[i].company}',
      );
    }
  });

  test('every end is after its start', () {
    for (final e in repo.experience) {
      if (e.end != null) {
        expect(e.end!.isAfter(e.start), isTrue, reason: e.company);
      }
      for (final g in e.engagements) {
        if (g.end != null) {
          expect(g.end!.isAfter(g.start), isTrue, reason: e.company);
        }
      }
    }
  });

  test('Sutumatic has Huawei platform but no AppGallery link', () {
    final p = repo.featuredProjects.firstWhere((p) => p.id == 'sutumatic-pos');
    expect(p.platforms, contains(AppPlatform.huawei));
    expect(p.links.map((l) => l.store), isNot(contains(StoreType.appGallery)));
  });

  test('CFI tags contain Android and iOS', () {
    final p = repo.featuredProjects.firstWhere(
      (p) => p.id == 'cfi-service-center',
    );
    expect(p.tags, containsAll(['Android', 'iOS']));
  });

  test('email is well-formed', () {
    expect(repo.profile.email, matches(RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')));
  });
}
