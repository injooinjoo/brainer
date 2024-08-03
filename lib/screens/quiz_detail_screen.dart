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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('카테고리: ${quiz.category}'),
            SizedBox(height: 8),
            Text('난이도: ${quiz.difficulty}'),
            SizedBox(height: 8),
            Text('문제 수: ${quiz.questions.length}'),
            SizedBox(height: 24),
            Text(
              '퀴즈 정보:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('이 퀴즈는 ${quiz.questions.length}개의 문제로 구성되어 있습니다.'),
            Text('난이도는 ${quiz.difficulty}입니다.'),
            Spacer(),
            Center(
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
      ),
    );
  }
}
