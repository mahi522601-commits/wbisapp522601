import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static const String _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String _projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'wbis-ba283',
  );
  static const String _storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'wbis-ba283.firebasestorage.app',
  );
  static const String _senderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '720453653584',
  );
  static const String _androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
    defaultValue: '1:720453653584:android:c98d9010b1aad9cfc26d55',
  );

  static bool get isConfigured => _apiKey.isNotEmpty;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for the WBIS client.');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('This platform is not configured for WBIS.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _apiKey,
    appId: _androidAppId,
    messagingSenderId: _senderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
  );
}
