import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screen.dart';
import '../features/dashboard/screen.dart';
import '../shared/widgets/app_shell.dart';

// Placeholder dummy screen for the Menu route as per instructions
class MenuScreenPlaceholder extends StatelessWidget {
  const MenuScreenPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Menu Coming Soon')));
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(shell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/menu',
              builder: (context, state) => const MenuScreenPlaceholder(),
            ),
          ],
        ),
      ],
    ),
  ],
);