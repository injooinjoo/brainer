import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_provider.dart';
import 'edit_profile_screen.dart';
import 'friend_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  Future<void> _updateProfileImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
        await userProvider.updateProfileImage(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context);
    final user = userProvider.user;

    String quizRankingPercentage = "10%"; // Placeholder value

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user?.name ?? 'Anonymous',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _updateProfileImage(context),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (user?.photoUrl != null
                              ? NetworkImage(user!.photoUrl!) as ImageProvider
                              : null),
                      child: (user?.photoUrl == null && _image == null)
                          ? Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('0', 'Followers'),
                        _buildStatColumn(quizRankingPercentage, 'Quiz Top'),
                        _buildStatColumn(
                            quizProvider.quizzes.length.toString(), 'Quiz'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()),
                        );
                      },
                      child: Text('Edit Profile'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendScreen()),
                        );
                      },
                      child: Text('Friends'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.quiz), text: 'Quizzes'),
                        Tab(
                            icon: Icon(Icons.emoji_events),
                            text: 'Achievements'),
                        Tab(icon: Icon(Icons.flag), text: 'Goals'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildQuizzes(quizProvider),
                          _buildAchievements(),
                          _buildGoals(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }

  Widget _buildQuizzes(QuizProvider quizProvider) {
    List<Map<String, dynamic>> quizzes = [
      {'name': 'ACT', 'progress': 0.7},
      {'name': 'IELTS', 'progress': 0.9},
      {'name': 'LSAT', 'progress': 0.6},
      {'name': 'GMAT', 'progress': 0.4},
      {'name': 'MCAT', 'progress': 0.3},
      {'name': 'CLAT', 'progress': 0.5},
      {'name': 'CAT', 'progress': 0.8},
      {'name': 'MAT', 'progress': 0.2},
      {'name': 'GATE', 'progress': 0.6},
      {'name': 'JEE', 'progress': 0.9},
      {'name': 'NEET', 'progress': 0.7},
      {'name': 'SSC', 'progress': 0.5},
      {'name': 'UPSC', 'progress': 0.3},
      {'name': 'NDA', 'progress': 0.4},
      {'name': 'XAT', 'progress': 0.8},
      {'name': 'SNAP', 'progress': 0.6},
      {'name': 'TANCET', 'progress': 0.9},
      {'name': 'IPMAT', 'progress': 0.7},
      {'name': 'AP', 'progress': 0.4},
      {'name': 'OET', 'progress': 0.5},
      {'name': 'PTE', 'progress': 0.6},
      {'name': 'DSH', 'progress': 0.3},
      {'name': 'CFA', 'progress': 0.8},
      {'name': 'FRM', 'progress': 0.7},
      {'name': 'CAIA', 'progress': 0.5},
      {'name': 'CPA', 'progress': 0.9},
      {'name': 'USMLE', 'progress': 0.4},
      {'name': 'BAR', 'progress': 0.3},
      {'name': 'PLAB', 'progress': 0.7},
      {'name': 'DRCOG', 'progress': 0.8},
      {'name': 'TSA', 'progress': 0.6},
      {'name': 'BMAT', 'progress': 0.5},
      {'name': 'STEP', 'progress': 0.4},
      {'name': 'UCAT', 'progress': 0.3},
      {'name': 'IMAT', 'progress': 0.6},
      {'name': 'LNAT', 'progress': 0.7},
      {'name': 'PAT', 'progress': 0.5},
      {'name': 'HAT', 'progress': 0.8},
      {'name': 'MAT (Cambridge)', 'progress': 0.9},
      {'name': 'GAMSAT', 'progress': 0.4},
      {'name': 'SSAT', 'progress': 0.7},
      {'name': 'ISEE', 'progress': 0.6},
      {'name': 'SHSAT', 'progress': 0.8},
      {'name': 'PSAT', 'progress': 0.5},
      {'name': 'SBAC', 'progress': 0.9},
      {'name': 'AP Exam', 'progress': 0.4},
      {'name': 'IB Exam', 'progress': 0.7},
      {'name': 'O Levels', 'progress': 0.6},
      {'name': 'A Levels', 'progress': 0.8},
      {'name': 'TOEIC', 'progress': 0.9},
    ];

    // Sort quizzes by progress in descending order
    quizzes.sort((a, b) => b['progress'].compareTo(a['progress']));

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        return _buildQuizItem(
            quizzes[index]['name'], quizzes[index]['progress']);
      },
    );
  }

  Widget _buildQuizItem(String name, double progress) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    name[0],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    List<Map<String, dynamic>> achievements = [
      {'name': 'TOEFL Master', 'icon': Icons.school},
      {'name': 'Quiz Champion', 'icon': Icons.emoji_events},
      {'name': 'Study Streak', 'icon': Icons.whatshot},
      {'name': 'Language Pro', 'icon': Icons.language},
      {'name': 'Math Whiz', 'icon': Icons.calculate},
      {'name': 'Science Buff', 'icon': Icons.science},
      {'name': 'Reading Guru', 'icon': Icons.menu_book},
      {'name': 'Essay Expert', 'icon': Icons.edit},
      {'name': 'History Hero', 'icon': Icons.history_edu},
      {'name': 'Grammar Guru', 'icon': Icons.spellcheck},
      {'name': 'Vocabulary Master', 'icon': Icons.book},
      {'name': 'Physics Phenom', 'icon': Icons.device_hub},
      {'name': 'Chemistry Champ', 'icon': Icons.flag},
      {'name': 'Biology Brain', 'icon': Icons.biotech},
      {'name': 'Geography Genius', 'icon': Icons.map},
      {'name': 'Coding Conqueror', 'icon': Icons.code},
      {'name': 'Algebra Ace', 'icon': Icons.functions},
      {'name': 'Geometry Giant', 'icon': Icons.square_foot},
      {'name': 'Calculus Commander', 'icon': Icons.timeline},
      {'name': 'Statistics Star', 'icon': Icons.bar_chart},
      {'name': 'Philosophy Prodigy', 'icon': Icons.psychology},
      {'name': 'Art Aficionado', 'icon': Icons.palette},
      {'name': 'Music Maestro', 'icon': Icons.music_note},
      {'name': 'Drama Diva', 'icon': Icons.theater_comedy},
      {'name': 'Tech Titan', 'icon': Icons.computer},
      {'name': 'Business Brain', 'icon': Icons.business_center},
      {'name': 'Economics Expert', 'icon': Icons.account_balance},
      {'name': 'Finance Guru', 'icon': Icons.attach_money},
      {'name': 'Marketing Maven', 'icon': Icons.trending_up},
      {'name': 'Psychology Sage', 'icon': Icons.psychology_alt},
      {'name': 'Sociology Scholar', 'icon': Icons.people},
      {'name': 'Law Luminary', 'icon': Icons.gavel},
      {'name': 'Engineering Expert', 'icon': Icons.build},
      {'name': 'Medical Master', 'icon': Icons.local_hospital},
      {'name': 'Nursing Nurturer', 'icon': Icons.health_and_safety},
      {'name': 'Pharmacy Phenom', 'icon': Icons.medical_services},
      {'name': 'Dentistry Dynamo', 'icon': Icons.south},
      {'name': 'Architecture Ace', 'icon': Icons.architecture},
      {'name': 'Design Diva', 'icon': Icons.design_services},
      {'name': 'Fashion Forward', 'icon': Icons.checkroom},
      {'name': 'Culinary Creator', 'icon': Icons.restaurant},
      {'name': 'Photography Pro', 'icon': Icons.camera_alt},
      {'name': 'Film Fanatic', 'icon': Icons.movie},
      {'name': 'Literature Lover', 'icon': Icons.menu_book},
      {'name': 'Poetry Prodigy', 'icon': Icons.format_quote},
      {'name': 'Journalism Jedi', 'icon': Icons.article},
      {'name': 'Political Pro', 'icon': Icons.public},
      {'name': 'Social Science Savant', 'icon': Icons.school},
      {'name': 'Humanities Hero', 'icon': Icons.import_contacts},
      {'name': 'Linguistics Legend', 'icon': Icons.translate},
      {'name': 'Anthropology Aficionado', 'icon': Icons.groups},
      {'name': 'Environmental Expert', 'icon': Icons.eco},
      {'name': 'Astronomy Ace', 'icon': Icons.star},
    ];

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return _buildAchievementItem(
            achievements[index]['name'], achievements[index]['icon']);
      },
    );
  }

  Widget _buildAchievementItem(String name, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
          SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoals() {
    List<Map<String, dynamic>> goals = [
      {'name': 'Complete TOEFL Prep', 'progress': 0.7},
      {'name': 'Finish SAT Practice Tests', 'progress': 0.4},
      {'name': 'Learn 500 GRE Words', 'progress': 0.2},
      {'name': 'Master ACT Math Section', 'progress': 0.6},
      {'name': 'Complete IELTS Listening Practice', 'progress': 0.8},
      {'name': 'Finish LSAT Logic Games', 'progress': 0.5},
      {'name': 'Study for GMAT Quantitative', 'progress': 0.3},
      {'name': 'Review MCAT Biochemistry', 'progress': 0.4},
      {'name': 'Prepare for CLAT Legal Aptitude', 'progress': 0.7},
      {'name': 'Complete CAT Data Interpretation', 'progress': 0.9},
      {'name': 'Finish MAT Analogy Questions', 'progress': 0.2},
      {'name': 'Practice GATE Mechanical Engineering', 'progress': 0.6},
      {'name': 'Review JEE Advanced Physics', 'progress': 0.8},
      {'name': 'Study for NEET Biology Section', 'progress': 0.7},
      {'name': 'Prepare for SSC General Awareness', 'progress': 0.5},
      {'name': 'Finish UPSC CSAT Paper', 'progress': 0.3},
      {'name': 'Complete NDA Mathematics', 'progress': 0.4},
      {'name': 'Master XAT Decision Making', 'progress': 0.8},
      {'name': 'Finish SNAP General English', 'progress': 0.6},
      {'name': 'Study for TANCET MBA', 'progress': 0.9},
      {'name': 'Prepare for IPMAT Quantitative Aptitude', 'progress': 0.7},
      {'name': 'Complete AP Calculus Practice', 'progress': 0.4},
      {'name': 'Finish OET Writing Tasks', 'progress': 0.5},
      {'name': 'Learn 1000 PTE Vocabulary Words', 'progress': 0.6},
      {'name': 'Review DSH German Language Skills', 'progress': 0.3},
      {'name': 'Complete CFA Level 1 Ethics', 'progress': 0.8},
      {'name': 'Finish FRM Risk Management Prep', 'progress': 0.7},
      {'name': 'Study for CAIA Investment Analysis', 'progress': 0.5},
      {'name': 'Prepare for CPA Financial Accounting', 'progress': 0.9},
      {'name': 'Complete USMLE Step 1', 'progress': 0.4},
      {'name': 'Finish BAR Exam Essay Writing', 'progress': 0.3},
      {'name': 'Review PLAB Clinical Skills', 'progress': 0.7},
      {'name': 'Study for DRCOG Obstetrics', 'progress': 0.8},
      {'name': 'Master TSA Critical Thinking', 'progress': 0.6},
      {'name': 'Complete BMAT Section 2 Prep', 'progress': 0.5},
      {'name': 'Finish STEP Mathematics Practice', 'progress': 0.4},
      {'name': 'Prepare for UCAT Abstract Reasoning', 'progress': 0.3},
      {'name': 'Review IMAT Biology Concepts', 'progress': 0.6},
      {'name': 'Study for LNAT Essay Writing', 'progress': 0.7},
      {'name': 'Complete PAT Physics Preparation', 'progress': 0.5},
      {'name': 'Finish HAT History Analysis', 'progress': 0.8},
      {'name': 'Prepare for MAT (Cambridge) Problem Solving', 'progress': 0.9},
      {'name': 'Study for GAMSAT Science Section', 'progress': 0.4},
      {'name': 'Complete SSAT Reading Comprehension', 'progress': 0.7},
      {'name': 'Finish ISEE Math Achievement', 'progress': 0.6},
      {'name': 'Prepare for SHSAT ELA', 'progress': 0.8},
      {'name': 'Review PSAT Math Section', 'progress': 0.5},
      {'name': 'Complete SBAC English Language Arts', 'progress': 0.9},
      {'name': 'Finish AP Physics C: Mechanics', 'progress': 0.4},
      {'name': 'Study for IB Chemistry HL', 'progress': 0.7},
      {'name': 'Review O Levels Mathematics', 'progress': 0.6},
      {'name': 'Prepare for A Levels Biology', 'progress': 0.8},
      {'name': 'Complete TOEIC Listening Practice', 'progress': 0.9},
    ];

    // Sort goals by progress in descending order
    goals.sort((a, b) => b['progress'].compareTo(a['progress']));

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return _buildGoalItem(goals[index]['name'], goals[index]['progress']);
      },
    );
  }

  Widget _buildGoalItem(String name, double progress) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8),
            CircularProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
