import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_endpoints.dart';
import '../models/group_model.dart';

class GroupService {
  static final _dio = Dio();

  static Future<List<GroupModel>> fetchMyGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await _dio.get(
        ApiEndpoints.fetchGroups,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      List<GroupModel> groups =
          (res.data as List).map((json) => GroupModel.fromJson(json)).toList();

      return groups;
    } catch (e) {
      return [];
    }
  }

 static Future<String> createGroup({
  required String name,
  required String description,
  required String groupType,
  required String currency,
  required List<String> members,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await _dio.post(
      ApiEndpoints.createGroup,
      data: {
        "name": name,
        "description": description,
        "groupType": groupType,
        "currency": currency,
        "members": members,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return "success";
  } catch (e) {
    return "Failed to create group.";
  }
}


static Future<Map<String, dynamic>> fetchBalanceSummary() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await _dio.get(
      '${ApiEndpoints.groupBase}/balance-summary',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return res.data;
  } catch (e) {
    return {'youOwe': 0, 'owedToYou': 0};
  }
}

}


