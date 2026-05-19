import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Reward {
  final String id;
  final String title;
  final int score;
  Reward(this.id, this.title, this.score);
}

final userProgressProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return {'current': 6, 'goal': 10, 'badge': 'Coffee Enthusiast'};
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('Dashboard'), backgroundColor: colorScheme.surface),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(userProgressProvider.future),
        child: progressAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            Text('Failed to load'),
            TextButton(onPressed: () => ref.invalidate(userProgressProvider), child: const Text('Retry'))
          ])),
          data: (data) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(children: [
                    LinearProgressIndicator(value: data['current'] / data['goal'], backgroundColor: Colors.grey[200]),
                    const SizedBox(height: 16),
                    Text('${data['current']} of ${data['goal']} for next reward', style: Theme.of(context).textTheme.titleMedium),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const Icon(Icons.badge, size: 40),
                  title: Text(data['badge']),
                  subtitle: const Text('Score: 150 points'),
                  onTap: () => _showRewardDetailSheet(context),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQrScanner(context),
        label: const Text('Scan QR'),
        icon: const Icon(Icons.qr_code_scanner),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  void _showQrScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: 500,
        child: MobileScanner(
          onDetect: (capture) => Navigator.pop(ctx),
        ),
      ),
    );
  }

  void _showRewardDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.coffee, size: 64, color: Colors.brown),
            const SizedBox(height: 16),
            Text('Reward Details', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('You have earned a free coffee! Enjoy your reward.'),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))
          ],
        ),
      ),
    );
  }
}