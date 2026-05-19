import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const LinearProgressIndicator(value: 0.6),
                    const SizedBox(height: 12),
                    Text('6 of 10 for next reward', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('Gold Member'),
                subtitle: const Text('1,250 points'),
                onTap: () => _showRewardDetail(context),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showScanner(context),
        label: const Text('Scan QR'),
        icon: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  void _showScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: 500,
        child: MobileScanner(
          onDetect: (capture) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showRewardDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            Text('Reward Details', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text('You are only 4 coffees away from a free pastry!'),
          ],
        ),
      ),
    );
  }
}