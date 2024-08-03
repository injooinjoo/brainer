import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> updateUser(User user) async {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> loadUser(String userId) async {
    // Firestore 관련 코드는 주석 처리합니다.
    // 필요하다면 나중에 다시 구현할 수 있습니다.
    /*
    int retries = 3;
    while (retries > 0) {
      try {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          _user = User.fromFirestore(doc);
          notifyListeners();
          print('User loaded successfully: ${_user!.name}');
          return;
        } else {
          print('User document does not exist for ID: $userId');
          return;
        }
      } catch (e) {
        print('Error loading user: $e');
        retries--;
        if (retries > 0) {
          print('Retrying in 2 seconds...');
          await Future.delayed(Duration(seconds: 2));
        }
      }
    }
    print('Failed to load user after multiple attempts');
    */
  }

  Future<void> updateUserStats(int newScore) async {
    if (_user != null) {
      _user!.updateStats(newScore);
      await updateUser(_user!);
    }
  }
}
