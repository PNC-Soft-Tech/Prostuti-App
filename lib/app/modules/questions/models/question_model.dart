import 'option_model.dart';

class Question {
  final String id;
  final String title;
  final List<Option> options;
  final String? explanation;
  final String? subCategory;
  final String? rightAnswer;

  Question({
    required this.id,
    required this.title,
    required this.options,
    this.explanation,
    this.subCategory,
    this.rightAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      options: (json['options'] as List?)
              ?.map((option) =>
                  Option.fromJson(option as Map<String, dynamic>))
              .toList() ??
          [],
      explanation: json['explanation'],
      subCategory: json['subCategory'],
      rightAnswer: json['rightAnswer'],
    );
  }
}
