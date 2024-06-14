import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lion_flutter/theme_notifier.dart';
import 'package:lion_flutter/frames/auth/googleLogin.dart';
import 'package:lion_flutter/frames/home/home.dart';
import 'package:lion_flutter/frames/settings.dart';
import 'package:lion_flutter/frames/profile.dart';



class Settings extends StatefulWidget {
  final String selectedLevelSettings;
  const Settings({super.key, required this.selectedLevelSettings});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the selected index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(title: 'Home', selectedLevel: widget.selectedLevelSettings),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginGoogle(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(selectedLevelSettings: widget.selectedLevelSettings),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(title: 'Profile'),
        ),
      );
    }
  }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Settings'),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Theme.of(context).textTheme.headlineLarge?.color),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center, color:  Theme.of(context).textTheme.headlineLarge?.color),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Theme.of(context).textTheme.headlineLarge?.color),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Theme.of(context).textTheme.headlineLarge?.color,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeNotifier.isDarkMode,
                onChanged: (value) {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            ListTile(
              title: const Text('Notification Preferences'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation to notification preferences page
              },
            ),
            const Divider(),
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation to change password page
              },
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Add logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
