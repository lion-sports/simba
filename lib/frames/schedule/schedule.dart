import 'package:flutter/material.dart';
import 'package:lion_flutter/services/teams/teams.service.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Future<List<Team>> teams = Team.list();

  Widget buildPosts(List<Team> teams) {
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return Container(
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(flex: 1, child: Image.network(team.notes!)),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: Text(team.name!)),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Team>>(
          future: teams,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;
              return buildPosts(posts);
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }
}
