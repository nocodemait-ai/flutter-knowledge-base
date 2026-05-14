import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Note: This implementation assumes HabitService and TreeProvider are available in the provider scope
// as per standard Riverpod architecture.

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitServiceProvider);
    final treeProgress = ref.watch(treeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(treeProvider),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_nature, size: 80, color: Color(0xFF4A7C59)),
                      Text('Tree Level: ${treeProgress.level}', style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
              ),
            ),
            if (habits.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text('No habits today. Create one!')),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final habit = habits[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline, color: Color(0xFF4A7C59)),
                        title: Text(habit.name),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => ref.read(habitServiceProvider.notifier).toggle(habit.id),
                        ),
                      ),
                    );
                  },
                  childCount: habits.length,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A7C59),
        onPressed: () => context.push('/add-habit'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Mock Providers for the sake of completeness in the generated file
final habitServiceProvider = StateNotifierProvider<HabitService, List<Habit>>((ref) => HabitService());
final treeProvider = Provider((ref) => Tree(level: 1));

class Habit { final String id; final String name; Habit(this.id, this.name); }
class Tree { final int level; Tree({required this.level}); }
class HabitService extends StateNotifier<List<Habit>> {
  HabitService() : super([Habit('1', 'Water Plant'), Habit('2', 'Meditate')]);
  void toggle(String id) {}
}