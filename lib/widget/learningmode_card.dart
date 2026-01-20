import 'package:flutter/material.dart';
// LearningModeCard widget definition
class LearningModeCard extends StatefulWidget {
  final Map<String, dynamic> card;
  final VoidCallback onTap;

  const LearningModeCard({required this.card, required this.onTap});

  @override
  State<LearningModeCard> createState() => _LearningModeCardState();
}
// State class for LearningModeCard
class _LearningModeCardState extends State<LearningModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _isPressed = false;
// Initialize the animation controller
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }
// Dispose the animation controller
  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }
// Handle tap down event
  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
    setState(() => _isPressed = true);
  }
// Handle tap up event
  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
    setState(() => _isPressed = false);
    widget.onTap();
  }
// Handle tap cancel event
  void _onTapCancel() {
    _pressController.reverse();
    setState(() => _isPressed = false);
  }
// Build method to render the widget
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
            // Card content
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
