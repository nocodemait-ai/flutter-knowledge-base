class AlbumModel {
  final String id;
  final String title;
  final String coverImageUrl;
  final List<String> members;
  final String privacy;

  AlbumModel({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.members,
    required this.privacy,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
        id: json['id'] as String,
        title: json['title'] as String,
        coverImageUrl: json['coverImageUrl'] as String,
        members: List<String>.from(json['members']),
        privacy: json['privacy'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverImageUrl': coverImageUrl,
        'members': members,
        'privacy': privacy,
      };
}
