import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String name;
  String email;
  String? photoUrl;
  int quizzesTaken;
  double averageScore;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.quizzesTaken = 0,
    this.averageScore = 0.0,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'quizzesTaken': quizzesTaken,
      'averageScore': averageScore,
    };
  }

  void updateStats(int newScore) {
    quizzesTaken++;
    averageScore =
        ((averageScore * (quizzesTaken - 1)) + newScore) / quizzesTaken;
  }
}
