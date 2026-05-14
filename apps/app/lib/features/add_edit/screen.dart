import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';
import 'package:uuid/uuid.dart';

class AddEditHabitScreen extends ConsumerStatefulWidget {
  const AddEditHabitScreen({super.key});

  @override
  ConsumerState<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends ConsumerState<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'boolean';
  int _goal = 1;
  int _selectedColorIndex = 0;

  final List<Color> _colors = [Colors.green, Colors.blue, Colors.red, Colors.orange, Colors.purple];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Habit Name', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Habit Type'),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'boolean', label: Text('Yes/No')),
                ButtonSegment(value: 'counter', label: Text('Counter')),
                ButtonSegment(value: 'timer', label: Text('Timer')),
              ],
              selected: {_selectedType},
              onSelectionChanged: (s) => setState(() => _selectedType = s.first),
            ),
            const SizedBox(height: 16),
            if (_selectedType != 'boolean')
              TextFormField(
                decoration: const InputDecoration(labelText: 'Goal Target', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (v) => _goal = int.tryParse(v) ?? 1,
              ),
            const SizedBox(height: 16),
            const Text('Pick a Color'),
            Wrap(
              spacing: 8,
              children: List.generate(_colors.length, (i) => GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = i),
                child: CircleAvatar(backgroundColor: _colors[i], child: _selectedColorIndex == i ? const Icon(Icons.check, color: Colors.white) : null),
              )),
            ),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancel'))),
              const SizedBox(width: 16),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final habit = Habit(
                      id: const Uuid().v4(),
                      name: _nameController.text,
                      type: _selectedType,
                      goal: _goal,
                    );
                    ref.read(habitServiceProvider.notifier).add(habit);
                    context.pop();
                  }
                },
                child: const Text('Save'),
              )),
            ]),
          ],
        ),
      ),
    );
  }
}