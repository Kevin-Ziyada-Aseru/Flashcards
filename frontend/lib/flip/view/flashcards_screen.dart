import 'dart:math';
import 'package:flashcards/flip/model/card_results.dart';
import 'package:flashcards/flip/model/flashcard_model.dart';
import 'package:flashcards/flip/view/empty_state.dart';
import 'package:flashcards/flip/view/results_page.dart';
import 'package:flashcards/flip/widget/card_dialog.dart';
import 'package:flashcards/flip/widget/flipcard_widget.dart';
import 'package:flashcards/flip/widget/progress_section.dart';
import 'package:flashcards/widget/btn_icon.dart';
import 'package:flashcards/widget/btn_widget.dart';
import 'package:flutter/material.dart';

class FlashcardsScreen extends StatefulWidget {
  final List<Map<String, String>>? initialCards;

  const FlashcardsScreen({Key? key, this.initialCards}) : super(key: key);

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with TickerProviderStateMixin {
  late List<Flashcard> flashcards;
  int currentIndex = 0;
  bool isFlipped = false;
  late AnimationController _flipController;
  List<CardResult> results = [];
  bool showingResults = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    flashcards =
        (widget.initialCards ??
                [
                  {'q': 'What is the capital of France?', 'a': 'Paris'},
                  {'q': 'What is 2 + 2?', 'a': '4'},
                  {'q': 'What is the largest planet?', 'a': 'Jupiter'},
                  {
                    'q': 'Who wrote Romeo and Juliet?',
                    'a': 'William Shakespeare',
                  },
                ])
            .map((map) => Flashcard.fromMap(map))
            .toList();
  }

  void _addNewCard() {
    showDialog(
      context: context,
      builder: (context) => AddCardDialog(
        onAdd: (question, answer) {
          setState(() {
            flashcards.add(Flashcard(question: question, answer: answer));
          });
        },
      ),
    );
  }

  void _deleteCurrentCard() {
    if (flashcards.isNotEmpty) {
      setState(() {
        flashcards.removeAt(currentIndex);
        if (currentIndex >= flashcards.length && currentIndex > 0) {
          currentIndex--;
        }
        isFlipped = false;
        _flipController.reset();
      });
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
              setState(() {
                flashcards.clear();
                currentIndex = 0;
                isFlipped = false;
                _flipController.reset();
                results.clear();
                showingResults = false;
              });
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
    results.add(CardResult(index: currentIndex, correct: true));

    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        isFlipped = false;
        _flipController.reset();
      });
    } else {
      setState(() {
        showingResults = true;
      });
    }
  }

  void _markWrong() {
    results.add(CardResult(index: currentIndex, correct: false));

    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        isFlipped = false;
        _flipController.reset();
      });
    } else {
      setState(() {
        showingResults = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      currentIndex = 0;
      isFlipped = false;
      _flipController.reset();
      results.clear();
      showingResults = false;
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flip Cards'),
          elevation: 0.5,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: EmptyState(onAddCard: _addNewCard),
      );
    }

    var card = flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Cards'),
        elevation: 0.5,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: showingResults
          ? ResultsPage(
              correct: results.where((r) => r.correct).length,
              wrong: results.where((r) => !r.correct).length,
              onTryAgain: _restartQuiz,
            )
          : _buildFlipCardView(),
    );
  }

  Widget _buildFlipCardView() {
    var card = flashcards[currentIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Section
            ProgressSection(
              currentIndex: currentIndex,
              totalCards: flashcards.length,
            ),

            const SizedBox(height: 32),

            // Flip card widget
            FlipCardWidget(
              question: card.question,
              answer: card.answer,
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
          ],
        ),
      ),
    );
  }
}
