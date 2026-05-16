class AppConfig {
  static const String appName = 'WBIS';
  static const String fullName = 'Waste Behaviour Intelligence System';
  static const String version = '2.0.0';
  static const String apiBaseUrl = String.fromEnvironment(
    'WBIS_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
  static const String unsplashApiKey =
      String.fromEnvironment('UNSPLASH_API_KEY');
}
