import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String userId;
  final String username;
  final int score;
  final String category;
  final Timestamp lastUpdated;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
    required this.category,
    required this.lastUpdated,
  });

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return LeaderboardEntry(
      userId: doc.id,
      username: data['username'] ?? '',
      score: data['score'] ?? 0,
      category: data['category'] ?? 'general',
      lastUpdated: data['lastUpdated'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'score': score,
      'category': category,
      'lastUpdated': lastUpdated,
    };
  }
}
