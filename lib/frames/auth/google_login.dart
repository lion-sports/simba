import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lion_flutter/components/navigator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginGoogle extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // L'utente ha annullato l'accesso
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String idToken = googleAuth.idToken!;
      final String accessToken = googleAuth.accessToken!;

      // Invia il token ID al backend
      final response = await _sendTokenToBackend(idToken);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        log('User authenticated successfully: ${responseBody['user']}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigatorPage()), // NavigatorPage() è la tua home page dopo il login
        );
      } else {
        log('Failed to authenticate user: ${response.body}');
      }
    } catch (error) {
      log('Error during Google Sign-In: $error');
    }
  }

  Future<http.Response> _sendTokenToBackend(String idToken) async {
    final url = Uri.parse('http://192.168.1.92:3333/auth/loginWithIosGoogleToken');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': idToken,
      }),
    );
    return response;
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
