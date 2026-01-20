import 'package:flashcards/flip/view/flashcards_screen.dart';
import 'package:flutter/material.dart';

class FlipDecksScreen extends StatefulWidget {
  const FlipDecksScreen({Key? key}) : super(key: key);

  @override
  State<FlipDecksScreen> createState() => _FlipDecksScreenState();
}

class _FlipDecksScreenState extends State<FlipDecksScreen> {
  late List<Map<String, dynamic>> decks;

  @override
  void initState() {
    super.initState();
    decks = [
      {
        'name': 'Default',
        'id': 'default',
        'cards': [
          {'q': 'What is the capital of France?', 'a': 'Paris'},
          {'q': 'What is 2 + 2?', 'a': '8'},
          {'q': 'What is the largest planet?', 'a': 'Jupiter'},
          {'q': 'Who wrote Romeo and Juliet?', 'a': 'William Shakespeare'},
        ],
      },
    ];
  }

  void _createNewDeck() {
    showDialog(
      context: context,
      builder: (context) => _CreateDeckDialog(
        onAdd: (deckName) {
          setState(() {
            decks.add({
              'name': deckName,
              'id': DateTime.now().toString(),
              'cards': [],
            });
          });
        },
      ),
    );
  }

  void _openDeck(Map<String, dynamic> deck) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardsScreen(
          initialCards: List<Map<String, String>>.from(deck['cards']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Cards'),
        elevation: 0.5,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Decks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: decks.length + 1,
                itemBuilder: (context, index) {
                  if (index == decks.length) {
                    return _buildCreateNewButton();
                  }
                  return _buildDeckCard(decks[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckCard(Map<String, dynamic> deck) {
    return GestureDetector(
      onTap: () => _openDeck(deck),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deck['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${deck['cards'].length} cards',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewButton() {
    return GestureDetector(
      onTap: _createNewDeck,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Create New Deck',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateDeckDialog extends StatefulWidget {
  final Function(String deckName) onAdd;

  const _CreateDeckDialog({required this.onAdd});

  @override
  State<_CreateDeckDialog> createState() => _CreateDeckDialogState();
}

class _CreateDeckDialogState extends State<_CreateDeckDialog> {
  late TextEditingController _deckNameController;

  @override
  void initState() {
    super.initState();
    _deckNameController = TextEditingController();
  }

  @override
  void dispose() {
    _deckNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Deck'),
      content: TextField(
        controller: _deckNameController,
        decoration: const InputDecoration(
          labelText: 'Deck Name',
          hintText: 'Enter deck name',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_deckNameController.text.isNotEmpty) {
              widget.onAdd(_deckNameController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Deck created!')));
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
