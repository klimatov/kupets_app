class Meal {
  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumbnail,
    required this.instructions,
  });

  final String id;
  final String name;
  final String category;
  final String area;
  final String thumbnail;
  final String instructions;

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      thumbnail: json['strMealThumb'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
    );
  }
}
