import 'package:cloud_firestore/cloud_firestore.dart';

enum ReportStatus { submitted, underReview, resolved, rejected }
enum WasteCategory { dry, wet, sanitary, hazardous, mixed, unknown }

class WasteReportModel {
  final String id;
  final String userId;
  final WasteCategory category;
  final ReportStatus status;
  final String description;
  final String city;
  final String wardName;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const WasteReportModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.status,
    required this.description,
    required this.city,
    required this.wardName,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    required this.createdAt,
    this.resolvedAt,
  });

  factory WasteReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return WasteReportModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      category: WasteCategory.values.firstWhere(
        (category) => category.name == data['category'],
        orElse: () => WasteCategory.unknown,
      ),
      status: ReportStatus.values.firstWhere(
        (status) => status.name == data['status'],
        orElse: () => ReportStatus.submitted,
      ),
      description: data['description'] ?? '',
      city: data['city'] ?? '',
      wardName: data['wardName'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      photoUrl: data['photoUrl'],
      createdAt: _timestampToDate(data['createdAt']),
      resolvedAt:
          data['resolvedAt'] != null ? _timestampToDate(data['resolvedAt']) : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'category': category.name,
        'status': status.name,
        'description': description,
        'city': city,
        'wardName': wardName,
        'latitude': latitude,
        'longitude': longitude,
        'photoUrl': photoUrl,
        'createdAt': Timestamp.fromDate(createdAt),
        'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      };
}

DateTime _timestampToDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
