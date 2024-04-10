import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}
