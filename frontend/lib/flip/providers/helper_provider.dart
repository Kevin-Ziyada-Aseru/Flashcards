import 'package:flashcards/flip/model/flashcard_model.dart';
import 'package:flashcards/flip/providers/study_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Get current card being studied
final currentCardProvider = Provider<Flashcard?>((ref) {
  final study = ref.watch(studyProvider);
  return study.currentCard;
});

// Get progress text (e.g., "5 of 20")
final studyProgressProvider = Provider<String>((ref) {
  final study = ref.watch(studyProvider);
  return study.progressText;
});

// Get progress as percentage (0.0 to 1.0)
final studyProgressPercentageProvider = Provider<double>((ref) {
  final study = ref.watch(studyProvider);
  return study.progressPercentage;
});

// Get current accuracy percentage
final studyAccuracyProvider = Provider<double>((ref) {
  final study = ref.watch(studyProvider);
  return study.accuracy;
});

// Get average accuracy for a specific set
final averageAccuracyProvider = FutureProvider.family<double, int>((
  ref,
  setId,
) async {
  try {
    final sessions = await ref.watch(studySessionsProvider(setId).future);
    if (sessions.isEmpty) return 0;

    final totalAccuracy = sessions.fold<double>(
      0,
      (sum, session) => sum + session.accuracy,
    );
    return totalAccuracy / sessions.length;
  } catch (e) {
    print('Error calculating average accuracy: $e');
    return 0;
  }
});

// Get best score for a specific set
final bestScoreProvider = FutureProvider.family<double, int>((
  ref,
  setId,
) async {
  try {
    final sessions = await ref.watch(studySessionsProvider(setId).future);
    if (sessions.isEmpty) return 0;

    return sessions.map((s) => s.accuracy).reduce((a, b) => a > b ? a : b);
  } catch (e) {
    print('Error calculating best score: $e');
    return 0;
  }
});

// Check if a set has any study sessions
final hasStudySessionsProvider = FutureProvider.family<bool, int>((
  ref,
  setId,
) async {
  try {
    final sessions = await ref.watch(studySessionsProvider(setId).future);
    return sessions.isNotEmpty;
  } catch (e) {
    print('Error checking study sessions: $e');
    return false;
  }
});
