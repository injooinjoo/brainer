import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

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
          ListTile(
            title: Text('App Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (ThemeMode? newThemeMode) {
                if (newThemeMode != null) {
                  themeProvider.setThemeMode(newThemeMode);
                }
              },
              items: ThemeMode.values.map((ThemeMode mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: languageProvider.currentLanguage,
              onChanged: (String? newLanguage) {
                if (newLanguage != null) {
                  languageProvider.setLanguage(newLanguage);
                }
              },
              items: [
                'English',
                'Spanish',
                'French',
                'German',
                'Japanese',
                'Korean'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async {
                try {
                  await context.read<AuthProvider>().signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to log out')),
                  );
                }
              },
              child: Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
