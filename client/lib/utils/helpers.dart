import 'package:intl/intl.dart';

class WBISHelpers {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, h:mm a').format(date);
  }

  static String compactNumber(num value) {
    return NumberFormat.compact(locale: 'en_IN').format(value);
  }

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'W';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
