import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/data/static_portfolio_repository.dart';
import 'package:ragheb_portfolio/domain/entities/experience.dart';
import 'package:ragheb_portfolio/domain/entities/profile.dart';
import 'package:ragheb_portfolio/domain/entities/project.dart';

int _prefix(String label) =>
    int.parse(RegExp(r'^\d+').firstMatch(label)!.group(0)!);

void main() {
  const repo = StaticPortfolioRepository();

  test('5 featured projects with unique ids, ZCreatorz first', () {
    final ids = repo.featuredProjects.map((p) => p.id).toList();
    expect(ids, [
      'zcreatorz',
      'al-riyada',
      'erp-plus-spa',
      'sutumatic-pos',
      'cfi-service-center',
    ]);
  });

  test('ZCreatorz content', () {
    final z = repo.featuredProjects.first;
    expect(z.name, 'ZCreatorz');
    expect(z.nativeName, 'المنصة الشاملة لصناع المحتوى');
    expect(z.badge, 'All 6 Platforms Supported');
    expect(z.glyph, ProjectGlyph.camera);
    expect(
      z.description,
      'The all-in-one super-app for media creators, rental providers, and '
      'production studios. Engineered from a single unified Flutter codebase '
      'running seamlessly across Mobile, Web, and Desktop environments.',
    );
    expect(z.stack, [
      'Clean Architecture',
      'BLoC',
      'Shorebird (OTA)',
      'Adaptive UI',
    ]);
    expect(z.platforms, {
      AppPlatform.web,
      AppPlatform.ios,
      AppPlatform.android,
      AppPlatform.macos,
      AppPlatform.windows,
      AppPlatform.linux,
    });
    expect(z.links, const [
      StoreLink(store: StoreType.webApp, url: 'https://zcreatorz.app/'),
      StoreLink(
        store: StoreType.appStore,
        url: 'https://apps.apple.com/eg/app/zcreatorz/id1579333148',
      ),
      StoreLink(
        store: StoreType.playStore,
        url: 'https://play.google.com/store/apps/details?id=com.for_exper.app',
      ),
      StoreLink(store: StoreType.website, url: 'https://www.zcreatorz.com/'),
    ]);
  });

  test('5 roles with LinkedIn company pages and monograms', () {
    final roles = repo.experience;
    expect(roles.map((r) => r.company), [
      'Cairo Photo Club',
      'CloudSoft5',
      'Sutum ICT Consulting',
      'Coddiv',
      'Sejall Technology',
    ]);
    expect(roles.map((r) => r.companyUrl), [
      'https://www.linkedin.com/company/cairo-photo-club',
      'https://www.linkedin.com/company/cloudsoft5/',
      'https://www.linkedin.com/company/sutum-ict-consulting/',
      'https://www.linkedin.com/company/coddiv/',
      'https://www.linkedin.com/company/sejall-technology/',
    ]);
    expect(roles.map((r) => r.monogram), ['CP', 'C5', 'SI', 'CD', 'SJ']);
  });

  test('Cairo Photo Club role', () {
    final cpc = repo.experience.first;
    expect(cpc.role, 'Senior Flutter Developer (Part-time)');
    expect(cpc.location, 'Cairo, Egypt / Remote');
    expect(cpc.employmentType, EmploymentType.partTime);
    expect(cpc.isCurrent, isTrue);
    expect(cpc.period, 'Aug 2026 – Present');
    expect(cpc.highlights, hasLength(4));
    expect(
      cpc.highlights.first,
      startsWith('Co-engineering and scaling the ZCreatorz'),
    );
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

  test('CFI platforms are Android and iOS', () {
    final p = repo.featuredProjects.firstWhere(
      (p) => p.id == 'cfi-service-center',
    );
    expect(p.platforms, {AppPlatform.android, AppPlatform.ios});
  });

  test('more apps: exact names, native names and store links', () {
    final apps = repo.ecosystem.moreApps.apps;
    expect(repo.ecosystem.moreApps.title, 'Also shipped at Coddiv');
    expect(apps.map((a) => a.name), [
      'Holy Karbala Real Estate',
      'Prime Car Rental',
      'MTA Logistics',
    ]);
    expect(apps.map((a) => a.nativeName), [
      'عقارات كربلاء المقدسة',
      'برايم ـ لتأجير السيارات',
      null,
    ]);
    expect(apps[0].links.map((l) => l.url), [
      'https://play.google.com/store/apps/details?id=com.coddiv.karballa',
      'https://apps.apple.com/us/app/%D8%B9%D9%82%D8%A7%D8%B1%D8%A7%D8%AA-%D9%83%D8%B1%D8%A8%D9%84%D8%A7%D8%A1-%D8%A7%D9%84%D9%85%D9%82%D8%AF%D8%B3%D8%A9/id6742713156',
    ]);
    expect(apps[1].links.map((l) => l.url), [
      'https://play.google.com/store/apps/details?id=com.coddiv.prime',
    ]);
    expect(apps[2].links.map((l) => l.url), [
      'https://play.google.com/store/apps/details?id=com.coddiv.shipping_express',
    ]);
  });

  test('no Marsa anywhere in ecosystem content', () {
    final eco = repo.ecosystem;
    final names = [
      for (final f in eco.families) ...f.apps,
      for (final a in eco.moreApps.apps) a.name,
      eco.summary,
      eco.moreApps.title,
      eco.moreApps.subtitle,
    ];
    for (final name in names) {
      expect(name.toLowerCase(), isNot(contains('marsa')), reason: name);
    }
  });

  test('publisher links are the three CloudSoft5 developer pages', () {
    final links = repo.ecosystem.publisherLinks;
    expect(links.map((l) => l.store), [
      StoreType.appStore,
      StoreType.playStore,
      StoreType.appGallery,
    ]);
    expect(links.map((l) => l.url), [
      'https://apps.apple.com/eg/developer/com-cloudsoft5-erp/id1422490126',
      'https://play.google.com/store/apps/dev?id=6416475393253964776&hl=ar',
      'https://appgallery.huawei.com/tab/appdetailCommon%7CC115490003%7Cautomore%7Cdoublecolumncardwithstar%7C903547',
    ]);
    expect(links.map((l) => Uri.parse(l.url).host), [
      'apps.apple.com',
      'play.google.com',
      'appgallery.huawei.com',
    ]);
  });

  test('family counts are unchanged', () {
    final eco = repo.ecosystem;
    expect(eco.totalLabel, '32+');
    expect(eco.families.map((f) => f.countLabel), ['22+', '10+']);
    expect(eco.families.map((f) => f.apps.length), [24, 10]);
  });

  test('phones and dialable', () {
    expect(repo.profile.phones, ['+20 1289181425', '+20 1097307097']);
    expect(repo.profile.whatsappPhone, '+20 1289181425');
    expect(dialable('+20 1289181425'), '+201289181425');
    expect(dialable('+20 1097307097'), '+201097307097');
  });

  test('email is well-formed', () {
    expect(repo.profile.email, matches(RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')));
  });
}
