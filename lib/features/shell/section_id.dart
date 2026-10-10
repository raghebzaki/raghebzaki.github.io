/// The page sections, in scroll order. [index] doubles as the list index.
enum SectionId {
  hero('/'),
  projects(
    '/projects',
    navLabel: 'Projects',
    eyebrow: '01 / Featured Projects',
  ),
  ecosystem(
    '/ecosystem',
    navLabel: 'Ecosystem',
    eyebrow: '02 / Enterprise Ecosystem',
  ),
  skills('/skills', navLabel: 'Skills', eyebrow: '03 / Skills'),
  timeline('/timeline', navLabel: 'Timeline', eyebrow: '04 / Timeline'),
  contact('/contact', navLabel: 'Contact');

  const SectionId(this.path, {this.navLabel, this.eyebrow});

  /// URL path for this section.
  final String path;

  /// Label in the navigation, or null when not a nav item.
  final String? navLabel;

  /// Eyebrow shown above the section title, or null when it has none.
  final String? eyebrow;

  /// Resolves a URL path (trailing slash and case insensitive); unknown
  /// paths resolve to [hero].
  static SectionId fromPath(String path) {
    var normalised = path.toLowerCase();
    while (normalised.length > 1 && normalised.endsWith('/')) {
      normalised = normalised.substring(0, normalised.length - 1);
    }
    for (final id in values) {
      if (id.path == normalised) return id;
    }
    return hero;
  }

  /// Sections shown in the navigation.
  static List<SectionId> get navItems => [
    for (final id in values)
      if (id.navLabel != null) id,
  ];
}
