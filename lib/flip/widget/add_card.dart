import 'package:flutter/material.dart';

class AddCardDialog extends StatefulWidget {
  final Function(String question, String answer) onAdd;

  const AddCardDialog({required this.onAdd});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Card'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                hintText: 'Enter the question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                hintText: 'Enter the answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_questionController.text.isNotEmpty &&
                _answerController.text.isNotEmpty) {
              _onAdd();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill in both fields')),
              );
            }
          },
          child: const Text('Add Card'),
        ),
      ],
    );
  }

  void _onAdd() {
    widget.onAdd(_questionController.text, _answerController.text);
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Card added!')));
  }
}
