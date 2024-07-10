import 'dart:convert'; // required to encode/decode json data
import 'dart:developer';
import 'package:lion_flutter/services/apiConnector.dart';
import 'package:lion_flutter/utility/global.dart';

class Team {
  int? id;
  int? uid;
  String? name;
  String? notes;
  int? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Team(
      {this.id,
      this.uid,
      this.name,
      this.notes,
      this.ownerId,
      this.createdAt,
      this.updatedAt});
  factory Team.fromJson(Map<String, dynamic> json) => Team(
      id: json['id'],
      uid: json['user_id'],
      name: json['name'] ?? '',
      notes: json['notes'] ?? '',
      ownerId: json['owner_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']))
    ..formatDates();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': uid,
        'name': name,
        'notes': notes,
        'owner_id': ownerId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String()
      };

  void formatDates() {
    if (createdAt != null) {
      createdAt =
          DateTime.parse(createdAt!.toString().replaceAll('Z', '.000Z'));
    }
    if (updatedAt != null && createdAt != null) {
      updatedAt = DateTime(
          updatedAt!.year, updatedAt!.month, updatedAt!.day, createdAt!.hour);
    }
  }

  static Future<List<Team>> list() async {
    try {
      APIConnector apiConnector = APIConnector(Global.api,);
      String responseString = await apiConnector.post('teams/index', []);

      final List body = json.decode(responseString);

      return body.map((e) => Team.fromJson(e)).toList();
    } catch (e) {
      log('Error fetching teams: $e');
      throw Exception('Failed to load teams');
    }
  }
}
