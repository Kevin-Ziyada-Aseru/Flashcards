import 'dart:math';
import 'package:flutter/material.dart';

class FlipCardWidget extends StatelessWidget {
  final String question;
  final String answer;
  final bool showAnswer;
  final double angle;
  final VoidCallback onTap;

  const FlipCardWidget({
    Key? key,
    required this.question,
    required this.answer,
    required this.showAnswer,
    required this.angle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate rotation angle
    final rotationAngle = angle * pi;

    // Determine which side to show (flip happens at midpoint)
    final bool shouldShowAnswer = angle > 0.5;

    // Calculate opacity to hide text during flip
    final double textOpacity = (angle < 0.5)
        ? (1 - (angle * 2))
        : ((angle - 0.5) * 2);

    final cardTransform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(rotationAngle);

    return GestureDetector(
      onTap: onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: cardTransform,
        child: Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            color: shouldShowAnswer ? Colors.teal[600] : Colors.blueGrey[700],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Opacity(
                opacity: textOpacity.clamp(0.0, 1.0),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(shouldShowAnswer ? pi : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        shouldShowAnswer ? 'ANSWER' : 'QUESTION',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        shouldShowAnswer ? answer : question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
