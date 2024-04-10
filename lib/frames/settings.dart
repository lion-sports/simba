import 'package:flutter/material.dart';


class Settings  extends StatefulWidget {
  const Settings({super.key});
 @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                value: true, // Replace with your actual dark mode state
                onChanged: (value) {
                  // Add logic to toggle dark mode
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
              title:  const Text('Logout'),
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
