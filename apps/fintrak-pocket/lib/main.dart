import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/transaction_service.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionService()),
      ],
      child: const FinanceApp(),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Finance Tracker',
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}
