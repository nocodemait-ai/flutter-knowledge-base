import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitService extends ChangeNotifier {
  final List<Habit> _items = [
    Habit(id: 'h_1', name: 'Morning Yoga', type: 'boolean', goal: 1),
    Habit(id: 'h_2', name: 'Drink Water', type: 'counter', goal: 8),
    Habit(id: 'h_3', name: 'Deep Work', type: 'timer', goal: 60),
    Habit(id: 'h_4', name: 'Reading', type: 'timer', goal: 30),
    Habit(id: 'h_5', name: 'Meditation', type: 'boolean', goal: 1),
  ];

  List<Habit> get habits => List.unmodifiable(_items);

  void addHabit(Habit h) {
    _items.add(h);
    notifyListeners();
  }

  void removeHabit(String id) {
    _items.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void updateHabit(Habit h) {
    final index = _items.indexWhere((element) => element.id == h.id);
    if (index != -1) {
      _items[index] = h;
      notifyListeners();
    }
  }
}