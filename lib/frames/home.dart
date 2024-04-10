import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lion_flutter/frames/profile.dart';
import 'package:lion_flutter/frames/settings.dart';

class Home  extends StatefulWidget {
   const Home({super.key,required this.title});
   final String title;
   

 @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile(title: "Profile",)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Welcome, Filippo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 2.0,
              ),
              items: [
                Image.network(
                  '../static/img_1.jpg',
                  fit: BoxFit.cover,
                ),
                Image.network(
                  '../static/img_3.jpg',
                  fit: BoxFit.cover,
                ),
                Image.network(
                  '../static/img_5.jpg',
                  fit: BoxFit.cover,
                ),
              ],
            ),
           const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press for exercise or fitness routines
              },
              child: const Text('Start Exercise'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle button press for tracking progress
              },
              child: const Text('Track Progress'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle button press for meal plans or nutrition
              },
              child: const Text('Nutrition Plans'),
            ),
            // Add more buttons or features as needed
          ],
        ),
      ),
    );
  }
}
