import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lion_flutter/frames/profile/customize_profile_fitness.dart';

class SettingsExercise extends StatefulWidget {
  const SettingsExercise({Key? key}) : super(key: key);

  @override
  _SettingsExerciseState createState() => _SettingsExerciseState();
}

class _SettingsExerciseState extends State<SettingsExercise> {
  String birthdate = '';
  String gender = '';
  String height = '';
  String weight = '';
  String pushUpsGoal = '';
  int pushUpsGoalInt = 0;
  String kcalGoal = '';
  String trainingTimeGoal = '';
  int pushUpsCount = 0;
  int exerciseTime = 0;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      birthdate = prefs.getString('birthdate') ?? 'Unknown';
      gender = prefs.getString('gender') ?? 'Unknown';
      height = prefs.getString('height') ?? 'Unknown';
      weight = prefs.getString('weight') ?? 'Unknown';
      pushUpsGoal = prefs.getString('pushUps') ?? '0';
      kcalGoal = prefs.getString('kcal') ?? '0';
      trainingTimeGoal = prefs.getString('trainingTime') ?? '0';
      pushUpsCount = prefs.getInt('exercisePushUpsCountTotal') ?? 0;
      exerciseTime = prefs.getInt('exerciseTime') ?? 0;
    });
  }

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadData();
  }

  int _parseStringToInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0; // Default value if parsing fails
    }
  }

  int _calculateKcal(int minutes, int weight) {
    const double MET = 3.5;
    const double pushUpsMET = 8.0;
    return ((pushUpsMET * weight * minutes) / 200).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomizeFitnessPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Activity',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildActivitySummary(),
              const SizedBox(height: 16),
              const Text(
                'Your daily goals',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'When you complete your daily goals you will see a green circle.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 16),
              _buildDailyGoals(),
              const SizedBox(height: 16),
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildPersonalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Your health has increased 5% faster than yesterday, keep it up!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularChart('Push Ups', pushUpsCount, _parseStringToInt(pushUpsGoal)),
                _buildCircularChart('Exercise Time', exerciseTime, _parseStringToInt(trainingTimeGoal)),
                _buildCircularChart('Kcal', _calculateKcal(exerciseTime, _parseStringToInt(weight)), _parseStringToInt(kcalGoal)), // Placeholder for Kcal
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularChart(String title, int achieved, int goal) {
    double progress = (goal > 0) ? achieved / goal : 0;
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Center(
                child: Text(
                  '${achieved}/${goal}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildDailyGoals() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildGoalIndicator('Sun'),
            _buildGoalIndicator('Mon'),
            _buildGoalIndicator('Tue'),
            _buildGoalIndicator('Wed'),
            _buildGoalIndicator('Thu'),
            _buildGoalIndicator('Fri'),
            _buildGoalIndicator('Sat'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalIndicator(String day) {
    if(pushUpsCount == _parseStringToInt(pushUpsGoal) && exerciseTime == _parseStringToInt(trainingTimeGoal)) {
      return Column(
        children: [
          const Icon(Icons.circle, color: Colors.green),
          const SizedBox(height: 4),
          Text(day),
        ],
      );
    }
    else{
      return Column(
        children: [
          const Icon(Icons.circle, color: Colors.orange),
          const SizedBox(height: 4),
          Text(day),
        ],
      );
    }
  }

  Widget _buildPersonalInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Age', birthdate),
            const Divider(),
            _buildInfoRow('Gender', gender),
            const Divider(),
            _buildInfoRow('Height', height),
            const Divider(),
            _buildInfoRow('Weight', weight),
            const Divider(),
            _buildInfoRow('Daily Push-Ups Goal', pushUpsGoal),
            const Divider(),
            _buildInfoRow('Daily Kcal Burn Goal', kcalGoal),
            const Divider(),
            _buildInfoRow('Daily Training Time', trainingTimeGoal),
            const Divider(),
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Clear All Data',
                style: TextStyle(color: Colors.white),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
