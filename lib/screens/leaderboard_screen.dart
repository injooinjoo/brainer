import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';
import '../widgets/leaderboard_list_item.dart';
import '../widgets/category_selector.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeaderboardProvider>(context, listen: false)
          .fetchLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Column(
        children: [
          CategorySelector(),
          Expanded(
            child: Consumer<LeaderboardProvider>(
              builder: (context, leaderboardProvider, child) {
                if (leaderboardProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (leaderboardProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('리더보드를 불러오는 중 오류가 발생했습니다.'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            leaderboardProvider.fetchLeaderboard();
                          },
                          child: Text('다시 시도'),
                        ),
                      ],
                    ),
                  );
                }
                if (leaderboardProvider.entries.isEmpty) {
                  return Center(child: Text('데이터가 없습니다.'));
                }
                return ListView.builder(
                  itemCount: leaderboardProvider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = leaderboardProvider.entries[index];
                    return LeaderboardListItem(
                      entry: entry,
                      rank: index + 1,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}