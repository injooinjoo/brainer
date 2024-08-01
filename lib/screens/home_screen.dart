// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../screens/quiz_screen.dart';
import '../screens/goal_setting_screen.dart';
import '../screens/goal_detail_screen.dart';
import '../models/goal.dart';
import '../providers/quiz_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: true).fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BRAINER'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back!', style: AppTheme.headlineStyle),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for quizzes',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              Text('Your Goals',
                  style:
                      AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
              Expanded(
                child: goals.isEmpty
                    ? Center(child: Text('No goals set. Add a new goal!'))
                    : ListView.builder(
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(goals[index].title),
                            subtitle: Text(
                                goals[index].dueDate.toString().split(' ')[0]),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () async {
                              final result = await Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GoalDetailScreen(goal: goals[index]),
                                ),
                              );
                              if (result is Goal) {
                                setState(() {
                                  goals[index] = result;
                                });
                              } else if (result == true) {
                                setState(() {
                                  goals.removeAt(index);
                                });
                              }
                            },
                          );
                        },
                      ),
              ),
              Consumer<QuizProvider>(
                builder: (context, quizProvider, child) {
                  return ElevatedButton(
                    onPressed: quizProvider.quizzes.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                    quiz: quizProvider.quizzes.isNotEmpty
                                        ? quizProvider.quizzes[0]
                                        : null),
                              ),
                            );
                          }
                        : null,
                    child: Text('Start a New Quiz'),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final newGoal = await Navigator.push<Goal>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoalSettingScreen()),
                  );
                  if (newGoal != null) {
                    setState(() {
                      goals.add(newGoal);
                    });
                  }
                },
                child: Text('Set a New Goal'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: Navigate to QuizRegistrationScreen
        },
      ),
    );
  }
}
