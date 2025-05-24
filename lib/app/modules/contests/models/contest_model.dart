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
  final dynamic registeredCount;
  final dynamic totalMarks;
  final dynamic totalTime;
  final bool? isSubjectWise;
  bool? isRegistered;
  bool? isSubmitted;
  final DateTime startContest;
  final DateTime endContest;
  final List<Topic> topics;
  final List<Question> questions;
  final List<RegisteredUser> registeredUsers;
  final List<SelectedTopic>? selectedTopics;

  Contest({
    required this.id,
    this.name,
    this.description,
    this.stringTopics,
    this.imageUrl,
    this.registeredCount,
    required this.totalMarks,
    required this.totalTime,
    this.isSubjectWise,
    this.isRegistered,
    this.isSubmitted = false,
    required this.startContest,
    required this.endContest,
    required this.topics,
    required this.questions,
    required this.registeredUsers,
    this.selectedTopics,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    // Handle custom exam response format
    List<SelectedTopic> selectedTopicsList = [];
    if (json.containsKey('selectedTopics') && json['selectedTopics'] is List) {
      try {
        selectedTopicsList = (json['selectedTopics'] as List)
            .map((topic) => SelectedTopic.fromJson(topic))
            .toList();
      } catch (e) {
        log('Error parsing selectedTopics: $e');
      }
    }

    return Contest(
      id: json['_id'] ?? '',
      name: json['name'],
      description: json['description'],
      stringTopics: json['stringTopics'],
      imageUrl: json['imageUrl'],
      registeredCount: json['registeredCount'] ?? 0,
      totalMarks: (json['totalMarks'] ?? 0).toDouble(),
      totalTime: json['totalTime'] ?? 0,
      isRegistered: json['isRegistered'] ?? true,
      isSubmitted: json['isSubmitted'] ?? false,
      isSubjectWise: json['isSubjectWise'] ?? true,      startContest: parseDate(json['startContest'] ?? json['startCustomExam']),
      endContest: parseDate(json['endContest'] ?? json['endCustomExam']),
      topics: (json['topics'] as List?)
              ?.map((topic) {
                if (topic is String) {
                  return Topic(id: topic, name: '');
                } else if (topic is Map<String, dynamic>) {
                  return Topic.fromJson(topic);
                } else {
                  log('Invalid topic format: $topic');
                  return Topic(id: '', name: '');
                }
              })
              .toList() ??
          [],
      questions: (json['questions'] as List?)
              ?.map((question) {
                if (question is Map<String, dynamic>) {
                  return Question.fromJson(question);
                } else {
                  log('Invalid question format: $question');
                  return Question.empty();
                }
              })
              .toList() ??
          [],
      registeredUsers: (json['registeredUsers'] as List?)
              ?.map((user) {
                if (user is Map<String, dynamic>) {
                  return RegisteredUser.fromJson(user);
                } else {
                  log('Invalid user format: $user');
                  return RegisteredUser.empty();
                }
              })
              .toList() ??
          [],
      selectedTopics: selectedTopicsList,
    );
  }
  static DateTime parseDate(String? dateStr) {
    if (dateStr == null) {
      log('Date string is null, using distant past as fallback');
      return DateTime(1970); // Use distant past instead of now for null dates
    }
    try {
      final parsed = DateTime.parse(dateStr);
      log('Successfully parsed date: $dateStr -> $parsed');
      return parsed; // ISO 8601 parsing
    } catch (e) {
      log('Invalid date format: $dateStr, error: $e');
      return DateTime(1970); // Use distant past instead of now for failed parsing
    }
  }
}

class SelectedTopic {
  final Topic? topic;
  final int totalQuestions;
  final String id;

  SelectedTopic({
    this.topic,
    required this.totalQuestions,
    required this.id,
  });

  factory SelectedTopic.fromJson(Map<String, dynamic> json) {
    return SelectedTopic(
      topic: json['topic'] != null ? Topic.fromJson(json['topic']) : null,
      totalQuestions: json['totalQuestions'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}
