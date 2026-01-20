import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final int correct;
  final int wrong;
  final VoidCallback onTryAgain;

  const ResultsPage({
    Key? key,
    required this.correct,
    required this.wrong,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate percentage score
    double percentage = (correct / (correct + wrong) * 100);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quiz Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 40),

            // Score circle
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[50],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const Text(
                      'Score',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Breakdown box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _ResultRow(
                    label: 'Correct',
                    value: '$correct',
                    bgColor: Colors.green[600]!,
                  ),
                  const SizedBox(height: 12),
                  _ResultRow(
                    label: 'Wrong',
                    value: '$wrong',
                    bgColor: Colors.red[600]!,
                  ),
                  const SizedBox(height: 12),
                  // Total row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '${correct + wrong}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Try again button
            GestureDetector(
              onTap: onTryAgain,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Try Again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;

  const _ResultRow({
    Key? key,
    required this.label,
    required this.value,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
