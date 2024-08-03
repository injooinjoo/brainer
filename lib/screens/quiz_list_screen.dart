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
  String _selectedDifficulty = 'All';
  List<String> _categories = ['All'];
  List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];
  Map<String, int> _quizHighScores = {};
  bool _isLoading = false;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshQuizzes(context);
    });
  }

  Future<void> _refreshQuizzes(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        Provider.of<QuizProvider>(context, listen: false).fetchQuizzes(),
        _fetchHighScores(context),
      ]);

      setState(() {
        _categories = [
          'All',
          ...Provider.of<QuizProvider>(context, listen: false)
              .quizzes
              .map((q) => q.category)
              .toSet()
              .toList()
        ];
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('퀴즈 목록을 불러오는 데 실패했습니다. 다시 시도해 주세요.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchHighScores(BuildContext context) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    for (var quiz in quizProvider.quizzes) {
      final stats = await quizProvider.getQuizStatistics(quiz.id, userId);
      setState(() {
        _quizHighScores[quiz.id] = stats['highScore'];
      });
    }
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '퀴즈 검색',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
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
              DropdownButton<String>(
                value: _selectedDifficulty,
                items: _difficulties.map((String difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
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
          Expanded(
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (quizProvider.quizzes.isEmpty) {
                  return Center(
                    child: Text('등록된 퀴즈가 없습니다.'),
                  );
                }

                List<Quiz> filteredQuizzes = quizProvider.quizzes.where((quiz) {
                  bool categoryMatch = _selectedCategory == 'All' ||
                      quiz.category == _selectedCategory;
                  bool difficultyMatch = _selectedDifficulty == 'All' ||
                      quiz.difficulty == _selectedDifficulty;
                  bool searchMatch = _searchQuery.isEmpty ||
                      quiz.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                  return categoryMatch && difficultyMatch && searchMatch;
                }).toList();

                return RefreshIndicator(
                  onRefresh: () => _refreshQuizzes(context),
                  child: ListView.builder(
                    itemCount: filteredQuizzes.length,
                    itemBuilder: (context, index) {
                      Quiz quiz = filteredQuizzes[index];
                      int highScore = _quizHighScores[quiz.id] ?? 0;
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/quiz_registration');
          _refreshQuizzes(context);
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
