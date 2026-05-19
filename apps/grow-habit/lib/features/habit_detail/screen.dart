import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/habit_provider.dart';

class HabitDetailScreen extends ConsumerWidget {
  final String id;
  const HabitDetailScreen({super.key, required this.id});

  static const _primary = Color(0xFF4A7C59);
  static const _secondary = Color(0xFF8FBC8F);
  static const _bg = Color(0xFFF5F0E8);
  static const _textDark = Color(0xFF2D3B2D);
  static const _textMuted = Color(0xFF6B7B6B);

  // Mock data – replace with real HabitLog when persistence is wired up
  static const _weekData = [0.6, 1.0, 0.8, 1.0, 0.4, 1.0, 1.0];
  static const _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _currentStreak = 5;
  static const _bestStreak = 12;
  static const _completionRate = 78;
  static const _completedDays = {1, 2, 3, 5, 6, 8, 9, 10, 12, 13, 14};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider).habits;
    final idx = habits.indexWhere((h) => h.id == id);

    if (idx == -1) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text('Habit not found', style: TextStyle(color: _textMuted)),
        ),
      );
    }

    final habit = habits[idx];

    IconData typeIcon;
    String typeLabel;
    String goalLabel;
    switch (habit.type) {
      case 'counter':
        typeIcon = Icons.add_circle_outline;
        typeLabel = 'Counter';
        goalLabel = '${habit.goal}× per day';
        break;
      case 'timer':
        typeIcon = Icons.timer_outlined;
        typeLabel = 'Timer';
        goalLabel = '${habit.goal} min per day';
        break;
      default:
        typeIcon = Icons.check_circle_outline;
        typeLabel = 'Yes / No';
        goalLabel = 'Complete once daily';
    }

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient header ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primary, _secondary],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha:0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(typeIcon, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(typeLabel, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        habit.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(goalLabel, style: TextStyle(color: Colors.white.withValues(alpha:0.8), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats row ────────────────────────────────────────────────
                Row(children: [
                  _StatChip(label: 'Current\nStreak', value: '$_currentStreak days', icon: Icons.local_fire_department, color: Colors.deepOrange),
                  const SizedBox(width: 10),
                  _StatChip(label: 'Best\nStreak', value: '$_bestStreak days', icon: Icons.emoji_events, color: Colors.amber.shade700),
                  const SizedBox(width: 10),
                  _StatChip(label: 'Completion', value: '$_completionRate%', icon: Icons.pie_chart_outline, color: _primary),
                ]),
                const SizedBox(height: 28),

                // ── 7-day bar chart ──────────────────────────────────────────
                _SectionHeader('Last 7 Days'),
                const SizedBox(height: 14),
                Container(
                  height: 160,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                  decoration: _cardDecor(),
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) => Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _weekDays[v.toInt() % 7],
                                style: const TextStyle(fontSize: 11, color: _textMuted),
                              ),
                            ),
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: List.generate(7, (i) => BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: _weekData[i],
                            width: 28,
                            color: _weekData[i] == 1.0 ? _primary : _primary.withValues(alpha:0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Monthly calendar heatmap ──────────────────────────────────
                _SectionHeader('This Month'),
                const SizedBox(height: 14),
                _MiniCalendar(),
                const SizedBox(height: 28),

                // ── Motivational card ─────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primary.withValues(alpha:0.08), _secondary.withValues(alpha:0.08)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _primary.withValues(alpha:0.2)),
                  ),
                  child: Column(children: [
                    const Icon(Icons.forest, color: _primary, size: 36),
                    const SizedBox(height: 10),
                    Text(
                      'You\'re on a $_currentStreak-day streak!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_bestStreak - _currentStreak} more days to beat your best streak.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: _textMuted),
                    ),
                  ]),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecor() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 2))],
  );
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF2D3B2D)),
  );
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 8)],
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3B2D))),
        const SizedBox(height: 2),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7B6B))),
      ]),
    ),
  );
}

class _MiniCalendar extends StatelessWidget {
  static const _primary = Color(0xFF4A7C59);
  static const _completed = HabitDetailScreen._completedDays;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 8)],
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(daysInMonth, (i) {
          final day = i + 1;
          final isFuture = day > now.day;
          final isDone = _completed.contains(day);
          final isToday = day == now.day;

          return Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isFuture
                  ? Colors.transparent
                  : isDone
                      ? _primary
                      : _primary.withValues(alpha:0.08),
              borderRadius: BorderRadius.circular(8),
              border: isToday ? Border.all(color: _primary, width: 2) : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isFuture
                      ? const Color(0xFFD0CCC4)
                      : isDone
                          ? Colors.white
                          : const Color(0xFF6B7B6B),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
