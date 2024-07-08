import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/frames/auth/auth_signup.dart';
import 'package:lion_flutter/utility/global.dart';

class Response {
  final String type;
  final String token;
  final String email;
  final String firstname;
  final String lastname;
  final String solanaPublicKey;
  final DateTime expiresAt;

  Response({
    required this.type,
    required this.token,
    required this.expiresAt,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.solanaPublicKey
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      type: json['type'],
      token: json['token'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      solanaPublicKey: json['solanaPublicKey'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static String baseUrl = Global.api;
   
  Future<void> _login(BuildContext context) async {
      print(context);

    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('${baseUrl}auth/loginFromApp'), // Sostituisci con il tuo URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'generateRefresh': 'true', // Aggiungi questa linea se vuoi generare un token di refresh
      }),
    );

    if (response.statusCode == 200) {
      final  Map<String, dynamic>  responseBody = json.decode(response.body);
      Response responseParsed = Response.fromJson(responseBody);
      Navigator.pushReplacementNamed(context, '/home');

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
                    onPressed: () => _login(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
      );
      print('Failed to login: ${response.body}');
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
            'assets/static/img_3.jpg', // Assicurati di avere un'immagine in questo percorso
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
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
