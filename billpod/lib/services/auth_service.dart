import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_endpoints.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.authBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Login user with email and password
  static Future<String> login(String email, String password) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email.trim(), 'password': password.trim()},
      );
      final token = res.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return "Login successful";
    } on DioException catch (e) {
      return e.response?.data['message'] ?? "Login failed: ${e.message}";
    } catch (e) {
      return "Unexpected error during login.";
    }
  }

  /// Register a new user
  static Future<String> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.signup,
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password.trim(),
        },
      );
      final token = res.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return "Signup successful";
    } on DioException catch (e) {
      return e.response?.data['message'] ?? "Signup failed: ${e.message}";
    } catch (e) {
      return "Unexpected error during signup.";
    }
  }

  /// Get the saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

 /// Clear stored token and call backend logout
static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  try {
    if (token != null) {
      await _dio.post(
        ApiEndpoints.logout, // e.g., "$authBase/logout"
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    }
  } catch (e) {
    print('Logout API failed: $e');
  }

  // Remove token regardless of success/failure
  await prefs.remove('token');
}
}
