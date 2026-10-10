import 'package:flutter/widgets.dart';

import '../../../core/responsive/responsive_value.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/ecosystem.dart';
import '../../../shared/widgets/equal_height_row.dart';
import '../../../shared/widgets/store_link_button.dart';

/// Columns of the showcase grid.
int showcaseColumns(double width) => AutoFit.columns(
  width,
  minTile: AppLayout.showcaseMinTile,
  gap: AppLayout.showcaseGap,
  maxColumns: 3,
);

/// "Also shipped" block: title, subtitle and a grid of [ShowcaseAppTile]s.
class MoreApps extends StatelessWidget {
  const MoreApps({required this.showcase, super.key});

  final AppShowcase showcase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.s32),
        const SizedBox(
          height: 1,
          child: ColoredBox(color: AppColors.borderSubtle),
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(showcase.title, style: AppTextStyles.tileTitle),
        const SizedBox(height: AppSpacing.s4),
        Text(showcase.subtitle, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.s16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = showcaseColumns(constraints.maxWidth);
            final apps = showcase.apps;
            if (columns == 1) {
              return Column(
                spacing: AppLayout.showcaseGap,
                children: [
                  for (final app in apps)
                    SizedBox(
                      width: double.infinity,
                      child: ShowcaseAppTile(app: app),
                    ),
                ],
              );
            }
            return Column(
              spacing: AppLayout.showcaseGap,
              children: [
                for (var start = 0; start < apps.length; start += columns)
                  EqualHeightRow(
                    gap: AppLayout.showcaseGap,
                    children: [
                      for (var c = 0; c < columns; c++)
                        start + c < apps.length
                            ? ShowcaseAppTile(app: apps[start + c])
                            : const SizedBox.shrink(),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// One client app: name, native name and its store buttons (pinned bottom).
class ShowcaseAppTile extends StatelessWidget {
  const ShowcaseAppTile({required this.app, super.key});

  final ShowcaseApp app;

  @override
  Widget build(BuildContext context) {
    final nativeName = app.nativeName;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surfaceInset,
        borderRadius: AppRadii.appIconBorder,
        border: Border.fromBorderSide(BorderSide(color: AppColors.borderTag)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.name, style: AppTextStyles.showcaseName),
                if (nativeName != null)
                  Text(
                    nativeName,
                    style: AppTextStyles.caption,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.left,
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              child: Wrap(
                spacing: AppSpacing.s8,
                runSpacing: AppSpacing.s8,
                children: [
                  for (final link in app.links)
                    StoreLinkButton(ownerName: app.name, link: link),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
