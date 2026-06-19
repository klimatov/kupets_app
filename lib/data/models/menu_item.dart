class VolumeOption {
  const VolumeOption({
    required this.size,
    required this.unit,
    required this.price,
  });

  final String size;
  final String unit;
  final int price;

  factory VolumeOption.fromJson(Map<String, dynamic> json) {
    return VolumeOption(
      size: json['size'] as String,
      unit: json['unit'] as String,
      price: json['price'] as int,
    );
  }

  String get label => '$size $unit';
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.price,
    this.weight,
    this.volumes,
    this.abv,
    this.ibu,
    required this.imageAsset,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final int? price;
  final String? weight;
  final List<VolumeOption>? volumes;
  final String? abv;
  final String? ibu;
  final String imageAsset;

  bool get hasVolumes => volumes != null && volumes!.isNotEmpty;

  String get displayPrice {
    if (hasVolumes) {
      final prices = volumes!.map((v) => v.price).toList()..sort();
      return 'от ${prices.first} ₽';
    }
    return '${price ?? 0} ₽';
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final volumesJson = json['volumes'] as List<dynamic>?;
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: json['price'] as int?,
      weight: json['weight'] as String?,
      volumes: volumesJson
          ?.map((e) => VolumeOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      abv: json['abv'] as String?,
      ibu: json['ibu'] as String?,
      imageAsset: json['imageAsset'] as String,
    );
  }
}
