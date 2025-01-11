
import '../../questions/models/question_model.dart';

class Contest {
  final String id;
  final String? name;
  final int? registeredCount;
  final String? description;
  final String? stringTopics;
  final String? imageUrl;
  final List<Question>? questions;
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
     this.questions,
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
      registeredCount: json['registeredCount'],
      description: json['description'],
      stringTopics: json['stringTopics'],
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
