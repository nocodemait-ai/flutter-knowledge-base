import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/habit_service.dart';

final habitProvider = ChangeNotifierProvider<HabitService>((ref) {
  return HabitService();
});