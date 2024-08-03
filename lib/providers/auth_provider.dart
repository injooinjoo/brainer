import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainer_flutter/providers/user_provider.dart';
import 'package:brainer_flutter/models/user.dart';

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserProvider _userProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthProvider({required UserProvider userProvider})
      : _userProvider = userProvider {
    _initializeUser();
  }

  firebase_auth.User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  User? get user => _userProvider.user;

  Future<void> _initializeUser() async {
    if (isLoggedIn) {
      await loadUserData();
    }
  }

  Future<void> loadUserData() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      int retries = 3;
      while (retries > 0) {
        try {
          final userDoc =
              await _firestore.collection('users').doc(firebaseUser.uid).get();
          if (userDoc.exists) {
            final user = User.fromFirestore(userDoc);
            await _userProvider.updateUser(user);
            print('User data loaded successfully');
          } else {
            final newUser = User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName ?? 'Anonymous',
              email: firebaseUser.email ?? '',
              photoUrl: firebaseUser.photoURL,
            );
            await _firestore
                .collection('users')
                .doc(firebaseUser.uid)
                .set(newUser.toFirestore());
            await _userProvider.updateUser(newUser);
            print('New user created and data saved');
          }
          notifyListeners();
          return;
        } catch (e) {
          print('Error in loadUserData: $e');
          retries--;
          if (retries > 0) {
            print('Retrying to load user data in 2 seconds...');
            await Future.delayed(Duration(seconds: 2));
          }
        }
      }
      print('Failed to load user data after multiple attempts');
    }
  }

  Future<firebase_auth.UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await loadUserData();
      notifyListeners();
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<firebase_auth.UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await loadUserData();
      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Google 로그인 에러: $e');
      throw Exception('Google 로그인에 실패했습니다.');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _userProvider.clearUser();
    notifyListeners();
  }

  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return '해당 이메일로 등록된 사용자가 없습니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      default:
        return '로그인에 실패했습니다: ${e.message}';
    }
  }

  Future<void> createUser(String email, String password, String name) async {
    try {
      firebase_auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);

        final newUser = User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          photoUrl: null,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toFirestore());

        await loadUserData();
        notifyListeners();
      }
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }
}
