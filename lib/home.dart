import 'dart:math';
import 'package:flashcards/flip/view/flip_card.dart';
import 'package:flashcards/match/view/matchcards_screen.dart';
import 'package:flashcards/multiple/view/multiple_ans_screen.dart';
import 'package:flashcards/write/view/write_review.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _cards = [
    {
      'icon': Icons.flip,
      'title': 'Flip Cards',
      'desc': 'Classic card flipping to test memory',
      'color': Colors.blueGrey[700],
      'route': 'flip',
    },
    {
      'icon': Icons.grid_3x3,
      'title': 'Match Cards',
      'desc': 'Connect questions with answers',
      'color': Colors.teal[600],
      'route': 'match',
    },
    {
      'icon': Icons.check_circle_outline,
      'title': 'Multiple Choice',
      'desc': 'Select the correct answer',
      'color': Colors.orange[600],
      'route': 'multiple',
    },
    {
      'icon': Icons.edit_note,
      'title': 'Write & Review',
      'desc': 'Type answers and get feedback',
      'color': Colors.red[600],
      'route': 'write',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _getPage(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learn Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Pick a learning method',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 1,
      selectedItemColor: Colors.blueGrey[700],
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Learn'),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_rounded),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _getPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const _PlaceholderPage('Browse Decks', Icons.search_rounded);
      case 2:
        return const _PlaceholderPage('Saved Decks', Icons.bookmark_rounded);
      case 3:
        return const _PlaceholderPage('Profile', Icons.person_rounded);
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          return _LearningModeCard(
            card: _cards[index],
            onTap: () => _navigateToScreen(_cards[index]['route']),
          );
        },
      ),
    );
  }

  void _navigateToScreen(String route) {
    switch (route) {
      case 'flip':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FlashcardsScreen()),
        );
        break;
      case 'match':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatchCardsScreen()),
        );
        break;
      case 'multiple':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MultipleAnsScreen()),
        );
      case 'write':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WriteReviewScreen()),
        );
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatchCardsScreen()),
        );
    }
  }
}

class _LearningModeCard extends StatefulWidget {
  final Map<String, dynamic> card;
  final VoidCallback onTap;

  const _LearningModeCard({required this.card, required this.onTap});

  @override
  State<_LearningModeCard> createState() => _LearningModeCardState();
}

class _LearningModeCardState extends State<_LearningModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onTapCancel() {
    _pressController.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: widget.card['color'],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                widget.card['icon'],
                size: 160,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.card['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.card['desc'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.card['icon'],
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coming soon',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// ============== FLASHCARDS SCREEN ==============
