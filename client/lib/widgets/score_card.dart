import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme_config.dart';
import '../services/score_service.dart';

class ScoreCard extends StatelessWidget {
  final int score;
  final int surveys;

  const ScoreCard({
    super.key,
    required this.score,
    required this.surveys,
  });

  @override
  Widget build(BuildContext context) {
    final grade = ScoreService.gradeForScore(score);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [WBISTheme.primaryGreen, Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: WBISTheme.primaryGreen.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Green Score',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$score pts',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$grade · $surveys surveys',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
