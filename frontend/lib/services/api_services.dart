import 'package:flashcards/flip/model/flashcard_model.dart';
import 'package:flashcards/flip/model/flashset_model.dart';
import 'package:flashcards/flip/model/study_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final http.Client httpClient;
  final String baseUrl;

  ApiService({http.Client? httpClient, this.baseUrl = 'http://localhost:3000'})
    : httpClient = httpClient ?? http.Client();

  // flash sets
  // getting all flashsets
  Future<List<Flashset>> getAllFlashsets() async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/flipcards'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Flashset.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load flashsets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading flashsets: $e');
    }
  }
// creating a new flashset
  Future<Flashset> createFlashset({
    required String name,
    required String detail,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/flipcards'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'detail': detail}),
      );

      if (response.statusCode == 200) {
        return Flashset.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create flashset: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating flashset: $e');
    }
  }
// updating a flashset
  Future<Flashset> updateFlashset({
    required int id,
    required String name,
    required String detail,
  }) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl/flipcards/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'detail': detail}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Flashset.fromJson(data['updatedItem']);
      } else {
        throw Exception('Failed to update flashset: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating flashset: $e');
    }
  }

// deleting a flashset
  Future<void> deleteFlashset(int id) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/flipcards/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete flashset: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting flashset: $e');
    }
  }

  // flash cards
// getting all cards for a specific set
  Future<List<Flashcard>> getCardsBySet(int setId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/cards/set/$setId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Flashcard.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cards: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading cards: $e');
    }
  }
// creating a new card
  Future<Flashcard> createCard({
    required int setId,
    required String question,
    required String answer,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/cards/$setId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question, 'answer': answer}),
      );

      if (response.statusCode == 200) {
        return Flashcard.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create card: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating card: $e');
    }
  }


// updating a card
  Future<Flashcard> updateCard({
    required int cardId,
    required String question,
    required String answer,
  }) async {
    try {
      final response = await httpClient.patch(
        Uri.parse('$baseUrl/cards/$cardId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question, 'answer': answer}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Flashcard.fromJson(data['cards']);
      } else {
        throw Exception('Failed to update card: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating card: $e');
    }
  }
// deleting a card
  Future<void> deleteCard(int cardId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/cards/$cardId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete card: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting card: $e');
    }
  }
// getting full set with all cards
  Future<Map<String, dynamic>> getFullSet(int setId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/cards/full-set/$setId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load full set: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading full set: $e');
    }
  }

  // Study Sessions
// creating a new study session
  Future<StudySession> createStudySession({
    required int setId,
    required int totalCards,
    required int correctCount,
    required int wrongCount,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/study_sessions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'set_id': setId,
          'total_cards': totalCards,
          'correct_count': correctCount,
          'wrong_count': wrongCount,
        }),
      );

      if (response.statusCode == 201) {
        return StudySession.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to create study session: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating study session: $e');
    }
  }
// Get study sessions by set
  Future<List<StudySession>> getStudySessionsBySet(int setId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/study_sessions/set/$setId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => StudySession.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load study sessions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading study sessions: $e');
    }
  }
}
