import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/waste_report_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class ReportProvider extends ChangeNotifier {
  bool _submitting = false;
  double _uploadProgress = 0;
  String? _error;

  bool get submitting => _submitting;
  double get uploadProgress => _uploadProgress;
  String? get error => _error;

  Future<String> submitReport({
    required String userId,
    required WasteCategory category,
    required String description,
    required String wardName,
    required String city,
    required Position position,
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

      final report = WasteReportModel(
        id: '',
        userId: userId,
        category: category,
        status: ReportStatus.submitted,
        description: description,
        wardName: wardName,
        city: city,
        latitude: position.latitude,
        longitude: position.longitude,
        photoUrl: photoUrl,
        createdAt: DateTime.now(),
      );
      return FirestoreService.submitWasteReport(report);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }
}
