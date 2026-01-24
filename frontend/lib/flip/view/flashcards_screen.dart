import 'package:flashcards/flip/model/flashcard_model.dart';
import 'package:flashcards/flip/providers/flashcard_provider.dart';
import 'package:flashcards/flip/providers/study_notifier.dart';
import 'package:flashcards/flip/view/study_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcards/flip/view/empty_state.dart';
import 'package:flashcards/flip/view/results_page.dart';
import 'package:flashcards/flip/widget/card_dialog.dart';
import 'package:flashcards/flip/widget/flipcard_widget.dart';
import 'package:flashcards/flip/widget/progress_section.dart';
import 'package:flashcards/widget/btn_icon.dart';
import 'package:flashcards/widget/btn_widget.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  final int setId;
  final String setName;

  const FlashcardsScreen({Key? key, required this.setId, required this.setName})
    : super(key: key);

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Initialize study session when screen loads
    Future.microtask(() {
      ref.read(initializeStudyProvider(widget.setId));
    });
  }

  void _addNewCard() {
    showDialog(
      context: context,
      builder: (context) => AddCardDialog(
        onAdd: (question, answer) {
          // Add card to backend
          ref.read(createCardProvider((widget.setId, question, answer)));
        },
      ),
    );
  }

  void _deleteCurrentCard() {
    final study = ref.read(studyProvider);
    final currentCard = study.currentCard;

    if (currentCard != null) {
      ref.read(deleteCardProvider(currentCard.id));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Card deleted')));
    }
  }

  void _clearAllCards() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cards?'),
        content: const Text(
          'This will delete all cards in this deck. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final study = ref.read(studyProvider);
              // Delete all cards
              for (final card in study.cards) {
                ref.read(deleteCardProvider(card.id));
              }
              ref.read(studyProvider.notifier).reset();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All cards cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _markCorrect() {
    ref.read(studyProvider.notifier).markCorrect();
  }

  void _markWrong() {
    ref.read(studyProvider.notifier).markWrong();
  }

  void _restartQuiz() {
    ref.read(studyProvider.notifier).restart();
  }

  void _saveAndExit() async {
    final study = ref.read(studyProvider);
    if (study.correctCount + study.wrongCount > 0) {
      // Save session to backend
      await ref.read(saveStudySessionProvider(widget.setId).future);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void toggleFlip() {
    if (isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => isFlipped = !isFlipped);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardsBySetProvider(widget.setId));
    final study = ref.watch(studyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.setName),
        elevation: 0.5,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: cardsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(cardsBySetProvider(widget.setId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (cards) {
          if (cards.isEmpty) {
            return EmptyState(onAddCard: _addNewCard);
          }

          // If study is completed, show results
          if (study.isCompleted) {
            return ResultsPage(
              correct: study.correctCount,
              wrong: study.wrongCount,
              onTryAgain: _restartQuiz,
            );
          }

          // If no cards loaded in study, initialize them
          if (study.cards.isEmpty) {
            Future.microtask(() {
              ref.read(studyProvider.notifier).loadCards(cards);
            });
            return const Center(child: CircularProgressIndicator());
          }

          final currentCard = study.currentCard;
          if (currentCard == null) {
            return const Center(child: Text('No card to display'));
          }

          return _buildFlipCardView(study, currentCard);
        },
      ),
    );
  }

  Widget _buildFlipCardView(StudyState study, Flashcard currentCard) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Section
            ProgressSection(
              currentIndex: study.currentCardIndex,
              totalCards: study.cards.length,
            ),

            const SizedBox(height: 32),

            // Flip card widget
            FlipCardWidget(
              question: currentCard.question,
              answer: currentCard.answer,
              showAnswer: isFlipped,
              angle: _flipController.value,
              onTap: toggleFlip,
            ),

            const SizedBox(height: 16),

            Text(
              'Tap card to flip',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 48),

            // Mark Wrong and Correct buttons
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: BtnIcon(
                      onTap: _markWrong,
                      color: Colors.red[600]!,
                      icon: Icons.close,
                      label: 'Wrong',
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BtnIcon(
                      onTap: _markCorrect,
                      color: Colors.green[600]!,
                      icon: Icons.check,
                      label: 'Correct',
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Add and Delete card buttons
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: BtnWidget(
                      onTap: _addNewCard,
                      label: "+ Add Card",
                      bgColor: Colors.blue[600]!,
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BtnWidget(
                      onTap: _deleteCurrentCard,
                      label: 'Delete',
                      bgColor: Colors.grey[400]!,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Clear all cards button
            SizedBox(
              width: double.infinity,
              child: BtnWidget(
                onTap: _clearAllCards,
                label: 'Clear All Cards',
                bgColor: Colors.grey[300]!,
                textColor: const Color(0xFF374151),
              ),
            ),

            const SizedBox(height: 16),

            // Save and Exit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveAndExit,
                icon: const Icon(Icons.check),
                label: const Text('Save & Exit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3A5F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
