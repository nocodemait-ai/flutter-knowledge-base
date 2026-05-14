import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/app_shell.dart';
import '../features/home/screen.dart';
import '../features/stats/screen.dart';
import '../features/manage/screen.dart';
import '../features/garden/screen.dart';
import '../features/add_edit/screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/', builder: (c, s) => const HomeScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/stats', builder: (c, s) => const StatsScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/habits', builder: (c, s) => const HabitManageScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/garden', builder: (c, s) => const GardenScreen())]),
      ],
    ),
    GoRoute(path: '/add-habit', builder: (c, s) => const AddEditHabitScreen()),
  ],
);