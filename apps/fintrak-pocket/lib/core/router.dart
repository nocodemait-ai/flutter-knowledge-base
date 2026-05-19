import 'package:go_router/go_router.dart';
import '../shared/widgets/app_shell.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/budgets/budget_screen.dart';
import '../features/investments/investment_screen.dart';
import '../features/subscriptions/subscription_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (c, s) => const DashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/budgets', builder: (c, s) => const BudgetScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/investments', builder: (c, s) => const InvestmentScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/subscriptions', builder: (c, s) => const SubscriptionScreen()),
        ]),
      ],
    ),
  ],
);
