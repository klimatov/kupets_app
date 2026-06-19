import 'package:flutter/foundation.dart';

import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authRepository);

  final AuthRepository _authRepository;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _authRepository.isLoggedIn;
  String? get email => _authRepository.currentEmail;

  Future<void> restore() async {
    final repo = _authRepository;
    if (repo is HiveAuthRepository) {
      await repo.restoreSession();
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    return _run(() => _authRepository.signIn(email: email, password: password));
  }

  Future<bool> signUp(String email, String password) async {
    return _run(() => _authRepository.signUp(email: email, password: password));
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } on Exception catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
