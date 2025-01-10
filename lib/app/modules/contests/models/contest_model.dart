
import '../../questions/models/question_model.dart';

class Contest {
  final String id;
  final String name;
  final String description;
  final List<Question> questions;
  final DateTime startContest;
  final DateTime endContest;
  final int totalMarks;
  final int totalTime;

  Contest({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
    required this.startContest,
    required this.endContest,
    required this.totalMarks,
    required this.totalTime,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      startContest: DateTime.parse(json['startContest']),
      endContest: DateTime.parse(json['endContest']),
      totalMarks: json['totalMarks'],
      totalTime: json['totalTime'],
    );
  }
}
