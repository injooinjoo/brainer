import 'package:brainer_flutter/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/quiz.dart';
import 'quiz_result_screen.dart';
import '../widgets/sharing_widget.dart';

class QuizSolvingScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizSolvingScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizSolvingScreenState createState() => _QuizSolvingScreenState();
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isPrimary ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
      child: Text(text),
    );
  }
}

class _QuizSolvingScreenState extends State<QuizSolvingScreen> {
  int _currentQuestionIndex = 0;
  late List<int?> _userAnswers;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _timeString = '00:00';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(widget.quiz.questions.length, null);
    _stopwatch = Stopwatch()..start();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isActive && mounted) {
        setState(() {
          _timeString = _formatTime(_stopwatch.elapsedMilliseconds);
        });
      }
    });
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _isActive = false;
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  void _answerQuestion(int answerIndex) {
    if (!_isActive) return;
    setState(() {
      _userAnswers[_currentQuestionIndex] = answerIndex;
      if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
        _currentQuestionIndex++;
      }
    });
  }

  void _submitQuiz() {
    _isActive = false;
    _stopwatch.stop();
    _timer.cancel();

    int score = _calculateScore();
    Duration duration = _stopwatch.elapsed;

    // Save quiz result
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.saveQuizResult(
        widget.quiz.id, score, duration, 'current_user_id');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quiz: widget.quiz,
          userAnswers: _userAnswers,
          score: score,
          duration: duration,
        ),
      ),
    );
  }

  int _calculateScore() {
    return _userAnswers
        .asMap()
        .entries
        .where((entry) =>
            entry.value == widget.quiz.questions[entry.key].correctOptionIndex)
        .length;
  }

  void _goToPreviousQuestion() {
    if (!_isActive) return;
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  String _generateShareContent() {
    return '나는 지금 "${widget.quiz.title}" 퀴즈를 풀고 있어요! 함께 도전해보세요!';
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.quiz.questions[_currentQuestionIndex];

    return WillPopScope(
      onWillPop: () async {
        _isActive = false;
        _stopwatch.stop();
        _timer.cancel();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz.title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _isActive = false;
              _stopwatch.stop();
              _timer.cancel();
              Navigator.of(context).pop();
            },
            tooltip: 'Close Quiz',
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  _timeString,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) /
                      widget.quiz.questions.length,
                  semanticsLabel: 'Quiz progress',
                ),
                const SizedBox(height: 16),
                _buildQuizInfo(),
                const SizedBox(height: 16),
                _buildQuestionText(currentQuestion),
                const SizedBox(height: 24),
                ..._buildAnswerOptions(currentQuestion),
                const SizedBox(height: 16),
                _buildNavigationButtons(),
                const SizedBox(height: 16),
                SharingWidget(
                  content: _generateShareContent(),
                  url: 'https://yourapp.com/quiz/${widget.quiz.id}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInfo() {
    return Text(
      '질문 ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildQuestionText(Question question) {
    return Text(
      question.text,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  List<Widget> _buildAnswerOptions(Question question) {
    return question.options.asMap().entries.map((entry) {
      int index = entry.key;
      String option = entry.value;
      bool isSelected = _userAnswers[_currentQuestionIndex] == index;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CustomButton(
          text: option,
          onPressed: () => _answerQuestion(index),
          isPrimary: isSelected,
        ),
      );
    }).toList();
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          text: '이전',
          onPressed:
              _currentQuestionIndex > 0 ? () => _goToPreviousQuestion() : null,
          isPrimary: false,
        ),
        CustomButton(
          text: _currentQuestionIndex == widget.quiz.questions.length - 1
              ? '제출'
              : '다음',
          onPressed: _currentQuestionIndex == widget.quiz.questions.length - 1
              ? () => _submitQuiz()
              : () {
                  if (_userAnswers[_currentQuestionIndex] != null) {
                    setState(() {
                      _currentQuestionIndex++;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('질문에 답해주세요.')),
                    );
                  }
                },
          isPrimary: true,
        ),
      ],
    );
  }
}
