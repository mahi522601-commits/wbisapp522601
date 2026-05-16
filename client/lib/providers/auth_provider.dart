import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class WBISAuthProvider extends ChangeNotifier {
  fb.User? _user;
  UserModel? _profile;
  bool _loading = true;
  bool _profileLoaded = false;
  String? _error;
  StreamSubscription<fb.User?>? _authSub;
  StreamSubscription<UserModel?>? _profileSub;

  WBISAuthProvider() {
    _authSub = AuthService.authStateChanges.listen(_handleAuthChange);
  }

  fb.User? get user => _user;
  UserModel? get profile => _profile;
  bool get loading => _loading;
  bool get isProfileLoaded => _profileLoaded;
  String? get error => _error;
  bool get isSignedIn => _user != null;

  Future<void> _handleAuthChange(fb.User? user) async {
    _user = user;
    _profile = null;
    _profileLoaded = false;
    await _profileSub?.cancel();

    if (user != null) {
      _profileSub = FirestoreService.getUser(user.uid).listen((profile) {
        _profile = profile;
        _profileLoaded = true;
        _loading = false;
        notifyListeners();
      });
    } else {
      _profileLoaded = true;
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    await _run(() => AuthService.signIn(email: email, password: password));
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required String phone,
    required String wardName,
    required String city,
    required String householdId,
  }) async {
    await _run(() async {
      final credential = await AuthService.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      final user = credential.user!;
      await FirestoreService.createUser(
        UserModel(
          uid: user.uid,
          email: email.trim(),
          displayName: displayName.trim(),
          phone: phone.trim(),
          role: UserRole.citizen,
          wardName: wardName.trim(),
          city: city.trim(),
          householdId: householdId.trim(),
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  Future<void> signOut() async {
    await AuthService.signOut();
  }

  Future<void> _run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}
