class OrderLine {
  const OrderLine({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.volume,
  });

  final String menuItemId;
  final String name;
  final int quantity;
  final int price;
  final String? volume;

  int get total => price * quantity;

  Map<String, dynamic> toJson() => {
        'menuItemId': menuItemId,
        'name': name,
        'quantity': quantity,
        'price': price,
        'volume': volume,
      };

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as int,
      volume: json['volume'] as String?,
    );
  }
}

class OrderHistoryEntry {
  const OrderHistoryEntry({
    required this.id,
    required this.createdAt,
    required this.lines,
  });

  final String id;
  final DateTime createdAt;
  final List<OrderLine> lines;

  int get total => lines.fold(0, (sum, line) => sum + line.total);

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'lines': lines.map((e) => e.toJson()).toList(),
      };

  factory OrderHistoryEntry.fromJson(Map<String, dynamic> json) {
    return OrderHistoryEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => OrderLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
