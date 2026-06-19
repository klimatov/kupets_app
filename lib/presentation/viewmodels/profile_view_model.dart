import 'package:flutter/foundation.dart';

import '../../data/models/order_line.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/cart_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(
    this._cartRepository,
    this._profileRepository,
    this._authRepository,
  );

  final CartRepository _cartRepository;
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  String? get avatarPath => _profileRepository.avatarPath;
  List<OrderLine> get cartLines => _cartRepository.lines;
  int get cartTotal => _cartRepository.total;
  List<OrderHistoryEntry> get history => _cartRepository.history;
  String? get email => _authRepository.currentEmail;

  void refresh() => notifyListeners();

  Future<void> setAvatar(String path) async {
    await _profileRepository.setAvatarPath(path);
    notifyListeners();
  }

  Future<void> removeFromCart(int index) async {
    await _cartRepository.removeAt(index);
    notifyListeners();
  }

  Future<void> checkout() async {
    await _cartRepository.checkout();
    notifyListeners();
  }

  Future<void> clearCart() async {
    await _cartRepository.clear();
    notifyListeners();
  }

  Future<void> signOut() => _authRepository.signOut();
}
