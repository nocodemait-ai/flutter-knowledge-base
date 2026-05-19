import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MatchData {
  final String id;
  final String teamA;
  final String teamB;
  int scoreA;
  int scoreB;
  bool winnerA;

  MatchData(this.id, this.teamA, this.teamB, {this.scoreA = 0, this.scoreB = 0, this.winnerA = false});
}

final matchProvider = StateProvider<List<MatchData>>((ref) => [
  MatchData('1', 'Team Alpha', 'Team Beta'),
  MatchData('2', 'Team Gamma', 'Team Delta'),
  MatchData('3', 'Team Epsilon', 'Team Zeta'),
  MatchData('4', 'Team Eta', 'Team Theta'),
  MatchData('5', 'Team Iota', 'Team Kappa'),
  MatchData('6', 'Team Lambda', 'Team Mu'),
  MatchData('7', 'Team Nu', 'Team Xi'),
  MatchData('8', 'Team Omicron', 'Team Pi'),
]);

class MatchmakingScreen extends ConsumerWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(matchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Matchmaking')),
      body: matches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_esports, size: 64, color: Colors.grey),
                  const Text('No active matches'),
                  ElevatedButton(onPressed: () => context.go('/'), child: const Text('Back Home'))
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final match = matches[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(child: Text(match.teamA, style: theme.textTheme.titleMedium)),
                          const Text('vs'),
                          Expanded(child: Text(match.teamB, textAlign: TextAlign.right, style: theme.textTheme.titleMedium)),
                        ]),
                        const SizedBox(height: 16),
                        Row(children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(labelText: 'Score A', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              onChanged: (val) => match.scoreA = int.tryParse(val) ?? 0,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(labelText: 'Score B', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              onChanged: (val) => match.scoreB = int.tryParse(val) ?? 0,
                            ),
                          ),
                        ]),
                        CheckboxListTile(
                          title: const Text('Mark Team A as Winner'),
                          value: match.winnerA,
                          onChanged: (val) {
                            match.winnerA = val ?? false;
                            ref.read(matchProvider.notifier).state = [...matches];
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          onPressed: () {
            // Logic to persist and navigate
            context.go('/');
          },
          child: const Text('Finish Tournament'),
        ),
      ),
    );
  }
}