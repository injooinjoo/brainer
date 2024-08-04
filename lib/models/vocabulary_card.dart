// models/vocabulary_card.dart
class VocabularyCard {
  final String word;
  final String pronunciation;
  final String meaning;
  final String audioUrl;
  final String example;

  VocabularyCard({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.audioUrl,
    required this.example,
  });
}

final List<VocabularyCard> sampleVocabularyCards = [
  VocabularyCard(
    word: "Aberration",
    pronunciation: "/ˌæbəˈreɪʃən/",
    meaning: "변칙, 일탈",
    example: "The scientist noticed an aberration in the test results.",
    audioUrl: "https://example.com/audio/aberration.mp3",
  ),
  VocabularyCard(
    word: "Benevolent",
    pronunciation: "/bəˈnevələnt/",
    meaning: "자비로운, 인자한",
    example: "The benevolent king was loved by all his subjects.",
    audioUrl: "https://example.com/audio/benevolent.mp3",
  ),
  VocabularyCard(
    word: "Cacophony",
    pronunciation: "/kəˈkɒfəni/",
    meaning: "불협화음, 막무가내의 소리",
    example: "The cacophony of the city traffic was overwhelming.",
    audioUrl: "https://example.com/audio/cacophony.mp3",
  ),
  // ... 97개의 추가 단어 (실제 구현 시 100개까지 확장)
];
