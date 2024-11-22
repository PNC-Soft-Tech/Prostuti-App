class Contest {
  final String id;
  final String name;
  final String description;
  final List<String> questions;
  final String startContest;
  final String endContest;
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
      questions: List<String>.from(json['questions']),
      startContest: json['startContest'],
      endContest: json['endContest'],
      totalMarks: json['totalMarks'],
      totalTime: json['totalTime'],
    );
  }
}
