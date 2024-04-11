import 'package:flutter/material.dart';
import 'package:lion_flutter/frames/settings.dart';
import 'package:lion_flutter/frames/home/home.dart';
import 'package:lion_flutter/frames/profile.dart';

class CustomDrawer  extends StatefulWidget {
  const CustomDrawer({super.key});

 @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 187, 224, 255),
                image: DecorationImage(
                  image: AssetImage("../static/logo.jpg"),
                     fit: BoxFit.cover)
              ),
              child: Text(
                'Lion Sports',
                style: TextStyle(
                  color: Colors.white,
                  
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Home(title: "Lion"),
                  ),
                );// Handle home page navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Profile(title: "Filippo"),
                  ),
                );// Handle home page navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );// Handle home page navigation
              }
            )
          ],
        ),
      );
  }
}