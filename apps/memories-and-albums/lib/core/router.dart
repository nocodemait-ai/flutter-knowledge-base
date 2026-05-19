import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/memories/memory_detail_screen.dart';
import '../features/memories/create_memory_screen.dart';
import '../features/albums/album_list_screen.dart';
import '../features/albums/album_detail_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/memories/edit_memory_screen.dart';
import '../shared/widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'memory/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => MemoryDetailScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'create-memory',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const CreateMemoryScreen(),
                ),
                GoRoute(
                  path: 'edit-memory/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => EditMemoryScreen(
                    id: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/albums',
              builder: (context, state) => const AlbumListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => AlbumDetailScreen(id: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
