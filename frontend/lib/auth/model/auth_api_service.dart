import 'package:flashcards/auth/model/authuser_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiService {
  final http.Client httpClient;
  final String baseUrl;

  AuthApiService({
    http.Client? httpClient,
    this.baseUrl = 'http://localhost:3000',
  }) : httpClient = httpClient ?? http.Client();


  // Register a new user
  // Returns: AuthUser
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return AuthUser.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to register');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  /// Login user
  /// Returns: AuthResponse with token and user
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to login');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // ========================================================================
  // LOGOUT (optional - just clears client side)
  // ========================================================================

  /// Logout user (token is cleared on client side)
  Future<void> logout() async {
    try {
      // Token is managed on client side, backend doesn't need to track
      // Just clear local storage on client
      return;
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
}
