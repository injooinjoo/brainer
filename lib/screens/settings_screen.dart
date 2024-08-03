import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('New Quiz Notifications'),
            value: notificationProvider.isNewQuizNotificationEnabled,
            onChanged: (value) =>
                notificationProvider.setNewQuizNotification(value),
          ),
          SwitchListTile(
            title: Text('Challenge Notifications'),
            value: notificationProvider.isChallengeNotificationEnabled,
            onChanged: (value) =>
                notificationProvider.setChallengeNotification(value),
          ),
          // ... 기타 설정 옵션들 ...
        ],
      ),
    );
  }
}
