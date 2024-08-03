import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await authProvider.loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final User? user = userProvider.user;
          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                  ),
                ),
                SizedBox(height: 16),
                Text('이름: ${user.name}',
                    style: Theme.of(context).textTheme.titleLarge),
                Text('이메일: ${user.email}',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 24),
                Text('통계', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                Text('풀은 퀴즈 수: ${user.quizzesTaken}'),
                Text('평균 점수: ${user.averageScore.toStringAsFixed(2)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
