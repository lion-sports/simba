import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/frames/home/home.dart';
import 'package:lion_flutter/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardsInfo extends StatefulWidget {
  const RewardsInfo({super.key});

  @override
  State<RewardsInfo> createState() => _RewardsInfoState();
}

class _RewardsInfoState extends State<RewardsInfo> {
  static String baseUrl = Global.api;

  String solanaPublicKey = '';
  String token = '';
  int totalTokens = 0;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      solanaPublicKey =
          prefs.getString('solanaPublicKey') ?? 'solanaPublicKey-default';
      token = prefs.getString('token') ?? 'token-default';
      log("token");
      log(token);
      totalTokens = prefs.getInt('totalTokens') ??
          0; // Assuming you store totalTokens in prefs
    });
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://explorer.solana.com/address/${solanaPublicKey}/tokens?cluster=devnet');
    log("url");
    log(url.toString());
    if (!await launchUrl(url)) {
      throw Exception('Could not launch solana explorer at url: $url');
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
        title: const Text('Your info Rewards'),
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
                const Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome into your rewards token info!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'In this page you can see and consult your tokens.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          //color: Colors.blue.shade400,
                        ),
                      ),
                    ],
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
                  onPressed: () => _launchURL(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: const Color(0xFF358CC2),
                  ),
                  child: const Text(
                    'Solana explorer',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
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
