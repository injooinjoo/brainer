import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addQuiz(Quiz quiz) async {
    await _db.collection('quizzes').add(quiz.toJson());
  }

  Future<void> addMultipleQuizzes(List<Quiz> quizzes) async {
    final batch = _db.batch();

    for (var quiz in quizzes) {
      final quizDoc = _db.collection('quizzes').doc();
      batch.set(quizDoc, quiz.toJson());
    }

    await batch.commit();
  }

  Future<List<Quiz>> fetchQuizzes() async {
    QuerySnapshot querySnapshot = await _db.collection('quizzes').get();
    return querySnapshot.docs.map((doc) {
      return Quiz.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
    }).toList();
  }
}
