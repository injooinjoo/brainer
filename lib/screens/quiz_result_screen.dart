import 'package:brainer_flutter/screens/quiz_solving_screen.dart';
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
              _buildSummaryCard(),
              SizedBox(height: 24),
              Text('상세 분석', style: AppTheme.headlineStyle),
              SizedBox(height: 16),
              _buildDetailedAnalysis(),
              SizedBox(height: 24),
              Text('오답 노트', style: AppTheme.headlineStyle),
              SizedBox(height: 16),
              _buildIncorrectAnswersNote(),
              SizedBox(height: 24),
              _buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('최종 점수', style: AppTheme.headlineStyle),
            SizedBox(height: 8),
            Text(
              '$score / ${quiz.questions.length}',
              style: AppTheme.headlineStyle.copyWith(
                color: AppTheme.primaryColor,
                fontSize: 48,
              ),
            ),
            SizedBox(height: 8),
            Text('소요 시간: ${_formatDuration(duration)}',
                style: AppTheme.bodyStyle),
            SizedBox(height: 8),
            Text(
              '정답률: ${(score / quiz.questions.length * 100).toStringAsFixed(1)}%',
              style: AppTheme.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalysis() {
    return ListView.builder(
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
                  style:
                      TextStyle(color: isCorrect ? Colors.green : Colors.red),
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
    );
  }

  Widget _buildIncorrectAnswersNote() {
    final incorrectQuestions = quiz.questions.asMap().entries.where((entry) {
      final index = entry.key;
      final question = entry.value;
      return userAnswers[index] != question.correctOptionIndex;
    }).toList();

    if (incorrectQuestions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('모든 문제를 맞혔습니다. 축하합니다!', style: AppTheme.bodyStyle),
        ),
      );
    }

    return Column(
      children: incorrectQuestions.map((entry) {
        final index = entry.key;
        final question = entry.value;
        final userAnswer = userAnswers[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Question ${index + 1}: ${question.text}',
                    style: AppTheme.bodyStyle
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    '당신의 답변: ${userAnswer != null ? question.options[userAnswer] : '답변 없음'}',
                    style: TextStyle(color: Colors.red)),
                SizedBox(height: 4),
                Text('정답: ${question.options[question.correctOptionIndex]}',
                    style: TextStyle(color: Colors.green)),
                SizedBox(height: 8),
                Text('설명: 이 문제에 대한 추가 설명이나 학습 자료를 여기에 추가할 수 있습니다.',
                    style: AppTheme.bodyStyle),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizSolvingScreen(quiz: quiz)),
            );
          },
          child: Text('다시 풀기'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Text('홈으로 돌아가기'),
        ),
      ],
    );
  }
}
