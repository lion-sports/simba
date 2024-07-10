import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/frames/auth/auth_signup.dart';
import 'package:lion_flutter/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginResponse {
  final String type;
  final String token;
  final DateTime expiresAt;

  LoginResponse(
      {required this.type, required this.token, required this.expiresAt});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      type: json['type'],
      token: json['token'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}

class MeResponse {
  final String email;
  final String firstname;
  final String lastname;
  final String solanaPublicKey;

  MeResponse(
      {required this.email,
      required this.firstname,
      required this.lastname,
      required this.solanaPublicKey});

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      solanaPublicKey: json['solanaPublicKey'],
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static String baseUrl = Global.api;

  Future<void> me(BuildContext context, String token) async {
    final response =
        await http.get(Uri.parse('$baseUrl/auth/me'), // Sostituisci con il tuo URL
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      MeResponse responseParsed = MeResponse.fromJson(responseBody);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('username', responseParsed.email);
      await prefs.setString('solanaPublicKey', responseParsed.solanaPublicKey);
      await prefs.setString('firstname', responseParsed.firstname);
      await Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'generateRefresh':
            'true', // Aggiungi questa linea se vuoi generare un token di refresh
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      LoginResponse responseParsed = LoginResponse.fromJson(responseBody);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseParsed.token);
      await me(context, responseParsed.token);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Incorrect credentials!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  "Please verify your user name and password and try again!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => login(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
      );
      log('Failed to login: ${response.body}');
      // Mostra un messaggio di errore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/static/lion.jpg', // Assicurati di avere un'immagine in questo percorso
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black54, // Semi-transparent overlay
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
