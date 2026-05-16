import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/survey_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class SurveyProvider extends ChangeNotifier {
  bool _submitting = false;
  double _uploadProgress = 0;
  String? _error;

  bool get submitting => _submitting;
  double get uploadProgress => _uploadProgress;
  String? get error => _error;

  Future<String> submitSurvey({
    required String userId,
    required String householdId,
    required String wardName,
    required String city,
    required WasteStatus status,
    required Position position,
    String? notes,
    File? photo,
  }) async {
    _submitting = true;
    _uploadProgress = 0;
    _error = null;
    notifyListeners();

    try {
      String? photoUrl;
      if (photo != null) {
        photoUrl = await StorageService.uploadWastePhoto(
          imageFile: photo,
          userId: userId,
          onProgress: (progress) {
            _uploadProgress = progress;
            notifyListeners();
          },
        );
      }

      final survey = SurveyModel(
        id: '',
        userId: userId,
        householdId: householdId,
        wardName: wardName,
        city: city,
        status: status,
        latitude: position.latitude,
        longitude: position.longitude,
        photoUrl: photoUrl,
        workerNotes: notes,
        behaviourScore: status.scoreImpact,
        createdAt: DateTime.now(),
        metadata: const {
          'appVersion': '2.0.0',
          'platform': 'android',
        },
      );

      return FirestoreService.submitSurvey(survey);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }
}
