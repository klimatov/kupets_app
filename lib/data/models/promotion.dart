class Promotion {
  const Promotion({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
