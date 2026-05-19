import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.shell.currentIndex,
        onDestinationSelected: widget.shell.goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}