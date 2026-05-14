import 'package:isar/isar.dart';
part 'habit.g.dart';

@collection
class Habit {
  Id isarId = Isar.autoIncrement;
  @Index(unique: true)
  final String id;
  final String name;
  final String type; // 'boolean', 'counter', 'timer'
  final int goal;

  Habit({
    required this.id,
    required this.name,
    required this.type,
    required this.goal,
  });

  Habit copyWith({String? name, String? type, int? goal}) => Habit(
        id: this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        goal: goal ?? this.goal,
      );

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        goal: json['goal'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'goal': goal,
      };
}