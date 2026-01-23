import 'package:flashcards/flip/model/flashset_model.dart';
import 'package:flashcards/flip/providers/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Get all flashsets
final flashsetsProvider = FutureProvider<List<Flashset>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getAllFlashsets();
});

// Create a new flashset
final createFlashsetProvider =
    FutureProvider.family<Flashset, (String, String)>((ref, params) async {
      final apiService = ref.watch(apiServiceProvider);
      final flashset = await apiService.createFlashset(
        name: params.$1,
        detail: params.$2,
      );
      ref.invalidate(flashsetsProvider);
      return flashset;
    });

// Update a flashset
final updateFlashsetProvider =
    FutureProvider.family<Flashset, (int, String, String)>((ref, params) async {
      final apiService = ref.watch(apiServiceProvider);
      final flashset = await apiService.updateFlashset(
        id: params.$1,
        name: params.$2,
        detail: params.$3,
      );
      ref.invalidate(flashsetsProvider);
      return flashset;
    });

// Delete a flashset
final deleteFlashsetProvider = FutureProvider.family<void, int>((
  ref,
  id,
) async {
  final apiService = ref.watch(apiServiceProvider);
  await apiService.deleteFlashset(id);
  ref.invalidate(flashsetsProvider);
});
