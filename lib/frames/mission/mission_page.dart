import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lion_flutter/frames/home/home.dart';

class MissionPage extends StatefulWidget {
  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> levels = ['Easy', 'Normal', 'Hard'];
  final List<String> images = [
    'assets/static/img_1.jpg',
    'assets/static/img_6.jpg',
    'assets/static/img_5.jpg'
  ];

  void _onLevelSelected() {
    String selectedLevel = levels[_current];
    log(selectedLevel);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          title: 'Home',
          selectedLevel: selectedLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            items: images.map((image) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Push Yourself Harder to',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Become ${levels[_current]}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _controller.previousPage();
                  },
                ),
                ElevatedButton(
                  onPressed: _onLevelSelected,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Select Level'),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    _controller.nextPage();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: levels.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: (Theme.of(context).brightness == Brightness.dark
                    //           ? Colors.white
                    //           : Colors.black)
                    //       .withOpacity(_current == entry.key ? 0.9 : 0.4),
                    // ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
