import 'package:flutter/material.dart';

class SelectorExample extends StatefulWidget {
  @override
  _SelectorExampleState createState() => _SelectorExampleState();
}

class _SelectorExampleState extends State<SelectorExample> {
  String _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector Example'),
      ),
      body: Center(
        child: DropdownButton<String>(
          value: _selectedOption,
          onChanged: (String? newValue) {
            setState(() {
              _selectedOption = newValue!;
            });
          },
          items: <String>[
            'Daily Quests',
            'Check your Ranking',
            'Collect your Rewards',
            'Refer a Friend',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
