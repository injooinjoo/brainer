// lib/providers/exam_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exam.dart';

class ExamProvider with ChangeNotifier {
  List<Exam> _exams = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Exam> get exams => _exams;

  Future<void> fetchExams() async {
    try {
      final snapshot = await _firestore.collection('exams').get();
      _exams = snapshot.docs.map((doc) => Exam.fromJson(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching exams: $e');
    }
  }

  Future<void> addExam(Exam exam) async {
    try {
      final docRef = await _firestore.collection('exams').add(exam.toJson());
      final newExam =
          Exam(id: docRef.id, name: exam.name, description: exam.description);
      _exams.add(newExam);
      notifyListeners();
    } catch (e) {
      print('Error adding exam: $e');
    }
  }

  Future<void> updateExam(Exam exam) async {
    try {
      await _firestore.collection('exams').doc(exam.id).update(exam.toJson());
      final index = _exams.indexWhere((e) => e.id == exam.id);
      if (index != -1) {
        _exams[index] = exam;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating exam: $e');
    }
  }

  Future<void> deleteExam(String examId) async {
    try {
      await _firestore.collection('exams').doc(examId).delete();
      _exams.removeWhere((exam) => exam.id == examId);
      notifyListeners();
    } catch (e) {
      print('Error deleting exam: $e');
    }
  }
}
