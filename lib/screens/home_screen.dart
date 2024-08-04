import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../screens/quiz_screen.dart';
import '../screens/goal_setting_screen.dart';
import '../screens/goal_detail_screen.dart';
import '../models/goal.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Goal> goals = [];
  List<String> categories = ['시험', '학습', '카테고리'];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.displayName;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('For $username'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                children: List.generate(categories.length, (index) {
                  return ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategoryIndex == index,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                        if (index == 2) {
                          _showCategoriesDialog();
                        }
                      }
                    },
                  );
                }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.3),
                        BlendMode.lighten,
                      ),
                      child: Image.asset(
                        '/Users/jacobmac/Desktop/Dev/brainer/brainer_flutter/assets/dummy_exam_image.jpg',
                        height: 450,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        'GMAT',
                        style: TextStyle(
                          fontFamily: 'TimesNewRoman',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 연습하기 기능 구현
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: Text('연습하기'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // 공부하기 기능 구현
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: Text('공부하기'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '인기 학습',
                    style: AppTheme.headlineStyle.copyWith(
                        fontSize: AppTheme.headlineStyle.fontSize! / 2),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.school, size: 40),
                              ),
                              SizedBox(height: 4),
                              Text('학습 ${index + 1}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('목표',
                      style: AppTheme.headlineStyle.copyWith(
                          fontSize: AppTheme.headlineStyle.fontSize! / 2)),
                  SizedBox(height: 8),
                  goals.isEmpty
                      ? Center(child: Text('설정된 목표가 없습니다. 새 목표를 추가하세요!'))
                      : Column(
                          children: goals.map((goal) {
                            return ListTile(
                              title: Text(goal.title),
                              subtitle:
                                  Text(goal.dueDate.toString().split(' ')[0]),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () async {
                                final result = await Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GoalDetailScreen(goal: goal),
                                  ),
                                );
                                if (result is Goal) {
                                  setState(() {
                                    goals[goals.indexOf(goal)] = result;
                                  });
                                } else if (result == true) {
                                  setState(() {
                                    goals.remove(goal);
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final newGoal = await Navigator.push<Goal>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoalSettingScreen()),
                      );
                      if (newGoal != null) {
                        setState(() {
                          goals.add(newGoal);
                        });
                      }
                    },
                    child: Text('새 목표 설정'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('카테고리',
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
                        SizedBox(height: 20),
                        ...[
                          'TOEFL',
                          'SAT',
                          'GRE',
                          '수능',
                          'TOEIC',
                          'IELTS',
                          'SSAT'
                        ]
                            .map((category) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(category,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
