import '../models/survey_model.dart';

class ScoreService {
  static int scoreForStatus(WasteStatus status) => status.scoreImpact;

  static String gradeForScore(int score) {
    if (score >= 200) return 'Champion';
    if (score >= 100) return 'Leader';
    if (score >= 50) return 'Improver';
    if (score >= 0) return 'Starter';
    return 'Needs Attention';
  }

  static double progressToNextGrade(int score) {
    if (score < 0) return 0;
    if (score < 50) return score / 50;
    if (score < 100) return (score - 50) / 50;
    if (score < 200) return (score - 100) / 100;
    return 1;
  }
}
