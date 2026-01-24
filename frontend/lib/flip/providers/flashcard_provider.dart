import 'package:flashcards/flip/model/flashcard_model.dart';
import 'package:flashcards/flip/providers/api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Get all cards for a specific set
final cardsBySetProvider = FutureProvider.family<List<Flashcard>, int>((
  ref,
  setId,
) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getCardsBySet(setId);
});

// Create a new card
final createCardProvider =
    FutureProvider.family<Flashcard, (int, String, String)>((
      ref,
      params,
    ) async {
      final apiService = ref.watch(apiServiceProvider);
      final card = await apiService.createCard(
        setId: params.$1,
        question: params.$2,
        answer: params.$3,
      );
      ref.invalidate(cardsBySetProvider(params.$1));
      return card;
    });

// Update a card
final updateCardProvider =
    FutureProvider.family<Flashcard, (int, String, String)>((
      ref,
      params,
    ) async {
      final apiService = ref.watch(apiServiceProvider);
      final card = await apiService.updateCard(
        cardId: params.$1,
        question: params.$2,
        answer: params.$3,
      );
      ref.invalidate(cardsBySetProvider(card.setId));
      return card;
    });

// Delete a card
final deleteCardProvider = FutureProvider.family<void, int>((
  ref,
  cardId,
) async {
  final apiService = ref.watch(apiServiceProvider);
  await apiService.deleteCard(cardId);
});

// Get full set with all cards
final fullSetProvider = FutureProvider.family<Map<String, dynamic>, int>((
  ref,
  setId,
) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getFullSet(setId);
});
