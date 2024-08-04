import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/vocabulary_card.dart';
import '../widgets/vocabulary_card_widget.dart';

class VocabularyScreen extends StatefulWidget {
  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<VocabularyCard> _cards = List.from(sampleVocabularyCards);
  List<VocabularyCard> _unknownCards = [];
  bool _isMuted = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _markAsKnown(VocabularyCard card) {
    setState(() {
      _cards.remove(card);
    });
  }

  void _markAsUnknown(VocabularyCard card) {
    setState(() {
      _unknownCards.add(card);
      _cards.remove(card);
    });
  }

  void _resetCards() {
    setState(() {
      _cards.addAll(_unknownCards);
      _unknownCards.clear();
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _audioPlayer.stop();
      } else {
        _playAudio();
      }
    });
  }

  void _playAudio() {
    if (!_isMuted && _cards.isNotEmpty) {
      _audioPlayer.play(UrlSource(_cards.first.audioUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary Learning'),
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            onPressed: _toggleMute,
          ),
        ],
      ),
      body: _cards.isEmpty
          ? Center(
              child: ElevatedButton(
                child: Text('Reset Cards'),
                onPressed: _resetCards,
              ),
            )
          : Dismissible(
              key: ValueKey(_cards.first),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _markAsUnknown(_cards.first);
                } else {
                  _markAsKnown(_cards.first);
                }
                _playAudio();
              },
              background: Container(
                color: Colors.green,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              child: VocabularyCardWidget(
                card: _cards.first,
                onSwipeRight: () {
                  _markAsKnown(_cards.first);
                  _playAudio();
                },
                onSwipeLeft: () {
                  _markAsUnknown(_cards.first);
                  _playAudio();
                },
                isDarkMode: isDarkMode,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
