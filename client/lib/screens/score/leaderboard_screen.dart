import 'package:flutter/material.dart';
import '../../models/behaviour_score_model.dart';
import '../../services/firestore_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: StreamBuilder<List<BehaviourScoreModel>>(
        stream: FirestoreService.getLeaderboard(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}', style: const TextStyle(color: Colors.red)));
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final scores = snap.data!;
          if (scores.isEmpty) {
            return const Center(child: Text('No scores yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: scores.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final score = scores[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(score.userId),
                  subtitle: Text('${score.surveyCount} surveys'),
                  trailing: Text(
                    '${score.totalScore} pts',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
