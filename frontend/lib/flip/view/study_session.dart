import 'package:flashcards/flip/model/flashcard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Study session state - tracks current quiz progress
class StudyState {
  final int currentCardIndex;
  final int correctCount;
  final int wrongCount;
  final List<Flashcard> cards;
  final bool isCompleted;

  StudyState({
    this.currentCardIndex = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.cards = const [],
    this.isCompleted = false,
  });

  // Calculate accuracy percentage
  double get accuracy {
    final total = correctCount + wrongCount;
    if (total == 0) return 0;
    return (correctCount / total) * 100;
  }

  // Get current card being studied
  Flashcard? get currentCard {
    if (cards.isEmpty || currentCardIndex >= cards.length) {
      return null;
    }
    return cards[currentCardIndex];
  }

  // Get progress string
  String get progressText {
    return '${currentCardIndex + 1} of ${cards.length}';
  }

  // Get progress as percentage
  double get progressPercentage {
    if (cards.isEmpty) return 0;
    return (currentCardIndex + 1) / cards.length;
  }

  // Create a copy with modified fields
  StudyState copyWith({
    int? currentCardIndex,
    int? correctCount,
    int? wrongCount,
    List<Flashcard>? cards,
    bool? isCompleted,
  }) {
    return StudyState(
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      cards: cards ?? this.cards,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Manages the study session state and logic
class StudyNotifier extends StateNotifier<StudyState> {
  final Ref ref;

  StudyNotifier(this.ref) : super(StudyState(cards: []));

  Future<void> initializeStudy(int setId) async {
    try {
      state = state.copyWith(cards: const [], currentCardIndex: 0);
    } catch (e) {
      print('Error initializing study: $e');
      rethrow;
    }
  }

  // Mark current card as correct and advance to next card
  void markCorrect() {
    if (state.currentCardIndex < state.cards.length - 1) {
      state = state.copyWith(
        correctCount: state.correctCount + 1,
        currentCardIndex: state.currentCardIndex + 1,
      );
    } else {
      // Last card - quiz complete
      state = state.copyWith(
        correctCount: state.correctCount + 1,
        isCompleted: true,
      );
    }
  }

  // Mark current card as wrong and advance to next card
  void markWrong() {
    if (state.currentCardIndex < state.cards.length - 1) {
      state = state.copyWith(
        wrongCount: state.wrongCount + 1,
        currentCardIndex: state.currentCardIndex + 1,
      );
    } else {
      // Last card - quiz complete
      state = state.copyWith(
        wrongCount: state.wrongCount + 1,
        isCompleted: true,
      );
    }
  }

  // Save study session to backend
  // void saveSessionData(int setId) {
  //   // This will be called from providers.dart
  //   // Provider handles the actual API call
  // }

  // Restart quiz from beginning with same cards
  void restart() {
    state = state.copyWith(
      currentCardIndex: 0,
      correctCount: 0,
      wrongCount: 0,
      isCompleted: false,
    );
  }

  // Reset study completely (clears all state)
  void reset() {
    state = StudyState();
  }

  // Load cards into study state
  void loadCards(List<Flashcard> cards) {
    state = state.copyWith(cards: cards, currentCardIndex: 0);
  }
}
