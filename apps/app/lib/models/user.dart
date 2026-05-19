class User {
  final String id;
  final int rewardCount;
  final String badgeLevel;

  User({required this.id, required this.rewardCount, required this.badgeLevel});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        rewardCount: json['rewardCount'] as int,
        badgeLevel: json['badgeLevel'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'rewardCount': rewardCount,
        'badgeLevel': badgeLevel,
      };

  User copyWith({int? rewardCount, String? badgeLevel}) => User(
        id: id,
        rewardCount: rewardCount ?? this.rewardCount,
        badgeLevel: badgeLevel ?? this.badgeLevel,
      );
}