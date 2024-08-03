import 'package:flutter/foundation.dart';
import '../models/goal.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void removeGoal(Goal goal) {
    _goals.remove(goal);
    notifyListeners();
  }

  void updateGoal(Goal oldGoal, Goal newGoal) {
    final index = _goals.indexOf(oldGoal);
    if (index != -1) {
      _goals[index] = newGoal;
      notifyListeners();
    }
  }
}
