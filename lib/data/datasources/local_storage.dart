import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/order_line.dart';

class CartLocalDataSource {
  static const boxName = 'cart_box';
  static const cartKey = 'lines';
  static const historyKey = 'history';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }

  Box<String> get _box => Hive.box<String>(boxName);

  List<OrderLine> getCartLines() {
    final raw = _box.get(cartKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCartLines(List<OrderLine> lines) async {
    final encoded = jsonEncode(lines.map((e) => e.toJson()).toList());
    await _box.put(cartKey, encoded);
  }

  List<OrderHistoryEntry> getOrderHistory() {
    final raw = _box.get(historyKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => OrderHistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveOrderHistory(List<OrderHistoryEntry> entries) async {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _box.put(historyKey, encoded);
  }
}

class ProfileLocalDataSource {
  static const boxName = 'profile_box';
  static const avatarKey = 'avatar_path';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }

  Box<String> get _box => Hive.box<String>(boxName);

  String? get avatarPath => _box.get(avatarKey);

  Future<void> setAvatarPath(String? path) async {
    if (path == null) {
      await _box.delete(avatarKey);
    } else {
      await _box.put(avatarKey, path);
    }
  }
}
