class RegisterContest {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? topics;
  final List<String> questions;
  final DateTime startContest;
  final DateTime endContest;
  final int totalMarks;
  final int totalTime;
  final int marksPerQuestion;
  final int negativeMarks;
  final int registeredCount;

  RegisterContest({
    required this.id,
    required this.name,
    required this.description,
     this.imageUrl,
     this.topics,
    required this.questions,
    required this.startContest,
    required this.endContest,
    required this.totalMarks,
    required this.totalTime,
    required this.marksPerQuestion,
    required this.negativeMarks,
    required this.registeredCount,
  });

  factory RegisterContest.fromJson(Map<String, dynamic> json) {
    return RegisterContest(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      topics: json['topics'],
      questions: List<String>.from(json['questions']),
      startContest: DateTime.parse(json['startContest']),
      endContest: DateTime.parse(json['endContest']),
      totalMarks: json['totalMarks'],
      totalTime: json['totalTime'],
      marksPerQuestion: json['marksPerQuestion'],
      negativeMarks: json['negativeMarks'],
      registeredCount: json['registeredCount'],
    );
  }
}
