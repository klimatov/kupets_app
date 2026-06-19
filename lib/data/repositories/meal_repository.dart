import '../datasources/meal_remote_datasource.dart';
import '../models/meal.dart';

class MealRepository {
  MealRepository(this._remote);

  final MealRemoteDataSource _remote;

  Future<Meal?> getRandomMeal() => _remote.fetchRandomMeal();
}
