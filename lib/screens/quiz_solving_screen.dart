// lib/screens/quiz_solving_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz.dart';
import 'quiz_result_screen.dart';

class QuizSolvingScreen extends StatefulWidget {
  final Quiz quiz;

  QuizSolvingScreen({required this.quiz});

  @override
  _QuizSolvingScreenState createState() => _QuizSolvingScreenState();
}

class _QuizSolvingScreenState extends State<QuizSolvingScreen> {
  int currentQuestionIndex = 0;
  late List<int?> userAnswers;
  late Stopwatch stopwatch;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    userAnswers = List.filled(widget.quiz.questions.length, null);
    stopwatch = Stopwatch()..start();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // 화면 갱신을 위해 빈 setState 호출
    });
  }

  @override
  void dispose() {
    stopwatch.stop();
    timer.cancel();
    super.dispose();
  }

  void _answerQuestion(int answerIndex) {
    setState(() {
      userAnswers[currentQuestionIndex] = answerIndex;
      if (currentQuestionIndex < widget.quiz.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    stopwatch.stop();
    timer.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          userAnswers: userAnswers,
          score: _calculateScore(),
          duration: stopwatch.elapsed,
        ),
      ),
    );
  }

  int _calculateScore() {
    int correctAnswers = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (userAnswers[i] == widget.quiz.questions[i].correctOptionIndex) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  void _goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.quiz.questions.length,
            ),
            SizedBox(height: 16),
            Text(
              '질문 ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '경과 시간: ${stopwatch.elapsed.inMinutes}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              currentQuestion.text,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            ...currentQuestion.options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return ElevatedButton(
                child: Text(option),
                onPressed: () => _answerQuestion(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: userAnswers[currentQuestionIndex] == index
                      ? Colors.blue
                      : null,
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      currentQuestionIndex > 0 ? _goToPreviousQuestion : null,
                  child: Text('이전'),
                ),
                ElevatedButton(
                  onPressed:
                      currentQuestionIndex == widget.quiz.questions.length - 1
                          ? _showResults
                          : null,
                  child: Text('결과 보기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
