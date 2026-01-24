import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth_api_service.dart';

/// Global Auth API Service instance
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(
    httpClient: http.Client(),
    baseUrl: 'http://localhost:3000',
  );
});
