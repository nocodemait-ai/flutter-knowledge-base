class MenuItem {
  final String name;
  final double price;
  final String description;

  MenuItem({
    required this.name,
    required this.price,
    required this.description,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'description': description,
      };

  MenuItem copyWith({
    String? name,
    double? price,
    String? description,
  }) =>
      MenuItem(
        name: name ?? this.name,
        price: price ?? this.price,
        description: description ?? this.description,
      );
}