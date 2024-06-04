import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
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
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  // Variables for exercise counting
  int _count = 0;
  bool _isInDownPosition = false;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Detector'),
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
            child: Text(
              'Count: $_count',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
      // tengo traccia delle spalle, gomiti, polsi dx e sx
      final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
      final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
      final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
      final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
      final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
      final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

      if (leftShoulder != null && rightShoulder != null && leftElbow != null && rightElbow != null && leftWrist != null && rightWrist != null) {
        final leftElbowAngle = calculateAngle(leftShoulder, leftElbow, leftWrist);
        final rightElbowAngle = calculateAngle(rightShoulder, rightElbow, rightWrist);

        // Usa gli angoli per determinare la posizione
        // < 90 bosizione "in basso"
        if (!_isInDownPosition && leftElbowAngle < 90 && rightElbowAngle < 90) {
          _isInDownPosition = true;
          // > 160 posizione "in alto"
        } else if (_isInDownPosition && leftElbowAngle > 160 && rightElbowAngle > 160) {
          _count++;
          _isInDownPosition = false;
        }
      }
    }
  }

  double calculateAngle(PoseLandmark firstLandmark, PoseLandmark midLandmark, PoseLandmark lastLandmark) {
    //caldolo l'angono in radianti
    double radians = math.atan2(lastLandmark.y - midLandmark.y, lastLandmark.x - midLandmark.x) -
        math.atan2(firstLandmark.y - midLandmark.y, firstLandmark.x - midLandmark.x);

    //l'angono in radianti viene convertito in gradi
    double degrees = radians * 180.0 / math.pi;
    degrees = degrees.abs();
    //se l'angolo è > 180
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
