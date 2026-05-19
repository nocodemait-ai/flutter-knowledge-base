class MemoryModel {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final String? locationName;
  final List<String> photoUrls;
  final String createdBy;
  final String? albumId;

  MemoryModel({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.locationName,
    required this.photoUrls,
    required this.createdBy,
    this.albumId,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) => MemoryModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        date: DateTime.parse(json['date'] as String),
        locationName: json['locationName'] as String?,
        photoUrls: List<String>.from(json['photoUrls']),
        createdBy: json['createdBy'] as String,
        albumId: json['albumId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'locationName': locationName,
        'photoUrls': photoUrls,
        'createdBy': createdBy,
        'albumId': albumId,
      };

  MemoryModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? locationName,
    List<String>? photoUrls,
    String? createdBy,
    String? albumId,
  }) =>
      MemoryModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        locationName: locationName ?? this.locationName,
        photoUrls: photoUrls ?? this.photoUrls,
        createdBy: createdBy ?? this.createdBy,
        albumId: albumId ?? this.albumId,
      );
}
