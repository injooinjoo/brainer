// lib/screens/quiz_result_screen.dart

import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../theme/app_theme.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;
  final List<int?> userAnswers;
  final int score;
  final Duration duration;

  const QuizResultScreen({
    Key? key,
    required this.quiz,
    required this.userAnswers,
    required this.score,
    required this.duration,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈 결과'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '최종 점수',
                        style: AppTheme.headlineStyle,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$score / ${quiz.questions.length}',
                        style: AppTheme.headlineStyle.copyWith(
                          color: AppTheme.primaryColor,
                          fontSize: 48,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '소요 시간: ${_formatDuration(duration)}',
                        style: AppTheme.bodyStyle,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                '문제별 결과',
                style: AppTheme.headlineStyle,
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  final userAnswer = userAnswers[index];
                  final isCorrect = userAnswer == question.correctOptionIndex;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Question ${index + 1}: ${question.text}',
                                  style: AppTheme.bodyStyle
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '당신의 답변: ${userAnswer != null ? question.options[userAnswer] : '답변 없음'}',
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          if (!isCorrect) ...[
                            SizedBox(height: 4),
                            Text(
                              '정답: ${question.options[question.correctOptionIndex]}',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text('홈으로 돌아가기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
