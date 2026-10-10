import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../data/static_portfolio_repository.dart';
import '../domain/repositories/portfolio_repository.dart';
import '../features/shell/cubit/navigation_cubit.dart';
import 'router.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({this.initialLocation = '/', super.key});

  /// Initial route; only used by tests (the browser URL wins on the web).
  final String initialLocation;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final GoRouter _router = createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PortfolioRepository>(
      create: (_) => const StaticPortfolioRepository(),
      child: BlocProvider<NavigationCubit>(
        create: (_) => NavigationCubit(),
        child: MaterialApp.router(
          title: 'Ragheb Zaki — Senior Flutter Developer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          routerConfig: _router,
        ),
      ),
    );
  }
}
