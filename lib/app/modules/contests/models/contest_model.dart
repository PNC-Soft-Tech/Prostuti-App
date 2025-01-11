import 'dart:developer';

import 'package:intl/intl.dart';

class Contest {
  final String id;
  final String? name;
  final int? registeredCount;
  final String? description;
  final String? stringTopics;
  final String? imageUrl;
  final List<Topic>? topics;
  final DateTime startContest;
  final DateTime endContest;
  final int totalMarks;
  final int totalTime;

  Contest({
    required this.id,
    this.name,
    this.imageUrl,
    this.registeredCount,
    this.description,
    this.stringTopics,
    this.topics,
    required this.startContest,
    required this.endContest,
    required this.totalMarks,
    required this.totalTime,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
 
    return Contest(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      registeredCount: json['registeredCount'] ?? 0,
      description: json['description'],
      stringTopics: json['stringTopics'],
      topics: (json['topics'] as List).isNotEmpty
          ? (json['topics'] as List).map((t) => Topic.fromJson(t)).toList()
          : [],
      // startContest: DateTime.parse(json['startContest']),
      // endContest: DateTime.parse(json['endContest']),
        startContest: parseDate(json['startContest']),
      endContest: parseDate(json['endContest']),
      totalMarks: json['totalMarks'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
    );
  }
      static DateTime parseDate(String dateStr) {
    try {
      // Remove extraneous timezone information
      final cleanedDateStr = dateStr.split('GMT')[0].trim();
      final dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss");

      return dateFormat.parse(cleanedDateStr);
    } catch (e) {
      log('Invalid date format: $dateStr');
      return DateTime.now(); // Fallback date
    }
  }
}

class Topic {
  final String id;
  final String name;

  Topic({required this.id, required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'],
      name: json['name'],
    );
  }


}
