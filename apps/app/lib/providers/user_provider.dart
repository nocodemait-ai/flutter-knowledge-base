import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(id: 'usr_001', rewardCount: 0, badgeLevel: 'Bean Novice'));

  void incrementProgress() {
    final newCount = state.rewardCount + 1;
    state = state.copyWith(
      rewardCount: newCount,
      badgeLevel: _calculateBadge(newCount),
    );
  }

  String _calculateBadge(int count) {
    if (count <= 5) return 'Bean Novice';
    if (count <= 10) return 'Coffee Aficionado';
    return 'Barista Master';
  }

  String get currentBadge => state.badgeLevel;
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());