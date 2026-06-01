import 'package:flutter/material.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Your Garden'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatsRow(colorScheme),
                  const SizedBox(height: 24),
                  _buildForestAnimation(colorScheme),
                  const SizedBox(height: 24),
                  _buildDailyMotivation(colorScheme),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Milestones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildMilestoneItem(context, index, colorScheme),
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem(colors, 'Days', '12'),
        _statItem(colors, 'Habits', '5'),
        _statItem(colors, 'Streak', '8'),
      ],
    );
  }

  Widget _statItem(ColorScheme colors, String label, String value) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.primary)),
      Text(label, style: TextStyle(color: colors.onSurface.withValues(alpha: 0.7))),
    ],
  );

  Widget _buildForestAnimation(ColorScheme colors) => AnimatedOpacity(
    opacity: 1.0,
    duration: const Duration(seconds: 1),
    child: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: Icon(Icons.park, size: 80, color: colors.primary)),
    ),
  );

  Widget _buildDailyMotivation(ColorScheme colors) => Card(
    elevation: 2,
    color: colors.primary.withValues(alpha: 0.1),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '"Nature does not hurry, yet everything is accomplished."', 
        textAlign: TextAlign.center,
        style: TextStyle(fontStyle: FontStyle.italic, color: colors.primary),
      ),
    ),
  );

  Widget _buildMilestoneItem(BuildContext context, int index, ColorScheme colors) => ListTile(
    leading: CircleAvatar(backgroundColor: colors.secondary, child: const Icon(Icons.star)),
    title: Text('Milestone Achieved: ${index + 1}'),
    subtitle: const Text('Tap for details'),
    onTap: () => showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Milestone Details'),
        content: Text('Achieved on: ${DateTime.now().toString().split(' ')[0]}'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    ),
  );
}