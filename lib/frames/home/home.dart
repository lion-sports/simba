import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lion_flutter/frames/profile.dart';
import 'package:lion_flutter/frames/settings.dart';
import 'package:lion_flutter/pose_detector_view.dart';
import 'package:lion_flutter/frames/auth/auth_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String selectedLevel;

  const Home({super.key, required this.title, required this.selectedLevel});
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late String selectedLevel;
  String selectedFilter = 'All';

  String username = '';
  String firstname = '';
  String solanaPublicKey = '';

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'username-default';
      firstname = prefs.getString('firstname') ?? 'firstname-default';
      solanaPublicKey =
          prefs.getString('solanaPublicKey') ?? 'solanaPublicKey-default';
    });
  }

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.selectedLevel;
    _loadUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the selected index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Home(title: 'Home', selectedLevel: selectedLevel),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(selectedLevelSettings: selectedLevel),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Profile(title: 'Profile'),
        ),
      );
    }
  }

  void _onLevelSelected(String level) {
    setState(() {
      selectedLevel = level;
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  Color _getSelectedColor() {
    if (selectedLevel == 'Easy') {
      return const Color.fromARGB(255, 130, 192, 132);
    } else if (selectedLevel == 'Normal') {
      return const Color.fromARGB(255, 73, 118, 155);
    } else {
      return const Color.fromARGB(255, 108, 10, 2);
    }
  }

  List<ExerciseCard> _getExerciseCards() {
    Color color = _getSelectedColor();

    List<ExerciseCard> allCards = [
      ExerciseCard(
        title: 'Push Up',
        subtitle: 'Muscle Building',
        image: 'assets/images/pushups.jpg',
        color: const Color.fromRGBO(189, 211, 68, 1),
        progress: '72%',
        difficulty: selectedLevel,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PoseDetectorView(exerciseType: 'pushup'),
            ),
          );
        },
      ),
      ExerciseCard(
        title: 'Pull Up',
        subtitle: 'Upper body',
        image: 'assets/images/yoga.png',
        color: const Color.fromRGBO(44, 141, 130, 1),
        progress: 'Beginner',
        difficulty: selectedLevel,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PoseDetectorView(exerciseType: 'pullup'),
            ),
          );
        },
      ),
      ExerciseCard(
        title: 'Squat',
        subtitle: 'Leg',
        image: 'assets/images/upper_body.png',
        color: const Color.fromRGBO(219, 155, 49, 1),
        progress: 'Intermediate',
        difficulty: selectedLevel,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PoseDetectorView(exerciseType: 'squat'),
            ),
          );
        },
      ),
    ];

    if (selectedFilter == 'All') {
      return allCards;
    } else {
      return allCards
          .where((card) =>
              card.title.toLowerCase() == selectedFilter.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = _getSelectedColor();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: Theme.of(context).textTheme.headlineLarge?.color),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center,
                color: Theme.of(context).textTheme.headlineLarge?.color),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
                color: Theme.of(context).textTheme.headlineLarge?.color),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Theme.of(context).textTheme.headlineLarge?.color,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                  child: Text(
                    'Welcome $firstname on Lion Sport',
                    style: TextStyle(
                        fontSize: 20,
                        color:
                            Theme.of(context).textTheme.headlineLarge?.color),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.account_circle,
                      color: Theme.of(context).iconTheme.color, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(title: 'Profile'),
                      ),
                    );
                  },
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Your solana public key is $solanaPublicKey',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.headlineLarge?.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // CarouselSlider(
              //   options: CarouselOptions(
              //     height: 200.0,
              //     enlargeCenterPage: true,
              //     autoPlay: true,
              //     aspectRatio: 2.0,
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
              //     viewportFraction: 0.8,
              //   ),
              //   items: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 const PoseDetectorView(exerciseType: 'pushup'),
              //           ),
              //         );
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(15),
              //           image: const DecorationImage(
              //             image: AssetImage('assets/static/img_1.jpg'),
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 const PoseDetectorView(exerciseType: 'pushup'),
              //           ),
              //         );
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(15),
              //           image: const DecorationImage(
              //             image: AssetImage('assets/static/img_3.jpg'),
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 const PoseDetectorView(exerciseType: 'pushup'),
              //           ),
              //         );
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(15),
              //           image: const DecorationImage(
              //             image: AssetImage('assets/static/img_5.jpg'),
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Text(
                'Choose your exercises',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilterChip(
                    label: const Text('All',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                    selectedColor: selectedColor,
                    selected: selectedFilter == 'All',
                    onSelected: (bool value) {
                      _onFilterSelected('All');
                    },
                  ),
                  FilterChip(
                    label: const Text('Push Up',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                    selectedColor: selectedColor,
                    selected: selectedFilter == 'Push Up',
                    onSelected: (bool value) {
                      _onFilterSelected('Push Up');
                    },
                  ),
                  FilterChip(
                    label: const Text('Pull Up',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                    selectedColor: selectedColor,
                    selected: selectedFilter == 'Pull Up',
                    onSelected: (bool value) {
                      _onFilterSelected('Pull Up');
                    },
                  ),
                  FilterChip(
                    label: const Text('Squat',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                    selectedColor: selectedColor,
                    selected: selectedFilter == 'Squat',
                    onSelected: (bool value) {
                      _onFilterSelected('Squat');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: _getExerciseCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Color color;
  final String progress;
  final String difficulty;
  final VoidCallback onPressed;

  const ExerciseCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
    required this.progress,
    required this.difficulty,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(color.withOpacity(0.5), BlendMode.darken),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      progress,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      difficulty,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
