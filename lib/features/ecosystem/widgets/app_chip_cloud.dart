import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/ecosystem.dart';
import '../cubit/ecosystem_filter_cubit.dart';
import '../ecosystem_logic.dart';
import 'app_chip.dart';

/// Every app name as a chip, in data order. Filtering only dims chips, so
/// the layout never reflows. A live region announces the visible count.
class AppChipCloud extends StatelessWidget {
  const AppChipCloud({required this.ecosystem, super.key});

  final Ecosystem ecosystem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EcosystemFilterCubit, EcosystemFilter>(
      builder: (context, filter) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              liveRegion: true,
              label: filterAnnouncement(filter, ecosystem),
              child: const SizedBox(height: 0),
            ),
            Semantics(
              container: true,
              child: Wrap(
                spacing: AppSpacing.s10,
                runSpacing: AppSpacing.s10,
                children: [
                  for (final family in ecosystem.families)
                    for (final app in family.apps)
                      AppChip(
                        key: ValueKey(app),
                        label: app,
                        family: family.id,
                        dimmed: chipDimmed(filter, family.id),
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
