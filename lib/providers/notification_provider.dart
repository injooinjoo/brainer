import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  bool _isNewQuizNotificationEnabled = true;
  bool _isChallengeNotificationEnabled = true;

  bool get isNewQuizNotificationEnabled => _isNewQuizNotificationEnabled;
  bool get isChallengeNotificationEnabled => _isChallengeNotificationEnabled;

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _notificationService.subscribeToTopic('new_quizzes');
    await _notificationService.subscribeToTopic('challenges');
  }

  void setNewQuizNotification(bool value) {
    _isNewQuizNotificationEnabled = value;
    if (value) {
      _notificationService.subscribeToTopic('new_quizzes');
    } else {
      _notificationService.unsubscribeFromTopic('new_quizzes');
    }
    notifyListeners();
  }

  void setChallengeNotification(bool value) {
    _isChallengeNotificationEnabled = value;
    if (value) {
      _notificationService.subscribeToTopic('challenges');
    } else {
      _notificationService.unsubscribeFromTopic('challenges');
    }
    notifyListeners();
  }
}
