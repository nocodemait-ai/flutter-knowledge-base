class Asset {
  final String id;
  final String name;
  final double value;

  Asset({
    required this.id,
    required this.name,
    required this.value,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'] as String,
        name: json['name'] as String,
        value: (json['value'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
      };

  Asset copyWith({
    String? id,
    String? name,
    double? value,
  }) =>
      Asset(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
      );
}