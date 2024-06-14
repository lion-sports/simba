import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/components/navigator.dart';
import 'package:lion_flutter/services/auth/auth.service.dart';

class LoginGoogle extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  _handleSignIn() async {
    print("sono dentro handleSignIn()");
    var result =  AuthService.signupGoogle();
    print("dentro googleLogin: " + result.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Google'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(),
          child: const Text('Login with Google'),
        ),
      ),
    );
  }
}
