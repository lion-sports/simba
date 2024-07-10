import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      solanaPublicKey: json['lastname'],
    );
  }
}

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static String baseUrl = Global.api;

  Future<void> me(BuildContext context, String token) async {
    final response = await http
        .get(Uri.parse('$baseUrl/auth/me'), // Sostituisci con il tuo URL
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
      await Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _signUp(BuildContext context) async {
    final name = _nameController.text;
    final lastname = _cognomeController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'), // Sostituisci con il tuo URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstname': name,
        'lastname': lastname,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {  

      await Navigator.pushReplacementNamed(context, '/login');
    } else {
      log('Failed to sign-up: ${response.body}');
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
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
                  controller: _cognomeController,
                  decoration: InputDecoration(
                    hintText: 'Last name',
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
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
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
                  onPressed: () => _signUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Already have an account? Login',
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
