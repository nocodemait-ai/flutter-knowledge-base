import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/app_shell.dart';
import '../features/dashboard/screen.dart';
import '../features/assistant/screen.dart';
import '../features/devices/screen.dart';
import '../features/automation/screen.dart';
import '../features/environment/screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/', builder: (context, state) => const DashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/assistant', builder: (context, state) => const AssistantScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/devices', builder: (context, state) => const DeviceManagementScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/automations', builder: (context, state) => const AutomationScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/environment', builder: (context, state) => const AmbientVisualizationScreen())]),
      ],
    ),
  ],
);