// lib/screens/quiz_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';
import 'quiz_detail_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                if (quizProvider.quizzes.isEmpty) {
                  return Center(
                    child: Text('등록된 퀴즈가 없습니다.'),
                  );
                }

                List<Quiz> filteredQuizzes = _selectedCategory == 'All'
                    ? quizProvider.quizzes
                    : quizProvider.quizzes
                        .where((quiz) => quiz.category == _selectedCategory)
                        .toList();

                return ListView.builder(
                  itemCount: filteredQuizzes.length,
                  itemBuilder: (context, index) {
                    Quiz quiz = filteredQuizzes[index];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: quizProvider.getQuizStatistics(
                          quiz.id, FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(title: Text(quiz.title));
                        }
                        int highScore = snapshot.data?['highScore'] ?? 0;
                        return ListTile(
                          title: Text(quiz.title),
                          subtitle: Text(
                              '${quiz.questions.length}개의 질문 | 난이도: ${quiz.difficulty} | 최고 점수: $highScore'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizDetailScreen(quiz: quiz),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/quiz_registration');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    _categories = [
      'All',
      ...quizProvider.quizzes.map((q) => q.category).toSet().toList()
    ];
  }
}
