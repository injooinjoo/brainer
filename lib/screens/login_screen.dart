import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_button.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.of(context).pushReplacementNamed('/');
      } on FirebaseAuthException catch (e) {
        String message = '로그인에 실패했습니다.';
        if (e.code == 'user-not-found') {
          message = '해당 이메일로 등록된 사용자가 없습니다.';
        } else if (e.code == 'wrong-password') {
          message = '잘못된 비밀번호입니다.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 사용자가 로그인을 취소한 경우

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      print('Google 로그인 에러: $e'); // 에러 로깅
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google 로그인에 실패했습니다: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: '이메일'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: '비밀번호'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                          text: '로그인',
                          onPressed: _submitForm,
                        ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('또는',
                textAlign: TextAlign.center, style: AppTheme.captionStyle),
            SizedBox(height: 20),
            CustomButton(
              text: 'Google로 로그인',
              onPressed: _signInWithGoogle,
              isPrimary: false,
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              },
              child: Text('계정이 없으신가요? 회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
