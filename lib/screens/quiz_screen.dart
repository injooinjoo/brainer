import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';
import 'quiz_registration_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuizIndex = 0;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showingAnswer = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzes();
    });
  }

  void _answerQuestion(bool isCorrect) {
    setState(() {
      _lastAnswerCorrect = isCorrect;
      if (isCorrect) {
        _score++;
      }
      _showingAnswer = true;
    });
  }

  void _moveToNextQuestion() {
    setState(() {
      _showingAnswer = false;
      _currentQuestionIndex++;
      if (_currentQuestionIndex >= _getCurrentQuiz().questions.length) {
        _currentQuestionIndex = 0;
        _currentQuizIndex++;
      }
    });
  }

  Quiz _getCurrentQuiz() {
    final quizzes = Provider.of<QuizProvider>(context, listen: false).quizzes;
    return quizzes[_currentQuizIndex];
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final quizzes = quizProvider.quizzes;

    if (quizzes.isEmpty) {
      return _buildLoadingScreen();
    }

    if (_currentQuizIndex >= quizzes.length) {
      return _buildQuizCompletedScreen();
    }

    final currentQuiz = _getCurrentQuiz();
    final currentQuestion = currentQuiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToQuizRegistration(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quiz ${_currentQuizIndex + 1} - Question ${_currentQuestionIndex + 1} of ${currentQuiz.questions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion.text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            if (!_showingAnswer) ...[
              ...currentQuestion.options.map((option) {
                return ElevatedButton(
                  onPressed: () => _answerQuestion(option ==
                      currentQuestion
                          .options[currentQuestion.correctOptionIndex]),
                  child: Text(option),
                );
              }).toList(),
            ] else ...[
              _buildAnswerFeedback(currentQuestion),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _moveToNextQuestion,
                child: Text('Next Question'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerFeedback(Question question) {
    return Column(
      children: [
        Icon(
          _lastAnswerCorrect ? Icons.check_circle : Icons.cancel,
          color: _lastAnswerCorrect ? Colors.green : Colors.red,
          size: 48,
        ),
        SizedBox(height: 10),
        Text(
          _lastAnswerCorrect ? 'Correct!' : 'Incorrect',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _lastAnswerCorrect ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Correct Answer: ${question.options[question.correctOptionIndex]}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Explanation: ${question.explanation}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToQuizRegistration(context),
          ),
        ],
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildQuizCompletedScreen() {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Completed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You scored $_score out of ${Provider.of<QuizProvider>(context, listen: false).quizzes.expand((quiz) => quiz.questions).length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _restartQuiz,
              child: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToQuizRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizRegistrationScreen()),
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentQuizIndex = 0;
      _currentQuestionIndex = 0;
      _score = 0;
      _showingAnswer = false;
    });
  }
}
