import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthRepository {
  Stream<bool> get authStateChanges;
  bool get isLoggedIn;
  String? get currentEmail;
  Future<void> signIn({required String email, required String password});
  Future<void> signUp({required String email, required String password});
  Future<void> signOut();
}

class HiveAuthRepository implements AuthRepository {
  HiveAuthRepository();

  static const _sessionKey = 'session_email';
  static const _boxName = 'auth_box';

  String? _email;

  @override
  Stream<bool> get authStateChanges => Stream.value(isLoggedIn);

  @override
  bool get isLoggedIn => _email != null && _email!.isNotEmpty;

  @override
  String? get currentEmail => _email;

  Future<void> restoreSession() async {
    final box = await _openAuthBox();
    _email = box.get(_sessionKey);
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.length < 6) {
      throw AuthException('Введите email и пароль (мин. 6 символов)');
    }
    final box = await _openAuthBox();
    _email = email.trim();
    await box.put(_sessionKey, _email!);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    final box = await _openAuthBox();
    _email = null;
    await box.delete(_sessionKey);
  }

  Future<Box<String>> _openAuthBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  bool get isLoggedIn => _auth.currentUser != null;

  @override
  String? get currentEmail => _auth.currentUser?.email;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() => _auth.signOut();
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
