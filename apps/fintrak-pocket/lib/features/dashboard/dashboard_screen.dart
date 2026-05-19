import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction.dart';
import '../../core/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txService = context.watch<TransactionService>();
    final txns = txService.transactions;
    final totalSpent = txns.fold(0.0, (s, t) => s + t.amount);
    final recent = txns.toList().reversed.take(5).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text(
                'FinTrak Pocket',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, const Color(0xFF1B5E20)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Total Spent (May)',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalSpent.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryRow(transactions: txns),
                  const SizedBox(height: 24),
                  Text('Recent Transactions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                  const SizedBox(height: 12),
                  ...recent.map((t) => _TxnTile(transaction: t)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showAddDialog(context, txService),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, TransactionService service) {
    final amountCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (\$)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text);
              if (amount != null && categoryCtrl.text.isNotEmpty) {
                service.addTransaction(Transaction(
                  id: 't_${DateTime.now().millisecondsSinceEpoch}',
                  amount: amount,
                  category: categoryCtrl.text,
                  date: DateTime.now(),
                ));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final List<Transaction> transactions;
  const _SummaryRow({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final cats = <String, double>{};
    for (final t in transactions) {
      cats[t.category] = (cats[t.category] ?? 0) + t.amount;
    }
    final topCat = cats.entries.reduce((a, b) => a.value > b.value ? a : b);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Transactions',
            value: '${transactions.length}',
            icon: Icons.receipt_long,
            color: const Color(0xFF1565C0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Top Category',
            value: topCat.key,
            icon: Icons.category,
            color: const Color(0xFF6A1B9A),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(value,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  final Transaction transaction;
  const _TxnTile({required this.transaction});

  static const _icons = {
    'Groceries': Icons.local_grocery_store,
    'Rent': Icons.home,
    'Streaming': Icons.play_circle,
    'Fuel': Icons.local_gas_station,
    'Insurance': Icons.shield,
    'Coffee': Icons.coffee,
    'Utilities': Icons.bolt,
    'Subscriptions': Icons.subscriptions,
    'Shopping': Icons.shopping_bag,
    'Transport': Icons.directions_bus,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[transaction.category] ?? Icons.attach_money;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(transaction.category,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          '-\$${transaction.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Color(0xFFB00020),
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
