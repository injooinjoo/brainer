import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/quiz_provider.dart';

class QuizRegistrationScreen extends StatefulWidget {
  @override
  _QuizRegistrationScreenState createState() => _QuizRegistrationScreenState();
}

class _QuizRegistrationScreenState extends State<QuizRegistrationScreen> {
  // Controller to manage the title input field
  final TextEditingController _titleController = TextEditingController();
  final List<QuestionData> _questions = []; // List to store the questions
  String _selectedCategory = 'General'; // Default category
  String _selectedDifficulty = 'Medium'; // Default difficulty

  // Dropdown options for categories and difficulties
  final List<String> _categories = ['General', 'Science', 'History', 'Sports'];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  // Method to add a new question
  void _addQuestion() {
    setState(() {
      _questions.add(QuestionData());
    });
  }

  // Method to remove a question by its index
  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  // Method to save the quiz
  void _saveQuiz() {
    final title = _titleController.text;
    final questions = _questions
        .map((qData) => Question(
              id: '',
              text: qData.questionController.text,
              options: qData.optionControllers.map((c) => c.text).toList(),
              correctOptionIndex: qData.correctOptionIndex,
            ))
        .toList();

    // Validation: Check if title, questions, and at least 2 options per question are provided
    if (title.isNotEmpty &&
        questions.isNotEmpty &&
        questions.every((q) => q.options.length >= 2)) {
      final quiz = Quiz(
        id: '',
        title: title,
        questions: questions,
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
      );
      // Add the quiz using the QuizProvider
      Provider.of<QuizProvider>(context, listen: false).addQuiz(quiz);
      Navigator.pop(context); // Return to the previous screen
    } else {
      // Show an error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목, 질문, 그리고 각 질문당 최소 2개의 옵션을 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈 등록'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card for quiz information input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '퀴즈 정보',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: '퀴즈 제목',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: '카테고리',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedDifficulty,
                        decoration: InputDecoration(
                          labelText: '난이도',
                          border: OutlineInputBorder(),
                        ),
                        items: _difficulties.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDifficulty = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                '질문 목록',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              // Display all added questions
              ..._questions
                  .asMap()
                  .entries
                  .map((entry) => _buildQuestionWidget(entry.key, entry.value))
                  .toList(),
              SizedBox(height: 16),
              // Button to add a new question
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: Icon(Icons.add),
                label: Text('질문 추가'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 24),
              // Button to save the quiz
              ElevatedButton(
                onPressed: _saveQuiz,
                child: Text('퀴즈 등록'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // 버튼 배경색
                  foregroundColor: Colors.white, // 텍스트 색상 흰색으로 변경
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build each question input form
  Widget _buildQuestionWidget(int index, QuestionData questionData) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row to display question number and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '질문 ${index + 1}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeQuestion(index),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: questionData.questionController,
              decoration: InputDecoration(
                labelText: '질문',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('옵션', style: Theme.of(context).textTheme.titleSmall),
            // Display all added options for the question
            ...questionData.optionControllers.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final optionController = entry.value;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Radio<int>(
                      value: optionIndex,
                      groupValue: questionData.correctOptionIndex,
                      onChanged: (int? value) {
                        setState(() {
                          questionData.correctOptionIndex = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionController,
                        decoration: InputDecoration(
                          labelText: '옵션 ${optionIndex + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            // Button to add a new option for the question
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  questionData.addOption();
                });
              },
              icon: Icon(Icons.add),
              label: Text('옵션 추가'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Class to manage question data and options
class QuestionData {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  int correctOptionIndex = 0;

  // Method to add a new option to the question
  void addOption() {
    optionControllers.add(TextEditingController());
  }
}
