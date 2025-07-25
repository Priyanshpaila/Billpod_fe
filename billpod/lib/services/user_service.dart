import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

class UserService {
  static final Dio _dio = Dio();

  /// Get current logged-in user profile
  static Future<UserModel?> getMyProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null || token.isEmpty) return null;

  try {
    final res = await _dio.get(
      '${ApiEndpoints.userBase}/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return UserModel.fromJson(res.data);
  } catch (e) {
    print("Error fetching profile: $e");
    return null;
  }
}

  /// Get all users (used in group creation)
  static Future<List<UserModel>> fetchAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await _dio.get(
        '${ApiEndpoints.userBase}/all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return (response.data as List).map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Optional: Update user profile (name, image, etc.)
  static Future<bool> updateUserProfile(UserModel updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      await _dio.put(
        '${ApiEndpoints.userBase}/me',
        data: updatedUser.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
