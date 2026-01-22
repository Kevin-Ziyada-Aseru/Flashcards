import 'package:flashcards/flip/model/flashset_model.dart';
import 'package:flashcards/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import the Flashset model
final apiServiceProvider = Provider((ref) => ApiServices());

// Provider to fetch flashsets
final flashsetsProvider = FutureProvider<List<Flashset>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchSets();
});
