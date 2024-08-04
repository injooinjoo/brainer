import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/quiz_provider.dart';

class QuizRegistrationScreen extends StatefulWidget {
  @override
  _QuizRegistrationScreenState createState() => _QuizRegistrationScreenState();
}

class _QuizRegistrationScreenState extends State<QuizRegistrationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<QuestionData> _questions = [];
  String _selectedCategory = 'General';
  String _selectedDifficulty = 'Medium';

  final List<String> _categories = ['General', 'Science', 'History', 'Sports'];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionData());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _saveQuiz() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final questions = _questions
        .map((qData) => Question(
              text: qData.questionController.text,
              options: qData.optionControllers.map((c) => c.text).toList(),
              correctOptionIndex: qData.correctOptionIndex,
            ))
        .toList();

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        questions.isNotEmpty &&
        questions.every((q) => q.options.length >= 2)) {
      final quiz = Quiz(
        title: title,
        description: description,
        questions: questions,
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        id: '',
      );
      Provider.of<QuizProvider>(context, listen: false).addQuiz(quiz);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목, 설명, 질문, 그리고 각 질문당 최소 2개의 옵션을 입력해주세요.')),
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
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: '퀴즈 설명',
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
              ..._questions
                  .asMap()
                  .entries
                  .map((entry) => _buildQuestionWidget(entry.key, entry.value))
                  .toList(),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: Icon(Icons.add),
                label: Text('질문 추가'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveQuiz,
                child: Text('퀴즈 등록'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/quiz_generation');
                },
                child: Text('GPT를 통한 퀴즈 생성'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(int index, QuestionData questionData) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

class QuestionData {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  int correctOptionIndex = 0;

  void addOption() {
    optionControllers.add(TextEditingController());
  }
}
