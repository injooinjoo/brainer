// lib/models/user.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String name;
  String email;
  String? photoUrl;
  int quizzesTaken;
  double averageScore;
  String displayName; // 추가된 필드

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.quizzesTaken = 0,
    this.averageScore = 0.0,
    required this.displayName, // 생성자에 추가
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      quizzesTaken: data['quizzesTaken'] ?? 0,
      averageScore: (data['averageScore'] ?? 0.0).toDouble(),
      displayName: data['displayName'] ?? '', // Firestore에서 읽기
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'quizzesTaken': quizzesTaken,
      'averageScore': averageScore,
      'displayName': displayName, // Firestore에 저장
    };
  }

  void updateStats(int newScore) {
    quizzesTaken++;
    averageScore =
        ((averageScore * (quizzesTaken - 1)) + newScore) / quizzesTaken;
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? quizzesTaken,
    double? averageScore,
    String? displayName, // copyWith 메서드에 추가
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      averageScore: averageScore ?? this.averageScore,
      displayName: displayName ?? this.displayName, // copyWith에서 사용
    );
  }
}
