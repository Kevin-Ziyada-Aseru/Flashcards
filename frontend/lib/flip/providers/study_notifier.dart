import 'package:flashcards/flip/model/study_session.dart';
import 'package:flashcards/flip/providers/api_service_provider.dart';
import 'package:flashcards/flip/providers/flashcard_provider.dart';
import 'package:flashcards/flip/view/study_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Get all study sessions for a set
final studySessionsProvider = FutureProvider.family<List<StudySession>, int>((
  ref,
  setId,
) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getStudySessionsBySet(setId);
});

// Create a new study session
final createStudySessionProvider =
    FutureProvider.family<StudySession, (int, int, int, int)>((
      ref,
      params,
    ) async {
      final apiService = ref.watch(apiServiceProvider);
      final session = await apiService.createStudySession(
        setId: params.$1,
        totalCards: params.$2,
        correctCount: params.$3,
        wrongCount: params.$4,
      );
      ref.invalidate(studySessionsProvider(params.$1));
      return session;
    });

// Study state provider
final studyProvider = StateNotifierProvider<StudyNotifier, StudyState>((ref) {
  return StudyNotifier(ref);
});

// Initialize study with cards from a set
final initializeStudyProvider = FutureProvider.family<void, int>((
  ref,
  setId,
) async {
  final cards = await ref.watch(cardsBySetProvider(setId).future);
  ref.read(studyProvider.notifier).loadCards(cards);
});

// Save study session to backend
final saveStudySessionProvider = FutureProvider.family<StudySession, int>((
  ref,
  setId,
) async {
  final study = ref.watch(studyProvider);
  final session = await ref.read(
    createStudySessionProvider((
      setId,
      study.cards.length,
      study.correctCount,
      study.wrongCount,
    )).future,
  );
  return session;
});
