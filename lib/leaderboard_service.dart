import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LeaderboardEntry>> getLeaderboard(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('leaderboard')
          .where('category', isEqualTo: category)
          .orderBy('score', descending: true)
          .limit(100)
          .get();

      return querySnapshot.docs
          .map((doc) => LeaderboardEntry.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  Future<void> updateUserScore(
      String userId, int newScore, String category) async {
    try {
      await _firestore.collection('leaderboard').doc(userId).set({
        'score': newScore,
        'category': category,
        'lastUpdated': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user score: $e');
    }
  }
}
