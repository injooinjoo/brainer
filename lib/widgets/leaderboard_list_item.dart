import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardListItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;

  const LeaderboardListItem({Key? key, required this.entry, required this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(rank.toString()),
      ),
      title: Text(entry.username),
      trailing: Text(entry.score.toString()),
    );
  }
}
