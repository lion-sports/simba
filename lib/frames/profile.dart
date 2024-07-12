import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lion_flutter/frames/auth/auth_signup.dart';
import 'package:lion_flutter/frames/rewards/rewards.dart';
import 'package:lion_flutter/frames/rewards/rewards_page_info.dart';
import 'package:lion_flutter/utility/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<Map<String, dynamic>> _items = [
    {'title': 'Daily Quests', 'icon': Icons.assignment, 'page': DailyQuests()},
    {
      'title': 'Check your Ranking',
      'icon': Icons.leaderboard,
      'page': Ranking()
    },
    {
      'title': 'Collect your Rewards',
      'icon': Icons.attach_money,
      'page': const RewardsInfo()
    },
    {
      'title': 'Refer a Friend',
      'icon': Icons.person_add,
      'page': ReferFriend()
    },
  ];

  final List<Map<String, dynamic>> _logOutitems = [
    {
      'title': 'Log out',
      'icon': Icons.logout,
    },
  ];

  String username = '';
  String solanaPublicKey = '';
  String firstName = '';
  String token = ''; 

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'username-default';
      solanaPublicKey =
          prefs.getString('solanaPublicKey') ?? 'solanaPublicKey-default';
    });
  }
  
  // String level = '';
  // String pushups = '';
  // String kcal = '';
  // String trainingTime = '';

  // String birthdate = '';
  // String gender = '';
  // String height = '';
  // String weight = '';

  // int exercisePushUpsCount = 0;
  // int exercisePushUpsCountTotal = 0;
  // int exerciseTime = 0;

  // int totalTokens = 0;

  Future<void> _logoutDialog() async {
    //final prefs = await SharedPreferences.getInstance();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'If you log out your fitness data will be lost.\n'
            'Do you want to logout?\n',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Logout'),
              onPressed: () {
                _logOut();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('solanaPublicKey');
    await prefs.remove('firstname');

    await prefs.remove('birthdate');
    await prefs.remove('gender');    
    await prefs.remove('height');    
    await prefs.remove('weight');    
    
    await prefs.remove('level');
    await prefs.remove('pushUps');    
    await prefs.remove('kcal');    
    await prefs.remove('trainingTime');

    await prefs.remove('exercisePushUpsCount');
    await prefs.remove('exercisePushUpsCountTotal');
    await prefs.remove('exerciseTime');
    await prefs.remove('lastReset');
    
    await prefs.remove('totalTokens');    
    
    Navigator.pushReplacementNamed(context, '/login');
  }
    
  // }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/static/img_1.jpg',
      'assets/static/img_2.jpg',
      'assets/static/img_3.jpg',
      'assets/static/img_4.jpg',
      'assets/static/img_5.jpg',
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Profile'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/static/img_3.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                          //Colors.blue.withOpacity(0.6),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/static/img_2.jpg'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${username}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _items.map((item) {
                        return ListTile(
                          leading: Icon(item['icon']),
                          title: Text(item['title']),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => item['page']),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'My Photos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _logOutitems.map((item) {
                        return ListTile(
                          leading: Icon(item['icon']),
                          title: Text(item['title']),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _logoutDialog(),
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => item['page']),
                          //   );
                          // },
                        );
                      }).toList(),
                    ),
                    // const SizedBox(height: 16),
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: _logoutDialog,
                    //     child: const Text('Logout'),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.red,
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 40, vertical: 20),
                    //       textStyle: const TextStyle(
                    //           fontSize: 18, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class DailyQuests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quests'),
      ),
      body: const Center(
        child: Text('Daily Quests Page'),
      ),
    );
  }
}

class Ranking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check your Ranking'),
      ),
      body: const Center(
        child: Text('Check your Ranking Page'),
      ),
    );
  }
}

class ReferFriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer a Friend'),
      ),
      body: const Center(
        child: Text('Refer a Friend Page'),
      ),
    );
  }
}
