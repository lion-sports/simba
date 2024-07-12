import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lion_flutter/pose_detector_view.dart';

class CountdownShowDialog extends StatefulWidget {
  final String exerciseType;

  const CountdownShowDialog({Key? key, required this.exerciseType}) : super(key: key);

  @override
  _CountdownShowDialogState createState() => _CountdownShowDialogState();
}

class _CountdownShowDialogState extends State<CountdownShowDialog> {
  int _counter = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer?.cancel();
          _navigateToPoseDetector();
        }
      });
    });
  }

  void _navigateToPoseDetector() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoseDetectorView(exerciseType: widget.exerciseType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          '$_counter',
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
