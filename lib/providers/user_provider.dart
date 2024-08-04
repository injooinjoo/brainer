// lib/providers/user_provider.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get user => _user;

  // 추가된 displayName getter
  String get displayName {
    return _user?.displayName ?? _user?.name ?? 'User';
  }

  Future<void> updateUser(User user) async {
    _user = user;
    notifyListeners();
    // Update user in Firestore
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toFirestore());
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> loadUser(String userId) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          _user = User.fromFirestore(doc);
          if (_user!.displayName.isEmpty) {
            _user = _user!.copyWith(displayName: _user!.name);
            await updateUser(_user!);
          }
          notifyListeners();
          print('User loaded successfully: ${_user!.displayName}');
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
  }

  Future<void> updateUserStats(int newScore) async {
    if (_user != null) {
      _user!.updateStats(newScore);
      await updateUser(_user!);
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    if (_user == null) return;

    try {
      // Upload image to Firebase Storage
      final ref = _storage.ref().child('user_profiles/${_user!.id}.jpg');
      await ref.putFile(File(imagePath));
      final url = await ref.getDownloadURL();

      // Update user object
      _user = _user!.copyWith(photoUrl: url);
      notifyListeners();

      // Update user in Firestore
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'photoUrl': url});
    } catch (e) {
      print('Error updating profile image: $e');
      // Handle error (e.g., show error message to user)
    }
  }

  // 추가된 메서드: displayName 업데이트
  Future<void> updateDisplayName(String newDisplayName) async {
    if (_user != null) {
      _user = _user!.copyWith(displayName: newDisplayName);
      await updateUser(_user!);
    }
  }
}
