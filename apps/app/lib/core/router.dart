import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/setup/screen.dart';
import '../features/matchmaking/screen.dart';
import '../shared/widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/setup',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(path: '/setup', builder: (context, state) => const SetupScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/matchmaking', builder: (context, state) => const MatchmakingScreen()),
          ],
        ),
      ],
    ),
  ],
);