import 'package:flutter_riverpod/flutter_riverpod.dart';

class Match {
  final String id;
  final int playerA;
  final int playerB;
  final bool isRotation;

  Match({
    required this.id,
    required this.playerA,
    required this.playerB,
    required this.isRotation,
  });
}

class TournamentNotifier extends StateNotifier<List<Match>> {
  TournamentNotifier() : super([]);

  void generateMatches(int count, bool isRotation) {
    final List<Match> newMatches = [];
    
    // Simple Round Robin generator for demonstration
    for (int i = 0; i < count; i++) {
      for (int j = i + 1; j < count; j++) {
        newMatches.add(Match(
          id: 'm_${i}_$j',
          playerA: i + 1,
          playerB: j + 1,
          isRotation: isRotation,
        ));
      }
    }
    
    state = newMatches;
  }

  void finishTournament() {
    state = [];
  }
}

final tournamentProvider = StateNotifierProvider<TournamentNotifier, List<Match>>((ref) {
  return TournamentNotifier();
});