import 'package:flutter/foundation.dart';

import '../../core/constants/categories.dart';
import '../../data/models/menu_item.dart';
import '../../data/repositories/menu_repository.dart';

class MenuViewModel extends ChangeNotifier {
  MenuViewModel(this._menuRepository);

  final MenuRepository _menuRepository;

  List<MenuItem> _items = [];
  String _category = MenuCategories.all;
  bool _loading = false;
  String? _error;

  List<MenuItem> get items => _items;
  String get category => _category;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _menuRepository.getByCategory(_category);
    } catch (e) {
      _error = 'Не удалось загрузить меню';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> setCategory(String category) async {
    _category = category;
    await load();
  }
}
