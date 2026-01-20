import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  final int currentIndex;
  final int totalCards;

  const ProgressSection({
    super.key,
    required this.currentIndex,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    double progressValue = (currentIndex + 1) / totalCards;
    double percentage = progressValue * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Card progress text
            Text(
              'Card ${currentIndex + 1} of $totalCards',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
                letterSpacing: 0.3,
              ),
            ),
            // Percentage text
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 5,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF3B82F6)),
          ),
        ),
      ],
    );
  }
}
