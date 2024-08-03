// provider/quiz_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';
import 'package:flutter/foundation.dart';

class QuizProvider with ChangeNotifier {
  List<Quiz> _quizzes = [];

  List<Quiz> get quizzes => _quizzes;
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  List<Quiz> get filteredQuizzes {
    return _quizzes.where((quiz) {
      bool categoryMatch =
          _selectedCategory == 'All' || quiz.category == _selectedCategory;
      bool difficultyMatch = _selectedDifficulty == 'All' ||
          quiz.difficulty == _selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  Future<void> fetchQuizzes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('quizzes').get();

      _quizzes = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Quiz.fromMap(data).copyWith(id: doc.id);
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching quizzes: $e');
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('quizzes')
          .add(quiz.toJson());

      Quiz updatedQuiz = quiz.copyWith(id: docRef.id);

      _quizzes.add(updatedQuiz);

      notifyListeners();
    } catch (e) {
      print('Error adding quiz: $e');
    }
  }

  Future<void> saveQuizResult(
      String quizId, int score, Duration duration, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('quiz_results').add({
        'quizId': quizId,
        'userId': userId,
        'score': score,
        'duration': duration.inSeconds,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }

  Future<Map<String, dynamic>> getQuizStatistics(
      String quizId, String userId) async {
    try {
      QuerySnapshot resultSnapshot = await FirebaseFirestore.instance
          .collection('quiz_results')
          .where('quizId', isEqualTo: quizId)
          .where('userId', isEqualTo: userId)
          .orderBy('score', descending: true)
          .limit(1)
          .get();

      if (resultSnapshot.docs.isNotEmpty) {
        return {
          'highScore': resultSnapshot.docs.first['score'],
          'fastestTime': resultSnapshot.docs.first['duration'],
        };
      }
      return {'highScore': 0, 'fastestTime': 0};
    } catch (e) {
      print('Error getting quiz statistics: $e');
      return {'highScore': 0, 'fastestTime': 0};
    }
  }
}
