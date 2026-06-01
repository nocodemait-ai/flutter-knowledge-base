import 'package:hive/hive.dart';

part 'match.g.dart';

@HiveType(typeId: 0)
class Match extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final List<String> team1;
  @HiveField(2) final List<String> team2;
  @HiveField(3) final String score;
  @HiveField(4) final String winner;

  Match({
    required this.id, 
    required this.team1, 
    required this.team2, 
    required this.score, 
    required this.winner
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    id: json['id'] as String,
    team1: List<String>.from(json['team1']),
    team2: List<String>.from(json['team2']),
    score: json['score'] as String,
    winner: json['winner'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'team1': team1,
    'team2': team2,
    'score': score,
    'winner': winner,
  };

  Match copyWith({String? score, String? winner}) => Match(
    id: id,
    team1: team1,
    team2: team2,
    score: score ?? this.score,
    winner: winner ?? this.winner,
  );
}