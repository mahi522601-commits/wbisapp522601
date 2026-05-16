# WBIS - Waste Behaviour Intelligence System

WBIS is a full-stack scaffold for a waste segregation and behaviour intelligence platform aligned with Swachh Bharat Mission workflows.

## Stack

- Flutter mobile app in `client/`
- Firebase Auth, Firestore, and Storage
- FastAPI backend in `server/`
- React + TypeScript admin panel in `admin/`

## Secrets

Real Firebase and Unsplash keys are intentionally not hardcoded in source. Copy `.env.example` into the app-specific environment files you need and fill values locally.

## Quick Start

### Admin Panel

```bash
cd admin
npm install
$env:VITE_FIREBASE_API_KEY="your-api-key"
npm run dev
```

### FastAPI Backend

```bash
cd server
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### Flutter Client

```bash
cd client
flutter pub get
flutter run --dart-define=FIREBASE_API_KEY=your-api-key
```

If you want native Firebase generated files, create them locally with Firebase tooling and keep them untracked:

- `client/android/app/google-services.json`
- `client/ios/Runner/GoogleService-Info.plist`

## Firebase Rules

Deploy rules after reviewing project-specific access controls:

```bash
firebase deploy --only firestore:rules,storage
```
