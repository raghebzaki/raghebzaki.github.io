import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/responsive_context.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../shared/widgets/gradient_text.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../shell/section_id.dart';

class EcosystemSection extends StatelessWidget {
  const EcosystemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ecosystem = context.read<PortfolioRepository>().ecosystem;
    return SectionContainer(
      top: AppLayout.defaultTop,
      child: SectionHeader(
        section: SectionId.ecosystem,
        title: HighlightedTitle(
          lead: 'One engineering system, ',
          highlight: '${ecosystem.totalLabel} apps',
          trail: '.',
          style: context.typography.ecosystemTitle,
        ),
      ),
    );
  }
}
