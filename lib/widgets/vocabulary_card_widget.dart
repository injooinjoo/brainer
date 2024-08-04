import 'package:flutter/material.dart';
import 'dart:math';

import '../models/vocabulary_card.dart';

class VocabularyCardWidget extends StatefulWidget {
  final VocabularyCard card;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  final bool isDarkMode;

  VocabularyCardWidget({
    required this.card,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.isDarkMode,
  });

  @override
  _VocabularyCardWidgetState createState() => _VocabularyCardWidgetState();
}

class _VocabularyCardWidgetState extends State<VocabularyCardWidget>
    with SingleTickerProviderStateMixin {
  bool _showFront = true;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  Offset _dragStart = Offset.zero;
  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);
  }

  void _flipCard() {
    setState(() {
      if (_showFront) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
      _showFront = !_showFront;
    });
  }

  void _onPanStart(DragStartDetails details) {
    _dragStart = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.globalPosition - _dragStart;
      _isDragging = true;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = _dragPosition;
    final dragDistance = dragVector.distance;
    final dragAngle = dragVector.direction;

    if (dragDistance > 100) {
      if (dragAngle.abs() < 1.57) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    } else {
      setState(() {
        _dragPosition = Offset.zero;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final appBarHeight = AppBar().preferredSize.height;
    final bottomNavBarHeight = kBottomNavigationBarHeight;
    final availableHeight =
        screenSize.height - appBarHeight - bottomNavBarHeight;

    final rotationY = _dragPosition.dx / 300;
    final scale = 1 - (_dragPosition.distance / 500).clamp(0.0, 0.5);

    return GestureDetector(
      onTap: _flipCard,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = (_flipAnimation.value * pi) + rotationY;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle)
              ..scale(scale),
            alignment: Alignment.center,
            child: Container(
              width: screenSize.width * 0.9,
              height: availableHeight * 0.9,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: widget.isDarkMode ? Colors.white : Colors.grey[800],
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: angle < pi / 2
                        ? _buildFrontSide()
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: _buildBackSide(),
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.card.word,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: widget.isDarkMode ? Colors.black : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          widget.card.pronunciation,
          style: TextStyle(
            fontSize: 24,
            color: widget.isDarkMode ? Colors.black54 : Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBackSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.card.meaning,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.isDarkMode ? Colors.black : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          widget.card.example,
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: widget.isDarkMode ? Colors.black87 : Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}
