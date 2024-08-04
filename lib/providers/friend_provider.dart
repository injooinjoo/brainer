// lib/providers/friend_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class FriendProvider with ChangeNotifier {
  List<User> _friends = [];
  List<User> _friendRequests = [];

  List<User> get friends => _friends;
  List<User> get friendRequests => _friendRequests;

  Future<void> fetchFriends(String userId) async {
    try {
      QuerySnapshot friendSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      _friends =
          friendSnapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching friends: $e');
    }
  }

  Future<void> fetchFriendRequests(String userId) async {
    try {
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('friendRequests')
          .get();

      _friendRequests =
          requestSnapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
  }

  Future<void> sendFriendRequest(String currentUserId, String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('friendRequests')
          .doc(currentUserId)
          .set({});
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  Future<void> acceptFriendRequest(
      String currentUserId, String friendId) async {
    try {
      // Add friend to current user's friends list
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendId)
          .set({});

      // Add current user to friend's friends list
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(currentUserId)
          .set({});

      // Remove friend request
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friendRequests')
          .doc(friendId)
          .delete();

      await fetchFriends(currentUserId);
      await fetchFriendRequests(currentUserId);
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }
}
