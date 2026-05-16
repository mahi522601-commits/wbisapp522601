import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import '../models/behaviour_score_model.dart';
import '../models/survey_model.dart';
import '../models/user_model.dart';
import '../models/waste_report_model.dart';
import '../models/worker_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createUser(UserModel user) {
    return _db
        .collection(FirebaseCollections.users)
        .doc(user.uid)
        .set(user.toFirestore());
  }

  static Stream<UserModel?> getUser(String uid) {
    return _db.collection(FirebaseCollections.users).doc(uid).snapshots().map(
          (snap) => snap.exists ? UserModel.fromFirestore(snap) : null,
        );
  }

  static Stream<List<UserModel>> getAllUsers() {
    return _db
        .collection(FirebaseCollections.users)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(UserModel.fromFirestore).toList());
  }

  static Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _db.collection(FirebaseCollections.users).doc(uid).update(data);
  }

  static Future<void> deleteUser(String uid) {
    return _db.collection(FirebaseCollections.users).doc(uid).delete();
  }

  static Future<String> submitSurvey(SurveyModel survey) async {
    final ref = await _db
        .collection(FirebaseCollections.surveys)
        .add(survey.toFirestore());
    await _updateUserScore(survey.userId, survey.behaviourScore);
    return ref.id;
  }

  static Stream<List<SurveyModel>> getUserSurveys(String userId) {
    return _db
        .collection(FirebaseCollections.surveys)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(SurveyModel.fromFirestore).toList());
  }

  static Stream<List<SurveyModel>> getAllSurveys() {
    return _db
        .collection(FirebaseCollections.surveys)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(SurveyModel.fromFirestore).toList());
  }

  static Future<void> updateSurvey(String id, Map<String, dynamic> data) {
    return _db.collection(FirebaseCollections.surveys).doc(id).update(data);
  }

  static Future<void> deleteSurvey(String id) {
    return _db.collection(FirebaseCollections.surveys).doc(id).delete();
  }

  static Future<void> validateSurvey(
    String surveyId,
    String workerId,
    WasteStatus newStatus,
  ) {
    return _db.collection(FirebaseCollections.surveys).doc(surveyId).update({
      'isValidated': true,
      'validatedBy': workerId,
      'status': newStatus.name,
      'colorCode': newStatus.colorCode,
      'behaviourScore': newStatus.scoreImpact,
      'validatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<String> submitWasteReport(WasteReportModel report) async {
    final ref = await _db
        .collection(FirebaseCollections.reports)
        .add(report.toFirestore());
    return ref.id;
  }

  static Stream<List<WasteReportModel>> getUserReports(String userId) {
    return _db
        .collection(FirebaseCollections.reports)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(WasteReportModel.fromFirestore).toList());
  }

  static Stream<List<WasteReportModel>> getAllReports() {
    return _db
        .collection(FirebaseCollections.reports)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(WasteReportModel.fromFirestore).toList());
  }

  static Future<void> updateReport(String id, Map<String, dynamic> data) {
    return _db.collection(FirebaseCollections.reports).doc(id).update(data);
  }

  static Future<void> deleteReport(String id) {
    return _db.collection(FirebaseCollections.reports).doc(id).delete();
  }

  static Future<void> _updateUserScore(String userId, int delta) async {
    final ref = _db.collection(FirebaseCollections.scores).doc(userId);
    await _db.runTransaction((txn) async {
      final snap = await txn.get(ref);
      if (snap.exists) {
        final data = snap.data();
        final current = _asInt(data?['totalScore']);
        final ecoPoints = _asInt(data?['ecoPoints']);
        txn.update(ref, {
          'totalScore': current + delta,
          'ecoPoints': delta > 0 ? ecoPoints + delta : ecoPoints,
          'surveyCount': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        txn.set(ref, {
          'userId': userId,
          'totalScore': delta,
          'surveyCount': 1,
          'ecoPoints': delta > 0 ? delta : 0,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  static Stream<BehaviourScoreModel?> getUserScore(String userId) {
    return _db.collection(FirebaseCollections.scores).doc(userId).snapshots().map(
          (snap) => snap.exists ? BehaviourScoreModel.fromFirestore(snap) : null,
        );
  }

  static Stream<List<BehaviourScoreModel>> getLeaderboard({int limit = 50}) {
    return _db
        .collection(FirebaseCollections.scores)
        .orderBy('totalScore', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(BehaviourScoreModel.fromFirestore).toList());
  }

  static Stream<List<WorkerModel>> getWorkers() {
    return _db
        .collection(FirebaseCollections.workers)
        .orderBy('lastActive', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(WorkerModel.fromFirestore).toList());
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}
