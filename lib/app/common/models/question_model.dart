class Question {
  final String id;
  final String title;
  final List<Option> options;
  final String explanation;
  final String subCategory;
  final String rightAnswer;

  Question({
    required this.id,
    required this.title,
    required this.options,
    required this.explanation,
    required this.subCategory,
    required this.rightAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'],
      title: json['title'],
      options: (json['options'] as List)
          .map((optionJson) => Option.fromJson(optionJson))
          .toList(),
      explanation: json['explanation'],
      subCategory: json['subCategory'],
      rightAnswer: json['rightAnswer'],
    );
  }
}

class Option {
  final String title;
  final String order;
  final String id;

  Option({
    required this.title,
    required this.order,
    required this.id,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      title: json['title'],
      order: json['order'],
      id: json['_id'],
    );
  }
}
