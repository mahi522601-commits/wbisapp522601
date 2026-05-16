import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel {
  final String id;
  final String userId;
  final String name;
  final String wardAssigned;
  final int routeCompleted;
  final int missedHouseholds;
  final double reportingAccuracy;
  final DateTime lastActive;

  const WorkerModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.wardAssigned,
    required this.routeCompleted,
    required this.missedHouseholds,
    required this.reportingAccuracy,
    required this.lastActive,
  });

  factory WorkerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return WorkerModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      wardAssigned: data['wardAssigned'] ?? '',
      routeCompleted: data['routeCompleted'] ?? 0,
      missedHouseholds: data['missedHouseholds'] ?? 0,
      reportingAccuracy: (data['reportingAccuracy'] ?? 0).toDouble(),
      lastActive: _timestampToDate(data['lastActive']),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'name': name,
        'wardAssigned': wardAssigned,
        'routeCompleted': routeCompleted,
        'missedHouseholds': missedHouseholds,
        'reportingAccuracy': reportingAccuracy,
        'lastActive': Timestamp.fromDate(lastActive),
      };
}

DateTime _timestampToDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
