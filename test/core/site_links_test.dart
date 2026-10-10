import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/utils/site_links.dart';

void main() {
  const path = 'files/Ragheb_Zaki_CV.pdf';

  test('resolves under the site root', () {
    expect(
      resolveSiteUrl(path, base: Uri.parse('https://x.io/')),
      Uri.parse('https://x.io/files/Ragheb_Zaki_CV.pdf'),
    );
    expect(
      resolveSiteUrl(path, base: Uri.parse('https://x.io/skills')),
      Uri.parse('https://x.io/files/Ragheb_Zaki_CV.pdf'),
    );
  });

  test('resolves under a project-site base', () {
    expect(
      resolveSiteUrl(path, base: Uri.parse('https://x.io/repo/skills')),
      Uri.parse('https://x.io/repo/files/Ragheb_Zaki_CV.pdf'),
    );
  });
}
