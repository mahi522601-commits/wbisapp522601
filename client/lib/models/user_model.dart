import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { citizen, worker, admin }

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String phone;
  final UserRole role;
  final String wardName;
  final String city;
  final String householdId;
  final String? photoUrl;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.phone,
    required this.role,
    required this.wardName,
    required this.city,
    required this.householdId,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: data['uid'] ?? doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      phone: data['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == data['role'],
        orElse: () => UserRole.citizen,
      ),
      wardName: data['wardName'] ?? '',
      city: data['city'] ?? '',
      householdId: data['householdId'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: _timestampToDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'phone': phone,
        'role': role.name,
        'wardName': wardName,
        'city': city,
        'householdId': householdId,
        'photoUrl': photoUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  UserModel copyWith({
    String? displayName,
    String? phone,
    UserRole? role,
    String? wardName,
    String? city,
    String? householdId,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      wardName: wardName ?? this.wardName,
      city: city ?? this.city,
      householdId: householdId ?? this.householdId,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}

DateTime _timestampToDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}
