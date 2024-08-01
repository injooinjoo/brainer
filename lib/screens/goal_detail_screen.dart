// lib/screens/goal_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../theme/app_theme.dart';
import 'goal_setting_screen.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailScreen({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late Goal _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedGoal = await Navigator.push<Goal>(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalSettingScreen(goal: _goal),
                ),
              );
              if (updatedGoal != null) {
                setState(() {
                  _goal = updatedGoal;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Goal'),
                  content: Text('Are you sure you want to delete this goal?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('Delete'),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context,
                            true); // Return to HomeScreen with delete flag
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_goal.title, style: AppTheme.headlineStyle),
            SizedBox(height: 16),
            Text('Description:',
                style:
                    AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Text(_goal.description, style: AppTheme.bodyStyle),
            SizedBox(height: 16),
            Text('Due Date:',
                style:
                    AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Text(_goal.dueDate.toString().split(' ')[0],
                style: AppTheme.bodyStyle),
            SizedBox(height: 16),
            Text('Status:',
                style:
                    AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Text(_goal.isCompleted ? 'Completed' : 'In Progress',
                style: AppTheme.bodyStyle.copyWith(
                    color: _goal.isCompleted ? Colors.green : Colors.orange)),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text(_goal.isCompleted
                  ? 'Mark as Incomplete'
                  : 'Mark as Complete'),
              onPressed: () {
                setState(() {
                  _goal.isCompleted = !_goal.isCompleted;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
