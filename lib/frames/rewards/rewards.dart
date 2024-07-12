import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/frames/home/home.dart';
import 'package:lion_flutter/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  static String baseUrl = Global.api;

  String solanaPublicKey = '';
  String token = '';
  int totalTokens = 0;

  bool isActiveAnimation = false;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      solanaPublicKey =
          prefs.getString('solanaPublicKey') ?? 'solanaPublicKey-default';
      token = prefs.getString('token') ?? 'token-default';
      totalTokens = prefs.getInt('totalTokens') ?? 0; // Assuming you store totalTokens in prefs
    });
  }

  Future<void> reward(BuildContext context) async {
    setState(() {
      isActiveAnimation = true;
    });
    
    final response = await http.post(
        Uri.parse('$baseUrl/solana/reward'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'solanaPublicKey': solanaPublicKey,
        }
      )
    );

    if (response.statusCode == 200) {
      setState(() {
        isActiveAnimation = false;
        totalTokens += 10; // Assuming each reward gives 10 tokens
      });

      // Save updated token count to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('totalTokens', totalTokens);

      await Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        isActiveAnimation = false;
      });
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isActiveAnimation) ...[
                  Center(
                    child: Lottie.asset('assets/animations/loading_animation.json'),
                  ),
                ] else ...[
                  Card(
                    //color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Congratulations!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'You have earned rewards for your workouts.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              //color: Colors.blue.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    //color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: const Icon(Icons.account_balance_wallet,
                          color: Colors.blue),
                      title: const Text('Total Tokens'),
                      subtitle: Text(totalTokens.toString(),
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    //color: Colors.white.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_balance, color: Colors.green),
                      title: const Text('Solana Public Key'),
                      subtitle: Text(solanaPublicKey),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => reward(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: const Color(0xFF358CC2),
                    ),
                    child: const Text(
                      'Claim Your 10 Tokens',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Home(
                                  title: 'Home',
                                  selectedLevel: 'Easy',
                                )),
                      );
                    },
                    
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
