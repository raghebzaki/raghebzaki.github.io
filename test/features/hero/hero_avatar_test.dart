import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/core/theme/app_colors.dart';
import 'package:ragheb_portfolio/core/theme/app_spacing.dart';
import 'package:ragheb_portfolio/data/content/profile.dart';
import 'package:ragheb_portfolio/domain/entities/profile.dart';
import 'package:ragheb_portfolio/features/hero/hero_section.dart';
import 'package:ragheb_portfolio/features/hero/widgets/hero_avatar.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/shared/widgets/tag_pill.dart';

import '../../support/app_harness.dart';

Future<void> pumpAvatar(WidgetTester tester, {Profile? custom}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: HeroAvatar(custom ?? profile))),
    ),
  );
}

void disableAnimations(WidgetTester tester) {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

Finder get halo => find.byKey(const ValueKey('avatar-status-halo'));

void main() {
  setUpAll(loadAppFonts);

  testWidgets('renders the asset with its semantic label', (tester) async {
    await pumpAvatar(tester);
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.semanticLabel, 'Photo of Ragheb Zaki');
    expect(image.width, AppLayout.avatarPhoto);
    expect(image.height, AppLayout.avatarPhoto);
    expect(image.fit, BoxFit.cover);
    expect(image.filterQuality, FilterQuality.medium);
    final provider = image.image as ResizeImage;
    expect(
      provider.width,
      (AppLayout.avatarPhoto * tester.view.devicePixelRatio).ceil(),
    );
    expect(
      (provider.imageProvider as AssetImage).assetName,
      profile.avatarAsset,
    );
  });

  testWidgets('has a 2px cyan ring with the soft glow', (tester) async {
    await pumpAvatar(tester);
    final ring = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('avatar-ring')),
    );
    final decoration = ring.decoration as BoxDecoration;
    expect(decoration.shape, BoxShape.circle);
    expect(decoration.boxShadow, AppShadows.avatarGlow);
    final border = decoration.border! as Border;
    expect(border.top.color, AppColors.cyanBorderHover);
    expect(border.top.width, 2);
    expect(
      tester.getSize(find.byKey(const ValueKey('avatar-ring'))),
      const Size.square(88),
    );
  });

  testWidgets('status dot is labelled "Open to opportunities"', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAvatar(tester);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('avatar-status-dot'))),
      matchesSemantics(label: 'Open to opportunities'),
    );
    final dot = tester.getRect(find.byKey(const ValueKey('avatar-status-dot')));
    final ring = tester.getRect(find.byKey(const ValueKey('avatar-ring')));
    expect(dot.size, const Size.square(16));
    expect(ring.right - dot.right, 2);
    expect(ring.bottom - dot.bottom, 2);
    expect(find.byTooltip('Open to opportunities'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('the halo pulses', (tester) async {
    await pumpAvatar(tester);
    expect(halo, findsOneWidget);
    double scale() => tester.widget<Transform>(halo).transform.storage[0];
    final start = scale();
    expect(start, closeTo(1, 0.05));
    await tester.pump(const Duration(milliseconds: 1000));
    final middle = scale();
    expect(middle, greaterThan(start));
    // The loop restarts after 2000 ms.
    await tester.pump(const Duration(milliseconds: 1100));
    expect(scale(), lessThan(middle));
  });

  testWidgets('the halo is absent under reduced motion', (tester) async {
    disableAnimations(tester);
    await pumpAvatar(tester);
    expect(halo, findsNothing);
    expect(find.byKey(const ValueKey('avatar-status-dot')), findsOneWidget);
    // Nothing is left animating, so this settles.
    await tester.pumpAndSettle();
  });

  testWidgets('falls back to the initials when the asset is missing', (
    tester,
  ) async {
    final broken = Profile(
      name: profile.name,
      initials: profile.initials,
      title: profile.title,
      summary: profile.summary,
      email: profile.email,
      phones: profile.phones,
      whatsappPhone: profile.whatsappPhone,
      location: profile.location,
      availability: profile.availability,
      resumePath: profile.resumePath,
      avatarAsset: 'assets/images/does_not_exist.jpg',
      avatarLabel: profile.avatarLabel,
      statusLabel: profile.statusLabel,
      stats: profile.stats,
      socials: profile.socials,
    );
    await pumpAvatar(tester, custom: broken);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('RZ'), findsOneWidget);
  });

  testWidgets('sits centered above the role pill in the hero', (tester) async {
    await pumpSection(tester, SectionId.hero);
    final avatar = tester.getRect(find.byType(HeroAvatar));
    final pill = tester.getRect(
      find.descendant(
        of: find.byType(HeroSection),
        matching: find.widgetWithText(TagPill, profile.title),
      ),
    );
    expect(avatar.bottom, lessThan(pill.top));
    expect(pill.top - avatar.bottom, closeTo(24, 0.5));
    expect(avatar.center.dx, closeTo(720, 1));
    expect(avatar.size, const Size.square(88));
  });
}
