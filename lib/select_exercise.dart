import 'package:flutter/material.dart';
import 'pose_detector_view.dart';

class ExerciseSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercise'),
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
                    builder: (context) => PoseDetectorView(exerciseType: 'pushup'),
                  ),
                );
              },
              child: Text('Push-ups'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoseDetectorView(exerciseType: 'squat'),
                  ),
                );
              },
              child: Text('Squats'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoseDetectorView(exerciseType: 'pullup'),
                  ),
                );
              },
              child: Text('Pull-ups'),
            ),
          ],
        ),
      ),
    );
  }
}
