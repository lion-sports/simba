import 'package:flutter/material.dart';

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
      'page': Rewards()
    },
    {
      'title': 'Refer a Friend',
      'icon': Icons.person_add,
      'page': ReferFriend()
    },
  ];

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
              title: const Text('Filippo Passalacqua'),
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
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
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
                    const Text(
                      'Basketball player',
                      style: TextStyle(
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
        title: Text('Daily Quests'),
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
        title: Text('Check your Ranking'),
      ),
      body: const Center(
        child: Text('Check your Ranking Page'),
      ),
    );
  }
}

class Rewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collect your Rewards'),
      ),
      body: const Center(
        child: Text('Collect your Rewards Page'),
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
