import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screen.dart';
import '../features/dashboard/screen.dart';
import '../shared/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(shell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/menu',
            builder: (context, state) => Scaffold(
              body: Center(child: Text('Menu Screen', style: Theme.of(context).textTheme.headlineMedium)),
            ),
          ),
        ]),
      ],
    ),
  ],
);