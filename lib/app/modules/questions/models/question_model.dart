
import 'option_model.dart';

class Question {
  final String id;
  final String title;
  final List<Option> options;
  final String explanation;
  final String rightAnswer;

  Question({
    required this.id,
    required this.title,
    required this.options,
    required this.explanation,
    required this.rightAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      title: json['title'],
      options: (json['options'] as List)
          .map((o) => Option.fromJson(o))
          .toList(),
      explanation: json['explanation'] ?? '',
      rightAnswer: json['rightAnswer'],
    );
  }
}
