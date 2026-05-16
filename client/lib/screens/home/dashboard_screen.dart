import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../models/behaviour_score_model.dart';
import '../../models/survey_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/helpers.dart';
import '../../widgets/score_card.dart';
import '../../widgets/waste_status_chip.dart';
import '../profile/profile_screen.dart';
import '../score/leaderboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int> onOpenTab;

  const DashboardScreen({super.key, required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<WBISAuthProvider>();
    final user = auth.user;
    final displayName =
        auth.profile?.displayName ?? user?.displayName ?? 'Citizen';

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back',
                              style: TextStyle(
                                color: WBISTheme.textGray,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: WBISTheme.textDark,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                        icon: const Icon(Icons.person),
                      ),
                    ],
                  ).animate().fadeIn().slideY(begin: -0.2),
                  const SizedBox(height: 24),
                  StreamBuilder<BehaviourScoreModel?>(
                    stream: user == null
                        ? const Stream.empty()
                        : FirestoreService.getUserScore(user.uid),
                    builder: (context, snap) {
                      final score = snap.data?.totalScore ?? 0;
                      final surveys = snap.data?.surveyCount ?? 0;
                      return ScoreCard(score: score, surveys: surveys);
                    },
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WBISTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      _ActionCard(
                        icon: Icons.qr_code_scanner,
                        label: 'Scan QR',
                        color: WBISTheme.accentGreen,
                        onTap: () => onOpenTab(1),
                      ),
                      _ActionCard(
                        icon: Icons.photo_camera,
                        label: 'Upload Photo',
                        color: WBISTheme.warningYellow,
                        onTap: () => onOpenTab(2),
                      ),
                      _ActionCard(
                        icon: Icons.analytics_outlined,
                        label: 'Score',
                        color: WBISTheme.dangerRed,
                        onTap: () => onOpenTab(3),
                      ),
                      _ActionCard(
                        icon: Icons.leaderboard,
                        label: 'Leaderboard',
                        color: WBISTheme.primaryGreen,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LeaderboardScreen(),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 24),
                  const Text(
                    'Recent Surveys',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WBISTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          StreamBuilder<List<SurveyModel>>(
            stream: user == null
                ? const Stream.empty()
                : FirestoreService.getUserSurveys(user.uid),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              final surveys = snap.data!;
              if (surveys.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No surveys yet. Submit your first one.'),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _SurveyTile(survey: surveys[index]),
                  childCount: surveys.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurveyTile extends StatelessWidget {
  final SurveyModel survey;

  const _SurveyTile({required this.survey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _colorForStatus(survey.status.colorCode),
            child: const Icon(Icons.recycling, color: Colors.white, size: 20),
          ),
          title: Text(
            survey.wardName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(WBISHelpers.formatDate(survey.createdAt)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WasteStatusChip(status: survey.status),
              const SizedBox(height: 4),
              Text(
                '${survey.behaviourScore > 0 ? '+' : ''}${survey.behaviourScore} pts',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorForStatus(String code) {
    switch (code) {
      case 'GREEN':
        return Colors.green;
      case 'YELLOW':
        return Colors.amber;
      case 'RED':
        return Colors.red;
      case 'BLACK':
        return Colors.black54;
      default:
        return Colors.grey;
    }
  }
}
