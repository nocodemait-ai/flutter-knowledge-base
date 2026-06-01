import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/transaction_service.dart';
import '../../core/theme.dart';

// Monthly budget limits per category
const _budgetLimits = {
  'Groceries': 150.0,
  'Rent': 1200.0,
  'Fuel': 120.0,
  'Insurance': 350.0,
  'Coffee': 40.0,
  'Utilities': 100.0,
  'Streaming': 30.0,
  'Subscriptions': 30.0,
  'Shopping': 150.0,
  'Transport': 60.0,
};

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txns = context.watch<TransactionService>().transactions;

    // Sum spent per category
    final spent = <String, double>{};
    for (final t in txns) {
      spent[t.category] = (spent[t.category] ?? 0) + t.amount;
    }

    final totalBudget = _budgetLimits.values.fold(0.0, (s, v) => s + v);
    final totalSpent = spent.values.fold(0.0, (s, v) => s + v);
    final remaining = totalBudget - totalSpent;

    final categories = _budgetLimits.keys.toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Budgets', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OverviewCard(
            totalBudget: totalBudget,
            totalSpent: totalSpent,
            remaining: remaining,
          ),
          const SizedBox(height: 20),
          Text('Category Breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...categories.map((cat) {
            final limit = _budgetLimits[cat]!;
            final used = spent[cat] ?? 0.0;
            return _BudgetCategoryCard(
              category: cat,
              spent: used,
              limit: limit,
            );
          }),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remaining;
  const _OverviewCard(
      {required this.totalBudget, required this.totalSpent, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final progress = (totalSpent / totalBudget).clamp(0.0, 1.0);
    final isOver = totalSpent > totalBudget;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Monthly Budget',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('\$${totalBudget.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppTheme.primary,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                    isOver ? AppTheme.error : AppTheme.primary),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MiniStat(
                    label: 'Spent',
                    value: '\$${totalSpent.toStringAsFixed(2)}',
                    color: AppTheme.error),
                _MiniStat(
                    label: 'Remaining',
                    value: '\$${remaining.toStringAsFixed(2)}',
                    color: isOver ? AppTheme.error : AppTheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        ],
      );
}

class _BudgetCategoryCard extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;
  const _BudgetCategoryCard(
      {required this.category, required this.spent, required this.limit});

  @override
  Widget build(BuildContext context) {
    final progress = (spent / limit).clamp(0.0, 1.0);
    final isOver = spent > limit;
    final barColor = isOver
        ? AppTheme.error
        : progress > 0.8
            ? Colors.orange
            : AppTheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '\$${spent.toStringAsFixed(2)} / \$${limit.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isOver ? AppTheme.error : Colors.grey.shade600,
                    fontWeight: isOver ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(barColor),
              ),
            ),
            if (isOver)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 14, color: AppTheme.error),
                    const SizedBox(width: 4),
                    Text(
                      'Over by \$${(spent - limit).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 11, color: AppTheme.error),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
