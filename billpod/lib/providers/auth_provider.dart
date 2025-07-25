import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../services/auth_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? message;

  const AuthState({this.status = AuthStatus.initial, this.token, this.message});

  AuthState copyWith({AuthStatus? status, String? token, String? message}) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      message: message ?? this.message,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final _controller = StreamController<AuthState>.broadcast();
  Stream<AuthState> get stream => _controller.stream;

  AuthNotifier() : super(const AuthState()) {
    _loadToken();
  }

  void _emit(AuthState newState) {
    state = newState;
    _controller.add(newState);
  }

  Future<void> _loadToken() async {
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      _emit(state.copyWith(status: AuthStatus.authenticated, token: token));
    } else {
      _emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String email, String password) async {
    _emit(state.copyWith(status: AuthStatus.loading));
    final result = await AuthService.login(email, password);
    final token = await AuthService.getToken();

    if (result.contains("successful") && token != null) {
      _emit(state.copyWith(status: AuthStatus.authenticated, token: token));
    } else {
      _emit(state.copyWith(status: AuthStatus.error, message: result));
    }
  }

  Future<void> signup(String name, String email, String password) async {
    _emit(state.copyWith(status: AuthStatus.loading));
    final result = await AuthService.signup(name, email, password);
    final token = await AuthService.getToken();

    if (result.contains("successful") && token != null) {
      _emit(state.copyWith(status: AuthStatus.authenticated, token: token));
    } else {
      _emit(state.copyWith(status: AuthStatus.error, message: result));
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
