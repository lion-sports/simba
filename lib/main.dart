import 'package:flutter/material.dart';
//import 'package:lion_flutter/frames/auth/login.dart';
import 'package:lion_flutter/frames/home/home.dart';


// Future main() async {
  
//   runApp(LoginPage());
// }


void main() {
  runApp(const lionApp());
}

class lionApp extends StatelessWidget {
  const lionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lion App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const Home(title: 'Benvenuto in Lion'),
    );
  }
}