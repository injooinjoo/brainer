// lib/models/quiz.dart

class Quiz {
  String id;
  String title;
  List<Question> questions;
  String category;
  String difficulty;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.category,
    required this.difficulty,
  });

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
