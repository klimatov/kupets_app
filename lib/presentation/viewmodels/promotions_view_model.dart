import 'package:flutter/foundation.dart';

import '../../data/models/meal.dart';
import '../../data/models/promotion.dart';
import '../../data/repositories/meal_repository.dart';
import '../../data/repositories/menu_repository.dart';

class PromotionsViewModel extends ChangeNotifier {
  PromotionsViewModel(this._promotionRepository, this._mealRepository);

  final PromotionRepository _promotionRepository;
  final MealRepository _mealRepository;

  List<Promotion> _promotions = [];
  Meal? _meal;
  bool _loading = false;
  String? _mealError;

  List<Promotion> get promotions => _promotions;
  Meal? get meal => _meal;
  bool get loading => _loading;
  String? get mealError => _mealError;

  Future<void> load() async {
    _loading = true;
    _mealError = null;
    notifyListeners();
    try {
      _promotions = await _promotionRepository.getAll();
      _meal = await _mealRepository.getRandomMeal();
      if (_meal == null) {
        _mealError = 'Не удалось загрузить гастро-идею';
      }
    } catch (_) {
      _mealError = 'Ошибка сети';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
