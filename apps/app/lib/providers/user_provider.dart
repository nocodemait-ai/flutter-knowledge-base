import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(id: 'usr_001', rewardCount: 0, badgeLevel: 'Bean Novice'));

  void incrementProgress() {
    final newCount = state.rewardCount + 1;
    String newBadge = 'Bean Novice';
    if (newCount > 10) {
      newBadge = 'Barista Master';
    } else if (newCount > 5) {
      newBadge = 'Coffee Aficionado';
    }

    state = state.copyWith(rewardCount: newCount, badgeLevel: newBadge);
  }

  String get currentBadge => state.badgeLevel;
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());