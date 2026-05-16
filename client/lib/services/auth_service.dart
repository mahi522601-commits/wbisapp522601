import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthService {
  static final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  static fb.User? get currentUser => _auth.currentUser;
  static Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  static Future<fb.UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<fb.UserCredential> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(displayName.trim());
    return credential;
  }

  static Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> signOut() => _auth.signOut();
}
