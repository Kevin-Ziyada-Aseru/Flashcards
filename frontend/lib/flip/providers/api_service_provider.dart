import 'package:flashcards/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Global API Service instance
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    httpClient: http.Client(),
    baseUrl: 'http://localhost:3000',
  );
});
