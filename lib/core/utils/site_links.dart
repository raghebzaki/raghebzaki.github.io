/// Resolves [relative] (e.g. `files/cv.pdf`) against the current page URL.
///
/// Every route is a single segment under the base href, so resolving against
/// the current URL always lands under the base (this also works for a
/// `/<repo>/` project site). Needed because url_launcher's `Link` routes
/// scheme-less URIs through the app router.
Uri resolveSiteUrl(String relative, {Uri? base}) =>
    (base ?? Uri.base).resolve(relative);
