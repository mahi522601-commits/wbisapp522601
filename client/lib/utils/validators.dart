class Validators {
  static String? required(String? value, [String label = 'Field']) {
    return value == null || value.trim().isEmpty ? '$label is required' : null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim());
    return ok ? null : 'Enter a valid email';
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
