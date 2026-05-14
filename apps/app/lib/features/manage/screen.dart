import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';

class HabitManageScreen extends ConsumerWidget {
  const HabitManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final habitNotifier = ref.read(habitProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Habits'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, size: 64, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 16),
                  Text('No habits yet. Start by adding one!', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            )
          : ReorderableListView.builder(
              itemCount: habits.length,
              onReorder: (oldIndex, newIndex) => habitNotifier.reorder(oldIndex, newIndex),
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Dismissible(
                  key: ValueKey(habit.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => habitNotifier.remove(habit.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.drag_handle),
                      title: Text(habit.name),
                      subtitle: Text('Type: ${habit.type} | Goal: ${habit.goal}'),
                      onTap: () => context.push('/habit-detail/${habit.id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.push('/add-habit?id=${habit.id}'),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-habit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}