// lib/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brainer_flutter/providers/user_provider.dart';
import 'package:brainer_flutter/models/user.dart' as app_user;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter_config/flutter_config.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserProvider _userProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late final AadOAuth _aadOAuth;

  AuthProvider({required UserProvider userProvider})
      : _userProvider = userProvider {
    _initializeUser();
    _initializeAadOAuth();
  }

  void _initializeAadOAuth() {
    final Config config = Config(
      tenant: FlutterConfig.get('MICROSOFT_TENANT_ID') ?? '',
      clientId: FlutterConfig.get('MICROSOFT_CLIENT_ID') ?? '',
      scope: 'openid profile email',
      redirectUri: FlutterConfig.get('MICROSOFT_REDIRECT_URI') ?? '',
    );
    _aadOAuth = AadOAuth(config);
  }

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  app_user.User? get user => _userProvider.user;

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
            final user = app_user.User.fromFirestore(userDoc);
            await _userProvider.updateUser(user);
            print('User data loaded successfully');
          } else {
            final newUser = app_user.User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName ?? 'Anonymous',
              email: firebaseUser.email ?? '',
              photoUrl: firebaseUser.photoURL,
              displayName: firebaseUser.displayName ?? 'Anonymous', // 추가된 부분
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

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await loadUserData();
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
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

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await _auth.signInWithCredential(credential);
        await loadUserData();
        notifyListeners();
        return userCredential;
      } else {
        throw Exception('Facebook 로그인이 취소되었습니다.');
      }
    } catch (e) {
      print('Facebook 로그인 에러: $e');
      throw Exception('Facebook 로그인에 실패했습니다.');
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      await loadUserData();
      notifyListeners();
      return userCredential;
    } catch (e) {
      print('Apple 로그인 에러: $e');
      throw Exception('Apple 로그인에 실패했습니다.');
    }
  }

  Future<UserCredential?> signInWithGitHub(BuildContext context) async {
    try {
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: FlutterConfig.get('GITHUB_CLIENT_ID') ?? '',
        clientSecret: FlutterConfig.get('GITHUB_CLIENT_SECRET') ?? '',
        redirectUrl: FlutterConfig.get('GITHUB_REDIRECT_URL') ?? '',
      );
      final result = await gitHubSignIn.signIn(context);
      if (result.status == GitHubSignInResultStatus.ok) {
        final githubAuthCredential =
            GithubAuthProvider.credential(result.token!);
        final userCredential =
            await _auth.signInWithCredential(githubAuthCredential);
        await loadUserData();
        notifyListeners();
        return userCredential;
      } else {
        throw Exception('GitHub 로그인이 취소되었습니다.');
      }
    } catch (e) {
      print('GitHub 로그인 에러: $e');
      throw Exception('GitHub 로그인에 실패했습니다.');
    }
  }

  Future<UserCredential?> signInWithMicrosoft() async {
    try {
      await _aadOAuth.login();
      String? accessToken = await _aadOAuth.getAccessToken();

      if (accessToken != null) {
        final OAuthCredential credential =
            OAuthProvider('microsoft.com').credential(
          accessToken: accessToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        await loadUserData();
        notifyListeners();
        return userCredential;
      } else {
        throw Exception('액세스 토큰을 받지 못했습니다.');
      }
    } catch (e) {
      print('Microsoft 로그인 에러: $e');
      throw Exception('Microsoft 로그인에 실패했습니다.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _aadOAuth.logout(); // Microsoft 로그아웃
      _userProvider.clearUser();
      notifyListeners();
    } catch (e) {
      print('로그아웃 에러: $e');
      throw Exception('로그아웃에 실패했습니다.');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);

        final newUser = app_user.User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          photoUrl: null,
          displayName: name, // 추가된 부분
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

  Future<String> uploadFile(File file) async {
    try {
      if (currentUser == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          _storage.ref().child('user_files/${currentUser!.uid}/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'files': FieldValue.arrayUnion([
          {
            'name': fileName,
            'url': downloadUrl,
            'uploadDate': FieldValue.serverTimestamp(),
          }
        ])
      });

      return downloadUrl;
    } catch (e) {
      print('파일 업로드 에러: $e');
      throw Exception('파일 업로드에 실패했습니다.');
    }
  }

  Future<List<Map<String, dynamic>>> getUserFiles() async {
    try {
      if (currentUser == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      List<dynamic> files = userDoc.get('files') ?? [];

      return List<Map<String, dynamic>>.from(files);
    } catch (e) {
      print('사용자 파일 조회 에러: $e');
      throw Exception('사용자 파일 조회에 실패했습니다.');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      if (currentUser == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      await _storage.refFromURL(fileUrl).delete();

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'files': FieldValue.arrayRemove([
          {
            'url': fileUrl,
          }
        ])
      });

      notifyListeners();
    } catch (e) {
      print('파일 삭제 에러: $e');
      throw Exception('파일 삭제에 실패했습니다.');
    }
  }

  Future<void> updateUserProfile(String name, String email) async {
    try {
      if (currentUser == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      await currentUser!.updateDisplayName(name);
      await currentUser!.updateEmail(email);

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'name': name,
        'email': email,
        'displayName': name, // 추가된 부분
      });

      await loadUserData();
      notifyListeners();
    } catch (e) {
      print('프로필 업데이트 에러: $e');
      throw Exception('프로필 업데이트에 실패했습니다.');
    }
  }
}
