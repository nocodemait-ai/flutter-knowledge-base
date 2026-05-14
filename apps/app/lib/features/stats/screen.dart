import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import '../../providers/habit_provider.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  bool _showThirtyDays = true;

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text('Statistics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreakCard(context),
            const SizedBox(height: 24),
            const Text('Calendar Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 30)),
              lastDay: DateTime.now(),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              headerStyle: const HeaderStyle(formatButtonVisible: false),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Completion Trends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ToggleButtons(
                  isSelected: [_showThirtyDays, !_showThirtyDays],
                  onPressed: (idx) => setState(() => _showThirtyDays = idx == 0),
                  children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('30d')), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('7d'))],
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: LineChart(_buildChartData())),
            const SizedBox(height: 24),
            const Text('Habit Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...habits.map((habit) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(habit.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/habit-detail/${habit.id}'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primary,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, size: 48, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Best Streak', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8))),
            Text('12 Days', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary)),
          ]),
        ],
      ),
    ),
  );

  LineChartData _buildChartData() => LineChartData(
    gridData: const FlGridData(show: false),
    titlesData: const FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    lineBarsData: [LineChartBarData(spots: const [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2), FlSpot(3, 5)], isCurved: true, color: Colors.green)],
  );
}