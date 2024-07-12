import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectDifficultyPage extends StatefulWidget {
  @override
  _SelectDifficultyPageState createState() => _SelectDifficultyPageState();
}

class _SelectDifficultyPageState extends State<SelectDifficultyPage> {
  String? _selectedLevel;
  final TextEditingController _pushUpsController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController();
  final TextEditingController _trainingTimeController = TextEditingController();

  Future<void> _saveDifficultyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('level', _selectedLevel ?? '');
    await prefs.setString('pushUps', _pushUpsController.text ?? '0');
    await prefs.setString('kcal', _kcalController.text ?? '0');
    await prefs.setString('trainingTime', _trainingTimeController.text);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Adjust the top padding
              const Text(
                'Set Your Fitness Goals',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Select your mission and set daily goals to stay fit and healthy.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 32),
              // _buildDropdown('Difficulty Level', ['Easy', 'Medium', 'Hard'], (String? newValue) {
              //   setState(() {
              //     _selectedLevel = newValue;
              //   });
              // }),
              const SizedBox(height: 16),
              _buildTextField('Daily Push-Ups/Pull-Ups/Squat Goal', _pushUpsController, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Daily Kcal Burn Goal', _kcalController, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Daily Training Time (mins)', _trainingTimeController, TextInputType.number),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveDifficultyData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Save & Continue'),
              ),
              const SizedBox(height: 50), // Adjust the bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDropdown(String label, List<String> items, ValueChanged<String?> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLevel,
          isDense: true,
          isExpanded: true,
          dropdownColor: Colors.black,
          iconEnabledColor: Colors.white,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
