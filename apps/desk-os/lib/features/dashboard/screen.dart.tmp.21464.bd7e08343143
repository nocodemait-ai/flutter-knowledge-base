import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(colorScheme),
            const SizedBox(height: 16),
            Expanded(
              child: _buildGrid(colorScheme),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildControlBar(colorScheme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSummaryRow(ColorScheme colors) {
    return Row(
      children: List.generate(3, (index) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [Icon(Icons.thermostat, color: colors.primary), Text('22°C', style: TextStyle(color: colors.onSurface))]),
        ),
      )),
    );
  }

  Widget _buildGrid(ColorScheme colors) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 9,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () => _showDetailModal(ctx),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(child: Icon(Icons.speed, color: colors.primary, size: 40)),
              Positioned(
                right: 8, 
                top: 8, 
                child: IconButton(
                  icon: Icon(Icons.power_settings_new, color: colors.error),
                  onPressed: () => debugPrint('MQTT Toggle'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb, color: colors.primary),
          const SizedBox(width: 16),
          Text('Quick Scenes', style: TextStyle(color: colors.onSecondary)),
        ],
      ),
    );
  }

  void _showDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        color: Theme.of(ctx).colorScheme.surface,
        child: const Center(child: Text('Widget Details Modal', style: TextStyle(color: Colors.white))),
      ),
    );
  }
}