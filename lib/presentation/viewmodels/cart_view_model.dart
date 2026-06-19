import 'package:flutter/foundation.dart';

import '../../data/models/menu_item.dart';
import '../../data/models/order_line.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/menu_repository.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel(this._cartRepository, this._menuRepository);

  final CartRepository _cartRepository;
  final MenuRepository _menuRepository;

  Future<void> addItem({
    required MenuItem item,
    String? volumeLabel,
    int? price,
  }) async {
    final linePrice = price ?? item.price ?? 0;
    final name = volumeLabel != null ? '${item.name} ($volumeLabel)' : item.name;
    await _cartRepository.addLine(
      OrderLine(
        menuItemId: item.id,
        name: name,
        quantity: 1,
        price: linePrice,
        volume: volumeLabel,
      ),
    );
    notifyListeners();
  }

  Future<MenuItem?> getItem(String id) => _menuRepository.getById(id);
}
