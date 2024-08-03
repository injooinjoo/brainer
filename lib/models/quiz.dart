// lib/models/quiz.dart

class Quiz {
  String id; // final 제거
  final String title;
  final List<Question> questions;
  final String category;
  final String difficulty;
  final String? description;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.category,
    required this.difficulty,
    this.description,
  });

  // copyWith 메서드 추가
  Quiz copyWith({
    String? id,
    String? title,
    List<Question>? questions,
    String? category,
    String? difficulty,
    String? description,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
    );
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      questions: (map['questions'] as List? ?? [])
          .map((q) => Question.fromMap(q as Map<String, dynamic>))
          .toList(),
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
      'category': category,
      'difficulty': difficulty,
    };
  }
}

class Question {
  String id;
  String text;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }

  factory Question.empty() {
    return Question(
      id: '',
      text: '',
      options: [],
      correctOptionIndex: -1,
    );
  }
}
