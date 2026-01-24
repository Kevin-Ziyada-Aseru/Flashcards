import 'package:flashcards/auth/provider/auth_provider.dart';
import 'package:flashcards/flip/view/flipdeck_screen.dart';
import 'package:flashcards/match/view/matchcards_screen.dart';
import 'package:flashcards/multiple/view/multiple_ans_screen.dart';
import 'package:flashcards/widget/learningmode_card.dart';
import 'package:flashcards/widget/placeholder.dart';
import 'package:flashcards/widget/activities_section.dart';
import 'package:flashcards/write/view/write_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // List of learning mode cards
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

  final List<Map<String, dynamic>> _activities = [];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final token = ref.watch(authTokenProvider);
    final isLoading = ref.watch(authLoadingProvider);
    return Scaffold(
      appBar: _buildAppBar(),
      body: _getPage(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // App bar with title and subtitle
  PreferredSizeWidget _buildAppBar() {
    final user = ref.watch(currentUserProvider);

    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello, ${user?.name}!'),
          const Text(
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

  // Bottom navigation bar
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

  // Get page based on current index
  Widget _getPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const PlaceholderPage('Browse Decks', Icons.search_rounded);
      case 2:
        return const PlaceholderPage('Saved Decks', Icons.bookmark_rounded);
      case 3:
        return const PlaceholderPage('Profile', Icons.person_rounded);
      default:
        return _buildHomePage();
    }
  }

  // Home page with learning mode cards and activities section
  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Learning mode cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                return LearningModeCard(
                  card: _cards[index],
                  onTap: () => _navigateToScreen(_cards[index]['route']),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Activities section
          ActivitiesSection(activities: _activities),
        ],
      ),
    );
  }

  // Navigation to different learning mode screens
  void _navigateToScreen(String route) {
    switch (route) {
      case 'flip':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FlipDecksScreen()),
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
        break;
      case 'write':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WriteReviewScreen()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FlipDecksScreen()),
        );
    }
  }
}
