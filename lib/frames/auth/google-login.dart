import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lion_flutter/components/navigator.dart';

class LoginGoogle extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _handleSignIn(BuildContext context) async {
    try {      
      await googleSignIn.signIn();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavigatorPage()),
      );
    } catch (error) {
      print('Google Sign-In Error: $error');
      // Handle sign-in error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Google'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: const Text('Login with Google'),
        ),
      ),
    );
  }
}
