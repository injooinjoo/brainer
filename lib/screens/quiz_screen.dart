// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../theme/app_theme.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Quiz? quiz;

  const QuizScreen({Key? key, this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<int?> userAnswers = [];
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();
    if (widget.quiz != null) {
      userAnswers = List.filled(widget.quiz!.questions.length, null);
    }
  }

  void answerQuestion(int answerIndex) {
    if (widget.quiz == null) return;
    setState(() {
      userAnswers[currentQuestionIndex] = answerIndex;
      if (currentQuestionIndex < widget.quiz!.questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void submitQuiz() {
    if (widget.quiz == null) return;

    stopwatch.stop(); // 퀴즈 풀이 종료 시간 기록

    int score = 0;
    for (int i = 0; i < widget.quiz!.questions.length; i++) {
      if (userAnswers[i] == widget.quiz!.questions[i].correctOptionIndex) {
        score++;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz!,
          userAnswers: userAnswers,
          score: score,
          duration: stopwatch.elapsed, // 측정된 시간 전달
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quiz == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: Text('No quiz available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz!.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.quiz!.questions.length}',
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              widget.quiz!.questions[currentQuestionIndex].text,
              style: AppTheme.headlineStyle,
            ),
            SizedBox(height: 24),
            ...widget.quiz!.questions[currentQuestionIndex].options
                .asMap()
                .entries
                .map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(entry.key),
                  child: Text(entry.value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        userAnswers[currentQuestionIndex] == entry.key
                            ? AppTheme.primaryColor
                            : Colors.white,
                    foregroundColor:
                        userAnswers[currentQuestionIndex] == entry.key
                            ? Colors.white
                            : AppTheme.textColor,
                  ),
                ),
              );
            }).toList(),
            if (currentQuestionIndex == widget.quiz!.questions.length - 1)
              ElevatedButton(
                onPressed: submitQuiz,
                child: Text('Submit Quiz'),
              ),
          ],
        ),
      ),
    );
  }
}
