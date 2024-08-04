import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSignInButton(
                  context,
                  ButtonType.google,
                  () => _signInWithSocialMedia(
                      context, context.read<AuthProvider>().signInWithGoogle),
                ),
                SizedBox(height: 16),
                _buildSignInButton(
                  context,
                  ButtonType.facebook,
                  () => _signInWithSocialMedia(
                      context, context.read<AuthProvider>().signInWithFacebook),
                ),
                SizedBox(height: 16),
                _buildSignInButton(
                  context,
                  ButtonType.apple,
                  () => _signInWithSocialMedia(
                      context, context.read<AuthProvider>().signInWithApple),
                ),
                SizedBox(height: 16),
                _buildSignInButton(
                  context,
                  ButtonType.github,
                  () => _signInWithSocialMedia(
                      context,
                      () => context
                          .read<AuthProvider>()
                          .signInWithGitHub(context)),
                ),
                SizedBox(height: 16),
                _buildSignInButton(
                  context,
                  ButtonType.microsoft,
                  () => _signInWithSocialMedia(context,
                      context.read<AuthProvider>().signInWithMicrosoft),
                ),
                SizedBox(height: 32),
                _buildSignUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(
      BuildContext context, ButtonType buttonType, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: SignInButton(
        buttonType: buttonType,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Sign Up functionality not implemented yet')),
          );
        },
        child: Text('Sign Up'),
      ),
    );
  }

  Future<void> _signInWithSocialMedia(
      BuildContext context, Future<dynamic> Function() signInMethod) async {
    try {
      final result = await signInMethod();
      if (result != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
