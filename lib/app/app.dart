import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../data/static_portfolio_repository.dart';
import '../domain/repositories/portfolio_repository.dart';
import 'foundation_preview.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PortfolioRepository>(
      create: (_) => const StaticPortfolioRepository(),
      child: MaterialApp(
        title: 'Ragheb Zaki — Senior Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const FoundationPreview(),
      ),
    );
  }
}
