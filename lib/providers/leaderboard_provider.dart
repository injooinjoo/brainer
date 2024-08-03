// provider/leaderboard_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LeaderboardEntry> _entries = [];
  String _currentCategory = 'General';
  bool _isLoading = false;
  String? _error;

  List<LeaderboardEntry> get entries => _entries;
  String get currentCategory => _currentCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateCategory(String newCategory) {
    _currentCategory = newCategory;
    fetchLeaderboard(category: newCategory);
  }

  Future<void> fetchLeaderboard({String category = 'General'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('leaderboard')
          .where('category', isEqualTo: category.toLowerCase())
          .orderBy('score', descending: true)
          .limit(100)
          .get();

      _entries = querySnapshot.docs
          .map((doc) => LeaderboardEntry.fromFirestore(doc))
          .toList();
      _currentCategory = category;
    } catch (e) {
      _error = 'Error fetching leaderboard: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserScore(
      String userId, int newScore, String category) async {
    try {
      await _firestore.collection('leaderboard').doc(userId).set({
        'score': newScore,
        'category': category.toLowerCase(),
        'lastUpdated': Timestamp.now(),
      }, SetOptions(merge: true));
      await fetchLeaderboard(category: category);
    } catch (e) {
      print('Error updating user score: $e');
    }
  }
}
