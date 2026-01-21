import 'package:flutter/material.dart';

// MultipleAnsScreen widget definition
class MultipleAnsScreen extends StatelessWidget {
  const MultipleAnsScreen({super.key});
  // Build method to render the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar configuration
      appBar: AppBar(
        title: const Text('Multiple Choice'),
        elevation: 0.5,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      // Body content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.grid_3x3_rounded,
                size: 72,
                color: Colors.orange[600],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Multiple Choice',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
