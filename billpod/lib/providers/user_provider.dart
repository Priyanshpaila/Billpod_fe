import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier()..loadUser();
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  Future<void> loadUser() async {
    final user = await UserService.getMyProfile();
    state = user;
  }

  void updateUser(UserModel updated) {
    state = updated;
  }
}
