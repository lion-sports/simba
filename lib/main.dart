import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lion_flutter/theme_notifier.dart';
import 'package:lion_flutter/frames/mission/mission_page.dart';
import 'package:lion_flutter/frames/auth/auth_login.dart';
import 'package:lion_flutter/frames/auth/auth_signup.dart';
import 'package:lion_flutter/frames/home/home.dart';
import 'package:lion_flutter/frames/profile/customize_profile_fitness.dart';
import 'package:lion_flutter/frames/profile/customize_profile_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final hasPersonalData = prefs.containsKey('birthdate') && prefs.containsKey('gender') && prefs.containsKey('height') && prefs.containsKey('weight');
  final hasDifficultyData = prefs.containsKey('level') && prefs.containsKey('pushUps') && prefs.containsKey('kcal') && prefs.containsKey('trainingTime');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: LionApp(token: token, hasPersonalData: hasPersonalData, hasDifficultyData: hasDifficultyData),
    ),
  );
}

class LionApp extends StatelessWidget {
  final String? token;
  final bool hasPersonalData;
  final bool hasDifficultyData;

  const LionApp({super.key, this.token, required this.hasPersonalData, required this.hasDifficultyData});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Lion App',
      theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: token == null 
          ? LoginPage() 
          : (hasPersonalData 
              ? (hasDifficultyData ? const Home(title: 'Home', selectedLevel: 'Easy') : SelectDifficultyPage()) 
              : CustomizeFitnessPage()),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => const Home(title: 'Home', selectedLevel: 'Easy'),
        '/customize_fitness': (context) => CustomizeFitnessPage(),
        '/selectDifficulty': (context) => SelectDifficultyPage(),
      },
    );
  }
}
