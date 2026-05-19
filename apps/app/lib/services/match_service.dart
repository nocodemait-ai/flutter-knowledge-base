import 'package:flutter/foundation.dart';
import '../models/match.dart';

class MatchService extends ChangeNotifier {
  List<Match> _matches = [];

  MatchService() {
    _matches = List.generate(5, (index) => Match(
      id: 'm_$index',
      team1: ['Player A${index + 1}', 'Player B${index + 1}'],
      team2: ['Player C${index + 1}', 'Player D${index + 1}'],
      score: '0-0',
      winner: 'None',
    ));
  }

  List<Match> get matches => List.unmodifiable(_matches);

  void addMatch(Match m) {
    _matches.add(m);
    notifyListeners();
  }

  void updateScore(String id, String score) {
    final index = _matches.indexWhere((m) => m.id == id);
    if (index != -1) {
      _matches[index] = _matches[index].copyWith(score: score);
      notifyListeners();
    }
  }

  void markWinner(String id, String winner) {
    final index = _matches.indexWhere((m) => m.id == id);
    if (index != -1) {
      _matches[index] = _matches[index].copyWith(winner: winner);
      notifyListeners();
    }
  }
}