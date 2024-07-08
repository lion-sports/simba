import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lion_flutter/theme_notifier.dart';
import 'package:lion_flutter/frames/mission/mission_page.dart';
import 'package:lion_flutter/frames/auth/auth_login.dart';
import 'package:lion_flutter/frames/auth/auth_signup.dart';
import 'package:lion_flutter/frames/home/home.dart';


//import 'package:lion_flutter/frames/auth/login.dart';



// Future main() async {
  
//   runApp(LoginPage());
// }

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const LionApp(),
    ),
  );
}

class LionApp extends StatelessWidget {
  const LionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Lion App',
      theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => MissionPage(),
      },
    );
  }
}
