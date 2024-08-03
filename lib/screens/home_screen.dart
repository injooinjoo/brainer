import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../screens/quiz_screen.dart';
import '../screens/goal_setting_screen.dart';
import '../screens/goal_detail_screen.dart';
import '../models/goal.dart';
import '../providers/quiz_provider.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: true).fetchQuizzes();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions(List<Goal> goals, BuildContext context) =>
      [
        HomeContent(goals: goals), // 홈 화면 위젯
        QuizScreenContent(), // 퀴즈 화면 위젯
        LeaderboardScreen(), // 리더보드 화면
        ProfileScreen(), // 프로필 화면 (추가해야 합니다)
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BRAINER'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions(goals, context).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Goal> goals;

  const HomeContent({Key? key, required this.goals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back!', style: AppTheme.headlineStyle),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for quizzes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Text('Your Goals',
                style:
                    AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
              child: goals.isEmpty
                  ? Center(child: Text('No goals set. Add a new goal!'))
                  : ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(goals[index].title),
                          subtitle: Text(
                              goals[index].dueDate.toString().split(' ')[0]),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () async {
                            final result = await Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GoalDetailScreen(goal: goals[index]),
                              ),
                            );
                            if (result is Goal) {
                              // Goal이 업데이트된 경우
                              goals[index] = result;
                            } else if (result == true) {
                              // Goal이 삭제된 경우
                              goals.removeAt(index);
                            }
                          },
                        );
                      },
                    ),
            ),
            Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                return ElevatedButton(
                  onPressed: quizProvider.quizzes.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                  quiz: quizProvider.quizzes.isNotEmpty
                                      ? quizProvider.quizzes[0]
                                      : null),
                            ),
                          );
                        }
                      : null,
                  child: Text('Start a New Quiz'),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newGoal = await Navigator.push<Goal>(
                  context,
                  MaterialPageRoute(builder: (context) => GoalSettingScreen()),
                );
                if (newGoal != null) {
                  goals.add(newGoal);
                }
              },
              child: Text('Set a New Goal'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Quiz Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}
