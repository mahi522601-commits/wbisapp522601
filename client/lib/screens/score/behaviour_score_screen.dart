import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../models/behaviour_score_model.dart';
import '../../models/survey_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/score_service.dart';
import '../../widgets/behaviour_chart.dart';
import '../../widgets/score_card.dart';
import 'leaderboard_screen.dart';

class BehaviourScoreScreen extends StatelessWidget {
  const BehaviourScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<WBISAuthProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Behaviour Score'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            ),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Sign in to view your score.'))
          : StreamBuilder<BehaviourScoreModel?>(
              stream: FirestoreService.getUserScore(user.uid),
              builder: (context, scoreSnap) {
                if (scoreSnap.hasError) return Center(child: Text('Error: ${scoreSnap.error}', style: const TextStyle(color: Colors.red)));
                final score = scoreSnap.data;
                return StreamBuilder<List<SurveyModel>>(
                  stream: FirestoreService.getUserSurveys(user.uid),
                  builder: (context, surveySnap) {
                    final surveys = surveySnap.data ?? [];
                    final running = <int>[];
                    var total = 0;
                    for (final survey in surveys.reversed) {
                      total += survey.behaviourScore;
                      running.add(total);
                    }
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        ScoreCard(
                          score: score?.totalScore ?? 0,
                          surveys: score?.surveyCount ?? surveys.length,
                        ),
                        const SizedBox(height: 18),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Score Trend',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BehaviourChart(points: running),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        LinearProgressIndicator(
                          value: ScoreService.progressToNextGrade(
                            score?.totalScore ?? 0,
                          ),
                          color: WBISTheme.primaryGreen,
                          backgroundColor: WBISTheme.lightGreen,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Grade: ${ScoreService.gradeForScore(score?.totalScore ?? 0)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
