import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:async';
import 'dart:math' as math;
import 'detector_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  final String exerciseType;

  const PoseDetectorView({Key? key, required this.exerciseType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = false; // Initially false to prevent processing before countdown
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  // Variables for exercise counting
  int _count = 0;
  bool _isInDownPosition = false;
  late Stopwatch _stopwatch;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCountdownDialog());
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _showCountdownDialog() {
    _startExercise();
    // int countdown = 3;

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(
    //       builder: (BuildContext statefulBuilderContext, StateSetter setState) {
    //         _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //           if (countdown == 1) {
    //             log(context);
    //             Navigator.of(statefulBuilderContext).pop(true);
    //             timer.cancel();
    //             _startExercise();
    //           } else {
    //             setState(() {
    //               countdown--;
    //             });
    //           }
    //         });
    //         return AlertDialog(
    //           title: Text("Get Ready!", textAlign: TextAlign.center),
    //           content: Text(
    //             "$countdown",
    //             style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    //             textAlign: TextAlign.center,
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }

  void _startExercise() {
    setState(() {
      _canProcess = true;
    });
    _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Detector'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          DetectorView(
            title: 'Pose Detector',
            customPaint: _customPaint,
            text: _text,
            onImage: _processImage,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Count: $_count',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Text(
                  'Time: ${_stopwatch.elapsed.inSeconds}s',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);

      // Count exercises
      if (widget.exerciseType == 'pushup') {
        _countPushUps(poses);
      } else if (widget.exerciseType == 'squat') {
        _countSquats(poses);
      } else if (widget.exerciseType == 'pullup') {
        _countPullUps(poses);
      }
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _countPushUps(List<Pose> poses) {
    for (Pose pose in poses) {
      // Keep track of shoulders, elbows, and wrists for both left and right
      final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
      final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
      final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
      final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
      final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
      final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

      if (leftShoulder != null && rightShoulder != null && leftElbow != null && rightElbow != null && leftWrist != null && rightWrist != null) {
        final leftElbowAngle = calculateAngle(leftShoulder, leftElbow, leftWrist);
        final rightElbowAngle = calculateAngle(rightShoulder, rightElbow, rightWrist);

        // Use angles to determine position
        if (!_isInDownPosition && leftElbowAngle < 90 && rightElbowAngle < 90) {
          _isInDownPosition = true;
        } else if (_isInDownPosition && leftElbowAngle > 160 && rightElbowAngle > 160) {
          _count++;
          _isInDownPosition = false;
        }
        if (_count == 5) {
          _showSuccessDialog();
        }
      }
    }
  }

  void _showSuccessDialog() {
    _stopwatch.stop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Good Job!"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("You completed 5 pushups!"),
              Text("Exercise: ${widget.exerciseType}"),
              Text("Time: ${_stopwatch.elapsed.inSeconds}s"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous page
              },
              child: const  Text("OK"),
            ),
          ],
        );
      },
    );
  }

  double calculateAngle(PoseLandmark firstLandmark, PoseLandmark midLandmark, PoseLandmark lastLandmark) {
    // Calculate angle in radians
    double radians = math.atan2(lastLandmark.y - midLandmark.y, lastLandmark.x - midLandmark.x) -
        math.atan2(firstLandmark.y - midLandmark.y, firstLandmark.x - midLandmark.x);

    // Convert radians to degrees
    double degrees = radians * 180.0 / math.pi;
    degrees = degrees.abs();
    if (degrees > 180.0) {
      degrees = 360.0 - degrees;
    }
    return degrees;
  }

  void _countSquats(List<Pose> poses) {
    // Implement squat counting logic here
  }

  void _countPullUps(List<Pose> poses) {
    // Implement pull-up counting logic here
  }
}
