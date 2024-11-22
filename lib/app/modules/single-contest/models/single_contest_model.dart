class SingleContest {
  final String id;
  final String name;
  final String description;
  final List<SingleContestQuestion> questions;
  final DateTime startContest;
  final DateTime endContest;
  final int totalMarks;
  final int totalTime;

  SingleContest({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
    required this.startContest,
    required this.endContest,
    required this.totalMarks,
    required this.totalTime,
  });

  factory SingleContest.fromJson(Map<String, dynamic> json) {
    return SingleContest(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((q) => SingleContestQuestion.fromJson(q))
          .toList(),
      startContest: DateTime.parse(json['startContest']),
      endContest: DateTime.parse(json['endContest']),
      totalMarks: json['totalMarks'],
      totalTime: json['totalTime'],
    );
  }
}

class SingleContestQuestion {
  final String id;
  final String title;
  final List<Option> options;
  final String explanation;
  final String rightAnswer;

  SingleContestQuestion({
    required this.id,
    required this.title,
    required this.options,
    required this.explanation,
    required this.rightAnswer,
  });

  factory SingleContestQuestion.fromJson(Map<String, dynamic> json) {
    return SingleContestQuestion(
      id: json['_id'],
      title: json['title'],
      options: (json['options'] as List)
          .map((o) => Option.fromJson(o))
          .toList(),
      explanation: json['explanation'],
      rightAnswer: json['rightAnswer'],
    );
  }
}

class Option {
  final String title;
  final String order;

  Option({required this.title, required this.order});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      title: json['title'],
      order: json['order'],
    );
  }
}
