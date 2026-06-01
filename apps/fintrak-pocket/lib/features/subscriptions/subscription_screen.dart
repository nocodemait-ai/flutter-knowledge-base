import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/transaction_service.dart';
import '../../models/transaction.dart';
import '../../core/theme.dart';

const _subCategories = {'Streaming', 'Subscriptions'};

class _SubInfo {
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final Color color;
  const _SubInfo(this.name, this.category, this.price, this.icon, this.color);
}

// Preset icon+color options shown in the add dialog
const _presets = [
  (Icons.play_circle_fill, Color(0xFFE50914), 'Video'),
  (Icons.music_note,       Color(0xFF1DB954), 'Music'),
  (Icons.cloud,            Color(0xFF147EFB), 'Cloud'),
  (Icons.smart_display,   Color(0xFFFF0000), 'TV'),
  (Icons.games,            Color(0xFF7B1FA2), 'Gaming'),
  (Icons.newspaper,        Color(0xFF0277BD), 'News'),
  (Icons.fitness_center,   Color(0xFFE65100), 'Fitness'),
  (Icons.shopping_bag,     Color(0xFF2E7D32), 'Shopping'),
];

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // Mutable list — starts with well-known defaults
  final List<_SubInfo> _subs = [
    const _SubInfo('Netflix',         'Streaming',     15.99, Icons.play_circle_fill, Color(0xFFE50914)),
    const _SubInfo('Spotify',         'Streaming',      9.99, Icons.music_note,        Color(0xFF1DB954)),
    const _SubInfo('iCloud',          'Subscriptions',  2.99, Icons.cloud,             Color(0xFF147EFB)),
    const _SubInfo('YouTube Premium', 'Streaming',     13.99, Icons.smart_display,    Color(0xFFFF0000)),
  ];

  double get _monthlyTotal => _subs.fold(0.0, (s, sub) => s + sub.price);

  void _removeSub(int index) {
    setState(() => _subs.removeAt(index));
  }

  void _showAddDialog() {
    final nameCtrl  = TextEditingController();
    final priceCtrl = TextEditingController();
    String category = 'Streaming';
    int presetIndex = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Subscription', style: TextStyle(fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Service name',
                    hintText: 'e.g. Disney+',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monthly price (\$)',
                    hintText: 'e.g. 9.99',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Streaming',     child: Text('Streaming')),
                    DropdownMenuItem(value: 'Subscriptions', child: Text('Subscriptions')),
                  ],
                  onChanged: (v) => setDialogState(() => category = v!),
                ),
                const SizedBox(height: 16),
                const Text('Icon', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_presets.length, (i) {
                    final (icon, color, _) = _presets[i];
                    final selected = i == presetIndex;
                    return GestureDetector(
                      onTap: () => setDialogState(() => presetIndex = i),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: selected
                            ? color
                            : color.withValues(alpha: 0.15),
                        child: Icon(icon,
                            color: selected ? Colors.white : color, size: 20),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              onPressed: () {
                final name  = nameCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text.trim());
                if (name.isEmpty || price == null || price <= 0) return;

                final (icon, color, _) = _presets[presetIndex];
                setState(() {
                  _subs.add(_SubInfo(name, category, price, icon, color));
                });

                // Also log as a transaction so budgets screen reflects it
                context.read<TransactionService>().addTransaction(Transaction(
                  id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
                  amount: price,
                  category: category,
                  date: DateTime.now(),
                ));

                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txns    = context.watch<TransactionService>().transactions;
    final subTxns = txns
        .where((t) => _subCategories.contains(t.category) &&
                      !t.id.startsWith('sub_'))
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Subscriptions', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SubSummaryCard(monthlyTotal: _monthlyTotal),
          const SizedBox(height: 20),
          Text('Active Subscriptions',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Swipe left to remove',
              style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 10),
          ..._subs.asMap().entries.map((e) => _SwipeToDelete(
                key: ValueKey('${e.value.name}_${e.key}'),
                onDelete: () => _removeSub(e.key),
                child: _SubCard(sub: e.value),
              )),
          if (subTxns.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('From Transactions',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...subTxns.map((t) => _TxnSubTile(transaction: t)),
          ],
          const SizedBox(height: 80), // FAB clearance
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Subscription'),
      ),
    );
  }
}

// ── Swipe-to-delete wrapper ────────────────────────────────────────────────────

class _SwipeToDelete extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;
  const _SwipeToDelete({super.key, required this.child, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: child,
    );
  }
}

// ── Sub summary card ──────────────────────────────────────────────────────────

class _SubSummaryCard extends StatelessWidget {
  final double monthlyTotal;
  const _SubSummaryCard({required this.monthlyTotal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly Cost',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    '\$${monthlyTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${(monthlyTotal * 12).toStringAsFixed(2)} / year',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
              child: Icon(Icons.subscriptions, color: AppTheme.primary, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub card ──────────────────────────────────────────────────────────────────

class _SubCard extends StatelessWidget {
  final _SubInfo sub;
  const _SubCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: sub.color.withValues(alpha: 0.12),
          child: Icon(sub.icon, color: sub.color, size: 22),
        ),
        title: Text(sub.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(sub.category,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${sub.price.toStringAsFixed(2)}',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const Text('/ mo', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ── Transaction-sourced tile ──────────────────────────────────────────────────

class _TxnSubTile extends StatelessWidget {
  final Transaction transaction;
  const _TxnSubTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey.shade50,
          child: const Icon(Icons.receipt, color: Colors.blueGrey, size: 18),
        ),
        title: Text(transaction.category,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          '-\$${transaction.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Color(0xFFB00020),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
