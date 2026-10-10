import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ragheb_portfolio/app/app.dart';
import 'package:ragheb_portfolio/data/content/profile.dart';
import 'package:ragheb_portfolio/features/contact/contact_section.dart';
import 'package:ragheb_portfolio/features/contact/widgets/contact_panel.dart';
import 'package:ragheb_portfolio/features/shell/section_id.dart';
import 'package:ragheb_portfolio/shared/widgets/app_button.dart';
import 'package:url_launcher/link.dart';

import '../../support/app_harness.dart';
import '../../support/settle.dart';

Finder get inContact => find.byType(ContactSection);

Finder button(String label) => find.descendant(
  of: inContact,
  matching: find.widgetWithText(AppButton, label),
);

Link linkAround(WidgetTester tester, Finder button) => tester.widget<Link>(
  find.ancestor(of: button, matching: find.byType(Link)).first,
);

void main() {
  setUpAll(loadAppFonts);

  testWidgets('shows the title, availability and footer', (tester) async {
    await pumpSection(tester, SectionId.contact);
    final title = tester
        .widget<RichText>(
          find.descendant(of: inContact, matching: find.byType(RichText)).first,
        )
        .text
        .toPlainText();
    expect(title, startsWith("Let's build your next "));
    expect(title, endsWith('.'));
    // The highlighted words are an inline gradient text of their own.
    expect(
      find.descendant(of: inContact, matching: find.text('Flutter app')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: inContact, matching: find.text(profile.availability)),
      findsOneWidget,
    );
    expect(find.text('${profile.name} · ${profile.title}'), findsOneWidget);
    expect(
      find.text('Built with Flutter Web · © ${DateTime.now().year}'),
      findsOneWidget,
    );
  });

  // Regression (seen in the browser): the shrink-wrapped content column sat at
  // the panel's left instead of its center.
  for (final width in [1440.0, 390.0]) {
    testWidgets('panel content is centered at ${width.toInt()}px', (
      tester,
    ) async {
      await pumpSection(tester, SectionId.contact, size: Size(width, 900));
      final panel = tester.getRect(find.byType(ContactPanel));
      final inPanel = find.byType(ContactPanel);
      final title = tester.getRect(
        find.descendant(of: inPanel, matching: find.byType(RichText)).first,
      );
      final availability = tester.getRect(
        find.descendant(of: inPanel, matching: find.text(profile.availability)),
      );
      // The button row is centered as a group (each label sits beside its
      // icon, so individual labels are not centered).
      final buttons = find
          .descendant(of: inPanel, matching: find.byType(AppButton))
          .evaluate()
          .map((e) => tester.getRect(find.byWidget(e.widget)))
          .toList();
      final firstRow = buttons.where((r) => r.top == buttons.first.top);
      final row = firstRow.reduce((a, b) => a.expandToInclude(b));
      for (final (name, rect) in [
        ('title', title),
        ('availability', availability),
        ('button row', row),
      ]) {
        expect(rect.center.dx, closeTo(panel.center.dx, 1), reason: name);
      }
    });
  }

  testWidgets('email, GitHub and LinkedIn are links', (tester) async {
    await pumpSection(tester, SectionId.contact);
    final email = linkAround(tester, button(profile.email));
    expect(email.uri, Uri.parse('mailto:zakiragheb32@gmail.com'));
    expect(email.uri.toString(), 'mailto:zakiragheb32@gmail.com');
    expect(email.target, LinkTarget.self);

    final github = linkAround(tester, button('GitHub'));
    expect(github.uri, Uri.parse('https://github.com/raghebzaki'));
    expect(github.target, LinkTarget.blank);

    final linkedin = linkAround(tester, button('LinkedIn'));
    expect(
      linkedin.uri,
      Uri.parse('https://www.linkedin.com/in/ragheb-zaki-752472176/'),
    );
    expect(linkedin.target, LinkTarget.blank);
  });

  testWidgets('WhatsApp opens wa.me in a new tab', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpSection(tester, SectionId.contact);
    final whatsapp = linkAround(tester, button('WhatsApp'));
    expect(whatsapp.uri, Uri.parse('https://wa.me/201289181425'));
    expect(whatsapp.target, LinkTarget.blank);
    expect(find.bySemanticsLabel('WhatsApp +20 1289181425'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('button order: email, copy, WhatsApp, copy phone, socials', (
    tester,
  ) async {
    await pumpSection(tester, SectionId.contact, size: const Size(2000, 900));
    final labels = [
      profile.email,
      'Copy email',
      'WhatsApp',
      'Copy phone',
      'GitHub',
      'LinkedIn',
    ];
    final lefts = [for (final l in labels) tester.getTopLeft(button(l)).dx];
    expect(lefts, [...lefts]..sort());
  });

  testWidgets('every phone is a tel: link with a call label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpSection(tester, SectionId.contact);
    final tel = tester
        .widgetList<Link>(
          find.descendant(of: inContact, matching: find.byType(Link)),
        )
        .where((l) => l.uri?.scheme == 'tel')
        .toList();
    expect(tel.map((l) => l.uri.toString()), [
      'tel:+201289181425',
      'tel:+201097307097',
    ]);
    for (final phone in profile.phones) {
      expect(find.text(phone), findsOneWidget);
      expect(find.bySemanticsLabel('Call $phone'), findsOneWidget);
      expect(tester.getSize(find.text(phone)).height, lessThan(44));
    }
    handle.dispose();
  });

  testWidgets('Copy phone copies the WhatsApp number and confirms for 2s', (
    tester,
  ) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpSection(tester, SectionId.contact);
    final idleWidth = tester.getSize(button('Copy phone')).width;
    await tester.tap(button('Copy phone'));
    await tester.pump();
    await tester.pump();
    expect(copied, ['+20 1289181425']);
    expect(button('Copied'), findsOneWidget);
    expect(tester.getSize(button('Copied')).width, idleWidth);
    await tester.pump(const Duration(seconds: 1));
    expect(button('Copied'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(button('Copy phone'), findsOneWidget);
    expect(button('Copied'), findsNothing);
  });

  testWidgets('email button exposes a descriptive link label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpSection(tester, SectionId.contact);
    expect(find.bySemanticsLabel('Email ${profile.email}'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('Copy email writes to the clipboard and confirms for 2s', (
    tester,
  ) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpSection(tester, SectionId.contact);

    expect(button('Copy email'), findsOneWidget);
    final idleWidth = tester.getSize(button('Copy email')).width;
    await tester.tap(button('Copy email'));
    await tester.pump();
    await tester.pump();

    expect(copied, [profile.email]);
    expect(button('Copied'), findsOneWidget);
    expect(button('Copy email'), findsNothing);
    // The label area is as wide as the longer label: no reflow.
    expect(tester.getSize(button('Copied')).width, idleWidth);

    await tester.pump(const Duration(seconds: 1));
    expect(button('Copied'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(button('Copy email'), findsOneWidget);
    expect(button('Copied'), findsNothing);
  });

  testWidgets('tapping again restarts the 2s confirmation', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpSection(tester, SectionId.contact);
    await tester.tap(button('Copy email'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.tap(button('Copied'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    expect(button('Copied'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
    expect(button('Copy email'), findsOneWidget);
  });

  testWidgets('the glow painter is an elliptical gradient at the top', (
    tester,
  ) async {
    final glow = ContactGlowPainter.glowFor(const Size(1000, 400));
    expect(glow.center, const Offset(500, 0));
    expect(glow.radii, const Offset(600, 360));
    expect(glow.stops, [0, 0.7]);
  });

  group('no overflow', () {
    for (final width in [360.0, 768.0, 1440.0]) {
      testWidgets('${width.toInt()}px', (tester) async {
        await pumpSection(tester, SectionId.contact, size: Size(width, 900));
        expect(inContact, findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('360px at 1.5x text', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpSection(tester, SectionId.contact, size: const Size(360, 900));
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('app builds', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    await settle(tester);
    expect(tester.takeException(), isNull);
  });
}
