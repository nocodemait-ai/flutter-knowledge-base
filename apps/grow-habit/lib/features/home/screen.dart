import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Set<String> _completedIds = {};

  static const _primary = Color(0xFF4A7C59);
  static const _secondary = Color(0xFF8FBC8F);
  static const _bg = Color(0xFFF5F0E8);
  static const _textDark = Color(0xFF2D3B2D);
  static const _textMuted = Color(0xFF6B7B6B);

  // Tree stage based on completion %
  String _treeEmoji(double pct) {
    if (pct == 0) return 'seed';
    if (pct < 0.3) return 'sprout';
    if (pct < 0.6) return 'sapling';
    if (pct < 0.9) return 'tree';
    return 'blooming';
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider).habits;
    final total = habits.length;
    final done = _completedIds.length;
    final pct = total > 0 ? done / total : 0.0;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // ── Tree / progress header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 28),
              child: Column(
                children: [
                  // Greeting
                  Text(
                    _greeting(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: _textMuted),
                  ),
                  const SizedBox(height: 20),
                  // Tree circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha:0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: _secondary.withValues(alpha:0.4), width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          pct >= 1.0 ? Icons.park : pct >= 0.5 ? Icons.nature : Icons.eco,
                          size: 52,
                          color: _primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _treeEmoji(pct),
                          style: const TextStyle(fontSize: 11, color: _textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$done of $total habits done',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 10,
                      backgroundColor: _secondary.withValues(alpha:0.2),
                      valueColor: const AlwaysStoppedAnimation(_primary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Section header ──────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Today's Habits",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ),
          ),

          // ── Habit list ──────────────────────────────────────────────────────
          if (habits.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.spa_outlined, size: 64, color: _secondary),
                    SizedBox(height: 12),
                    Text('No habits yet.\nTap + to plant your first seed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _textMuted)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final habit = habits[index];
                    final isDone = _completedIds.contains(habit.id);
                    return _HabitCard(
                      habit: habit,
                      isDone: isDone,
                      onToggle: () => setState(() {
                        if (isDone) {
                          _completedIds.remove(habit.id);
                        } else {
                          _completedIds.add(habit.id);
                        }
                      }),
                    );
                  },
                  childCount: habits.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primary,
        onPressed: () => context.push('/add-habit'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isDone;
  final VoidCallback onToggle;

  static const _primary = Color(0xFF4A7C59);
  static const _secondary = Color(0xFF8FBC8F);
  static const _textDark = Color(0xFF2D3B2D);
  static const _textMuted = Color(0xFF6B7B6B);

  const _HabitCard({required this.habit, required this.isDone, required this.onToggle});

  IconData get _typeIcon {
    switch (habit.type) {
      case 'counter': return Icons.add_circle_outline;
      case 'timer': return Icons.timer_outlined;
      default: return Icons.check_circle_outline;
    }
  }

  String get _goalLabel {
    switch (habit.type) {
      case 'timer': return '${habit.goal} min';
      case 'counter': return '${habit.goal}×';
      default: return 'Daily';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDone ? _primary.withValues(alpha:0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? _primary : const Color(0xFFE8E4DC),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Type icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (isDone ? _primary : _secondary).withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _typeIcon,
                  color: isDone ? _primary : _secondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Name + goal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: _textDark,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        decorationColor: _primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(_goalLabel, style: const TextStyle(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
              // Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone ? _primary : Colors.transparent,
                  border: Border.all(color: _primary, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
