import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.questions,
  });

  // Firestore에서 데이터를 가져올 때 사용할 팩토리 메서드
  factory Quiz.fromMap(Map<String, dynamic> data, {String id = ''}) {
    return Quiz(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? '',
      questions: (data['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromMap(q))
              .toList() ??
          [],
    );
  }

  // JSON 데이터를 Quiz 객체로 변환할 때 사용할 팩토리 메서드
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }

  // Quiz 객체를 JSON 데이터로 변환할 때 사용할 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  // Quiz 객체를 수정할 때 사용할 메서드
  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? difficulty,
    List<Question>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      questions: questions ?? this.questions,
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation; // 추가된 필드: 정답에 대한 설명
  final String? imageUrl; // 추가된 필드: 질문에 포함될 이미지 URL

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.explanation, // 선택적 필드
    this.imageUrl, // 선택적 필드
  });

  // Firestore에서 데이터를 가져올 때 사용할 팩토리 메서드
  factory Question.fromMap(Map<String, dynamic> data) {
    return Question(
      text: data['text'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctOptionIndex: data['correctOptionIndex'] ?? 0,
      explanation: data['explanation'], // 선택적 필드 매핑
      imageUrl: data['imageUrl'], // 선택적 필드 매핑
    );
  }

  // JSON 데이터를 Question 객체로 변환할 때 사용할 팩토리 메서드
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correctOptionIndex'] ?? 0,
      explanation: json['explanation'], // 선택적 필드 매핑
      imageUrl: json['imageUrl'], // 선택적 필드 매핑
    );
  }

  // Question 객체를 JSON 데이터로 변환할 때 사용할 메서드
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation, // 선택적 필드 포함
      'imageUrl': imageUrl, // 선택적 필드 포함
    };
  }
}
