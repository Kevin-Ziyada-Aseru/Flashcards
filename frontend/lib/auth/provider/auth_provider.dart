import 'package:flashcards/auth/model/authapi_service_provider.dart';
import 'package:flashcards/auth/model/authuser_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'auth_notifier.dart';

// AUTH STATE PROVIDER

/// Main auth state provider

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  return AuthNotifier(authApiService);
});

// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

/// Get current user
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

/// Get auth token
final authTokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.token;
});

/// Get loading state
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

/// Get error message
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.error;
});
// REGISTER PROVIDER

/// Register a new user
final registerProvider =
    FutureProvider.family<AuthUser, (String, String, String)>((
      ref,
      params,
    ) async {
      final authNotifier = ref.read(authProvider.notifier);

      await authNotifier.register(
        name: params.$1,
        email: params.$2,
        password: params.$3,
      );

      final authState = ref.read(authProvider);
      return authState.user!;
    });

// LOGIN PROVIDER

/// Login user
final loginProvider = FutureProvider.family<AuthUser, (String, String)>((
  ref,
  params,
) async {
  final authNotifier = ref.read(authProvider.notifier);

  await authNotifier.login(email: params.$1, password: params.$2);

  final authState = ref.read(authProvider);
  return authState.user!;
});

// LOGOUT PROVIDER

/// Logout user
final logoutProvider = FutureProvider<void>((ref) async {
  final authNotifier = ref.read(authProvider.notifier);
  await authNotifier.logout();
});
