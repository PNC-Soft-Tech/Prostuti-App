import 'dart:developer';

import '../../contest-details/models/registered_user_model.dart';
import '../../questions/models/question_model.dart';
import 'topics_model.dart';

class Contest {
  final String id;
  final String? name;
  final String? description;
  final String? stringTopics;
  final String? imageUrl;
  final int? registeredCount;
  final int totalMarks;
  final int totalTime;
  final DateTime startContest;
  final DateTime endContest;
  final List<Topic> topics;
  final List<Question> questions;
  final List<RegisteredUser> registeredUsers;

  Contest({
    required this.id,
    this.name,
    this.description,
    this.stringTopics,
    this.imageUrl,
    this.registeredCount,
    required this.totalMarks,
    required this.totalTime,
    required this.startContest,
    required this.endContest,
    required this.topics,
    required this.questions,
    required this.registeredUsers,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['_id'] ?? '',
      name: json['name'],
      description: json['description'],
      stringTopics: json['stringTopics'],
      imageUrl: json['imageUrl'],
      registeredCount: json['registeredCount'] ?? 0,
      totalMarks: json['totalMarks'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
      startContest: parseDate(json['startContest']),
      endContest: parseDate(json['endContest']),
      topics: (json['topics'] as List?)
              ?.map((topic) => Topic.fromJson(topic as Map<String, dynamic>))
              .toList() ??
          [],
      questions: (json['questions'] as List?)
              ?.map((question) =>
                  Question.fromJson(question as Map<String, dynamic>))
              .toList() ??
          [],
      registeredUsers: (json['registeredUsers'] as List?)
              ?.map((user) =>
                  RegisteredUser.fromJson(user as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  static DateTime parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now(); // Handle null date string
    try {
      return DateTime.parse(dateStr); // ISO 8601 parsing
    } catch (e) {
      log('Invalid date format: $dateStr');
      return DateTime.now(); // Fallback date
    }
  }
}
