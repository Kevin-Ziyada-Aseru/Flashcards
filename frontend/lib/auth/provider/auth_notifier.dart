import 'package:flashcards/auth/model/auth_api_service.dart';
import 'package:flashcards/auth/model/authuser_model.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Authentication state
class AuthState {
  final AuthUser? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  /// Copy with modified fields
  AuthState copyWith({
    AuthUser? user,
    String? token,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  /// Clear error
  AuthState clearError() {
    return AuthState(
      user: user,
      token: token,
      isLoading: isLoading,
      error: null,
      isAuthenticated: isAuthenticated,
    );
  }

  /// Clear all (logout)
  AuthState cleared() {
    return AuthState(
      user: null,
      token: null,
      isLoading: false,
      error: null,
      isAuthenticated: false,
    );
  }
}

/// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService authApiService;

  AuthNotifier(this.authApiService) : super(AuthState());

  /// Register new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await authApiService.register(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Login user
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await authApiService.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: authResponse.user,
        token: authResponse.token,
        isLoading: false,
        isAuthenticated: true,
      );

      // TODO: Save token to secure storage
      // await _saveToken(authResponse.token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await authApiService.logout();
    state = state.cleared();

    // TODO: Clear secure storage
    // await _clearToken();
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }
}
