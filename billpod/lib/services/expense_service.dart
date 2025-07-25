import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_endpoints.dart';
import '../models/expense_model.dart';

class ExpenseService {
  static final _dio = Dio();

  static Future<List<ExpenseModel>> fetchExpenses(String groupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final res = await _dio.get(
        ApiEndpoints.getGroupExpenses(groupId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return (res.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<String> createExpense({
  required String groupId,
  required double amount,
  required String description,
  required String category,
  required String paidBy,
  required List<String> participants,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await _dio.post(
      ApiEndpoints.addExpense,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {
        'groupId': groupId,
        'amount': amount,
        'description': description,
        'category': category,
        'paidBy': paidBy,
        'participants': participants,
        'splitType': 'equal',
      },
    );
    return 'success';
  } catch (e) {
    return 'Failed to add expense';
  }
}

}
