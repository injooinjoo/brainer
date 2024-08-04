// lib/providers/goal_provider.dart

import 'package:flutter/foundation.dart';
import '../models/goal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Goal> get goals => _goals;

  Future<void> fetchGoals(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .get();
      _goals = snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching goals: $e');
    }
  }

  Future<void> addGoal(Goal goal, String userId) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .add(goal.toJson());
      goal.id = docRef.id;
      _goals.add(goal);
      notifyListeners();
    } catch (e) {
      print('Error adding goal: $e');
    }
  }

  Future<void> removeGoal(Goal goal, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(goal.id)
          .delete();
      _goals.remove(goal);
      notifyListeners();
    } catch (e) {
      print('Error removing goal: $e');
    }
  }

  Future<void> updateGoal(Goal oldGoal, Goal newGoal, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('goals')
          .doc(newGoal.id)
          .update(newGoal.toJson());
      final index = _goals.indexOf(oldGoal);
      if (index != -1) {
        _goals[index] = newGoal;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating goal: $e');
    }
  }
}
