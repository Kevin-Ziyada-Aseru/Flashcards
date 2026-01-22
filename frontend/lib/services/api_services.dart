import 'dart:convert';

import 'package:flashcards/flip/model/flashset_model.dart';
import 'package:http/http.dart' as http;

// Service class to handle API requests
class ApiServices {
  static const String baseUrl = 'http://localhost:3000/';
  // Fetch all flashsets
  Future<List<Flashset>> fetchSets() async {
    final response = await http.get(Uri.parse('$baseUrl/flipcards'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Flashset.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load flashsets');
    }
  }
}
