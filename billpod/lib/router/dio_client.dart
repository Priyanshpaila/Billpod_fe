import 'package:billpod/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
 // where _routerKey is defined

final dio = Dio(BaseOptions(baseUrl: "http://your-ip:5000/api")) // adjust base
  ..interceptors.add(
    InterceptorsWrapper(
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');

          routerKey.currentContext?.go('/auth'); // ✅ safe redirect

          debugPrint("🔒 Auto-logged out due to 401");
        }

        return handler.next(e);
      },
    ),
  );
