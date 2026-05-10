import '../../contests/models/topics_model.dart';
import 'option_model.dart';

class Question {
  final String id;
  final String title;
  final dynamic marks;
  final bool? isGrid;
  final bool? isFlagged;
  final List<Option> options;
  final Topic? topic;
  final String? explanation;
  final String? subCategory;
  final String? rightAnswer;

  Question({
    required this.id,
    required this.title,
    this.isGrid = true,
    this.isFlagged = false,
    this.marks = 1,
    required this.options,
    this.topic,
    this.explanation,
    this.subCategory,
    this.rightAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      marks: json['marks'] ?? 1,
      isGrid: json['isGrid'] ?? true,
      isFlagged: json['isFlagged'] ?? false,
      options: (json['options'] as List?)
              ?.map((option) {
                if (option is Map<String, dynamic>) {
                  return Option.fromJson(option);
                } else {
                  return Option.empty();
                }
              })
              .toList() ??
          [],
      topic: _parseTopic(json['topic']),
      explanation: json['explanation'],
      subCategory: json['subCategory'],
      rightAnswer: json['rightAnswer'],
    );
  }
  
  // Create an empty Question for error cases
  factory Question.empty() {
    return Question(
      id: '',
      title: '',
      options: [],
    );
  }

  // The API returns `topic` as either a string ID (e.g. on `questions[].topic`
  // in custom exam responses) or a fully populated nested object (e.g. on
  // `questions[].topics[]`). Accept both shapes.
  static Topic? _parseTopic(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return Topic(id: value, name: '');
    }
    if (value is Map<String, dynamic>) {
      return Topic.fromJson(value);
    }
    return null;
  }
}
