// providers/vocabulary_provider.dart
import 'package:flutter/foundation.dart';
import '../models/vocabulary_card.dart';

class VocabularyProvider with ChangeNotifier {
  List<VocabularyCard> _cards = [];
  List<VocabularyCard> _unknownCards = [];

  List<VocabularyCard> get cards => _cards;
  List<VocabularyCard> get unknownCards => _unknownCards;

  void addCard(VocabularyCard card) {
    _cards.add(card);
    notifyListeners();
  }

  void markAsKnown(VocabularyCard card) {
    _cards.remove(card);
    notifyListeners();
  }

  void markAsUnknown(VocabularyCard card) {
    _unknownCards.add(card);
    _cards.remove(card);
    notifyListeners();
  }

  void resetUnknownCards() {
    _cards.addAll(_unknownCards);
    _unknownCards.clear();
    notifyListeners();
  }
}
