import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealRemoteDataSource {
  MealRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Meal?> fetchRandomMeal() async {
    final response = await _client.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );
    if (response.statusCode != 200) return null;
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = json['meals'] as List<dynamic>?;
    if (meals == null || meals.isEmpty) return null;
    return Meal.fromJson(meals.first as Map<String, dynamic>);
  }
}
