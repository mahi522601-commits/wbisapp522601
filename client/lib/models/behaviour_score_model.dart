import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviourScoreModel {
  final String userId;
  final int totalScore;
  final int surveyCount;
  final int ecoPoints;
  final DateTime lastUpdated;

  const BehaviourScoreModel({
    required this.userId,
    required this.totalScore,
    required this.surveyCount,
    required this.ecoPoints,
    required this.lastUpdated,
  });

  factory BehaviourScoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BehaviourScoreModel(
      userId: data['userId'] ?? doc.id,
      totalScore: data['totalScore'] ?? 0,
      surveyCount: data['surveyCount'] ?? 0,
      ecoPoints: data['ecoPoints'] ?? 0,
      lastUpdated: _timestampToDate(data['lastUpdated']),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'totalScore': totalScore,
        'surveyCount': surveyCount,
        'ecoPoints': ecoPoints,
        'lastUpdated': Timestamp.fromDate(lastUpdated),
      };
}

DateTime _timestampToDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
