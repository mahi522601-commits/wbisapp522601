class QRPayload {
  final String householdId;
  final String? wardName;
  final String? city;

  const QRPayload({
    required this.householdId,
    this.wardName,
    this.city,
  });
}

class QRService {
  static QRPayload? parseHouseholdCode(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return null;

    final parts = trimmed.split(':');
    if (parts.length >= 2 && parts.first.toUpperCase() == 'WBIS') {
      return QRPayload(
        householdId: parts[1],
        wardName: parts.length > 2 ? parts[2] : null,
        city: parts.length > 3 ? parts[3] : null,
      );
    }

    return QRPayload(householdId: trimmed);
  }
}
