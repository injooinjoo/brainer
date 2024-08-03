import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaderboardProvider>(
      builder: (context, leaderboardProvider, child) {
        return DropdownButton<String>(
          value: leaderboardProvider.currentCategory,
          items: ['General', 'Math', 'Science', 'History'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              leaderboardProvider.updateCategory(newValue);
            }
          },
        );
      },
    );
  }
}
