// lib/screens/quiz_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz.dart';
import 'quiz_solving_screen.dart';

class QuizDetailScreen extends StatelessWidget {
  final Quiz quiz;

  QuizDetailScreen({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                Question question = quiz.questions[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '질문 ${index + 1}: ${question.text}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ...question.options.asMap().entries.map((entry) {
                          int optionIndex = entry.key;
                          String option = entry.value;
                          return Text(
                            '${optionIndex + 1}. $option ${optionIndex == question.correctOptionIndex ? '(정답)' : ''}',
                            style: TextStyle(
                              color: optionIndex == question.correctOptionIndex
                                  ? Colors.green
                                  : null,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              child: Text('퀴즈 풀기'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizSolvingScreen(quiz: quiz),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
