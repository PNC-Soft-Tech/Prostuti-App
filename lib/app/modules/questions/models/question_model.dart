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
  final String? status;
  final String? category;
  final bool isAcceptMultipleAnswers;

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
    this.status = 'active',
    this.category='hsc',
    this.isAcceptMultipleAnswers=false
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 'active',
      category: json['category'] ?? 'hsc',
      marks: json['marks'] ?? 1,
      isGrid: json['isGrid'] ?? true,
      isFlagged: json['isFlagged'] ?? false,
      isAcceptMultipleAnswers: json['isAcceptMultipleAnswers'] ?? false,
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
      topic: json['topic'] != null
          ? (json['topic'] is Map<String, dynamic>
              ? Topic.fromJson(json['topic'] as Map<String, dynamic>)
              : json['topics'] != null && (json['topics'] as List).isNotEmpty
                  ? Topic.fromJson((json['topics'] as List).first as Map<String, dynamic>)
                  : Topic(id: json['topic'].toString(), name: ''))
          : null,
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
}
