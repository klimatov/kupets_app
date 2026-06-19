import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/menu_item.dart';
import '../models/promotion.dart';

class MenuAssetDataSource {
  Future<List<MenuItem>> loadMenu() async {
    final raw = await rootBundle.loadString('assets/data/menu.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = json['items'] as List<dynamic>;
    return items
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class PromotionAssetDataSource {
  Future<List<Promotion>> loadPromotions() async {
    final raw = await rootBundle.loadString('assets/data/promotions.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = json['promotions'] as List<dynamic>;
    return items
        .map((e) => Promotion.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
