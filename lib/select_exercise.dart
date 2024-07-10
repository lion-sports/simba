import 'package:flutter/material.dart';
import 'pose_detector_view.dart';

class ExerciseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercise'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const  PoseDetectorView(exerciseType: 'pushup'),
                  ),
                );
              },
              child: const Text('Push-ups'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PoseDetectorView(exerciseType: 'squat'),
                  ),
                );
              },
              child: const Text('Squats'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const  PoseDetectorView(exerciseType: 'pullup'),
                  ),
                );
              },
              child: const Text('Pull-ups'),
            ),
          ],
        ),
      ),
    );
  }
}
