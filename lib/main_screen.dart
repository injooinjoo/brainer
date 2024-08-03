//main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/quiz_screen.dart';
import 'screens/goal_setting_screen.dart';
import 'providers/quiz_provider.dart';
import 'models/goal.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzes();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() => [
        HomeContent(goals: goals),
        LeaderboardScreen(),
        ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BRAINER'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
        selectedItemColor: Colors.blue,
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
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for quizzes',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text('Your Goals',
                style:
                    AppTheme.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Expanded(
              child: goals.isEmpty
                  ? const Center(child: Text('No goals set. Add a new goal!'))
                  : ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(goals[index].title),
                          subtitle: Text(
                              goals[index].dueDate.toString().split(' ')[0]),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            // TODO: Navigate to GoalDetailScreen
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
                  child: const Text('Start a New Quiz'),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newGoal = await Navigator.push<Goal>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GoalSettingScreen()),
                );
                if (newGoal != null) {
                  // TODO: Add the new goal to the list
                }
              },
              child: const Text('Set a New Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
