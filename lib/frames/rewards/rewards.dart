import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/frames/auth/auth_signup.dart';
import 'package:lion_flutter/frames/home/home.dart';
import 'package:lion_flutter/frames/profile.dart';
import 'package:lion_flutter/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  late String selectedLevel;
  static String baseUrl = Global.api;

  String solanaPublicKey = '';
  String token = '';

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      solanaPublicKey =
          prefs.getString('solanaPublicKey') ?? 'solanaPublicKey-default';
      token = prefs.getString('token') ?? 'token-default';
    });
  }

  Future<void> reward(BuildContext context) async {
    final response = await http.post(
        Uri.parse('$baseUrl/solana/reward'), // Sostituisci con il tuo URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'solanaPublicKey': solanaPublicKey,
        }));

    if (response.statusCode == 200) {
      await Navigator.pushReplacementNamed(context, '/home');
    } else {
      log(response.statusCode.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Rewards'),
        ),
        body: Stack(
          children: [
            const Center(child: Text('Collect your Rewards Page')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Home(
                            title: 'Home',
                            selectedLevel: 'Easy',
                          )),
                ); // Go back to the previous page
              },
              child: const Text("Go back to home"),
            ),
            ElevatedButton(
              onPressed: () => reward(context),
              child: const Text("Get you 10 Token"),
            ),
          ],
        ));
  }
}
