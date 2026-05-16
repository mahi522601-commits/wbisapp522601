import 'package:cloud_firestore/cloud_firestore.dart';

enum WasteStatus { proper, minorMixing, mixedWaste, hazardous }

extension WasteStatusExtension on WasteStatus {
  String get label {
    switch (this) {
      case WasteStatus.proper:
        return 'Proper Segregation';
      case WasteStatus.minorMixing:
        return 'Minor Mixing';
      case WasteStatus.mixedWaste:
        return 'Mixed Waste';
      case WasteStatus.hazardous:
        return 'Hazardous Waste';
    }
  }

  String get colorCode {
    switch (this) {
      case WasteStatus.proper:
        return 'GREEN';
      case WasteStatus.minorMixing:
        return 'YELLOW';
      case WasteStatus.mixedWaste:
        return 'RED';
      case WasteStatus.hazardous:
        return 'BLACK';
    }
  }

  int get scoreImpact {
    switch (this) {
      case WasteStatus.proper:
        return 10;
      case WasteStatus.minorMixing:
        return 5;
      case WasteStatus.mixedWaste:
        return -5;
      case WasteStatus.hazardous:
        return -15;
    }
  }
}

class SurveyModel {
  final String id;
  final String userId;
  final String householdId;
  final String wardName;
  final String city;
  final WasteStatus status;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? workerNotes;
  final int behaviourScore;
  final bool isValidated;
  final String? validatedBy;
  final DateTime createdAt;
  final DateTime? validatedAt;
  final Map<String, dynamic> metadata;

  const SurveyModel({
    required this.id,
    required this.userId,
    required this.householdId,
    required this.wardName,
    required this.city,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.workerNotes,
    required this.behaviourScore,
    this.isValidated = false,
    this.validatedBy,
    required this.createdAt,
    this.validatedAt,
    this.metadata = const {},
  });

  factory SurveyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SurveyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      householdId: data['householdId'] ?? '',
      wardName: data['wardName'] ?? '',
      city: data['city'] ?? '',
      status: WasteStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => WasteStatus.mixedWaste,
      ),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      photoUrl: data['photoUrl'],
      workerNotes: data['workerNotes'],
      behaviourScore: data['behaviourScore'] ?? 0,
      isValidated: data['isValidated'] ?? false,
      validatedBy: data['validatedBy'],
      createdAt: _timestampToDate(data['createdAt']),
      validatedAt: data['validatedAt'] != null
          ? _timestampToDate(data['validatedAt'])
          : null,
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'householdId': householdId,
        'wardName': wardName,
        'city': city,
        'status': status.name,
        'colorCode': status.colorCode,
        'latitude': latitude,
        'longitude': longitude,
        'photoUrl': photoUrl,
        'workerNotes': workerNotes,
        'behaviourScore': behaviourScore,
        'isValidated': isValidated,
        'validatedBy': validatedBy,
        'createdAt': Timestamp.fromDate(createdAt),
        'validatedAt':
            validatedAt != null ? Timestamp.fromDate(validatedAt!) : null,
        'metadata': metadata,
      };
}

DateTime _timestampToDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
