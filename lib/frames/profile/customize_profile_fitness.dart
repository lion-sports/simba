import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lion_flutter/frames/profile/customize_profile_level.dart';

class CustomizeFitnessPage extends StatefulWidget {
  @override
  _CustomizeFitnessPageState createState() => _CustomizeFitnessPageState();
}

class _CustomizeFitnessPageState extends State<CustomizeFitnessPage> {
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _selectedGender;

  Future<void> _savePersonalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthdate', _birthdateController.text);
    await prefs.setString('gender', _selectedGender ?? '');
    await prefs.setString('height', _heightController.text);
    await prefs.setString('weight', _weightController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SelectDifficultyPage()),
    );
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
                'Customize your fitness data',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This information ensures that your Fitness and Health data is as accurate as possible.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildTextField('Age', _birthdateController, TextInputType.datetime),
              const SizedBox(height: 16),
              _buildDropdown('Gender', ['Male', 'Female'], (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              }),
              const SizedBox(height: 16),
              _buildTextField('Height (cm)', _heightController, TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Weight (kg)', _weightController, TextInputType.number),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _savePersonalData,
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
          value: _selectedGender,
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
