# WBIS Flutter Client

Run with environment-backed Firebase settings:

```bash
flutter pub get
flutter run --dart-define=FIREBASE_API_KEY=your-api-key
```

Optional dart defines:

- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_ANDROID_APP_ID`

Native Firebase files are intentionally ignored by git. Add `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` locally if your build pipeline needs them.
