class CustomExamSubject {
  final String? id;
   String? subjectName;
  List<Map<String, dynamic>>? topics; // List to store multiple topics

  CustomExamSubject({
    this.id,
    this.subjectName,
    this.topics,
  });

  factory CustomExamSubject.fromJson(Map<String, dynamic> json) {
    return CustomExamSubject(
      id: json['id'],
      subjectName: json['subjectName'],
      topics: (json['topics'] as List<dynamic>?)
          ?.map((topic) => topic as Map<String, dynamic>)
          .toList(),
    );
  }
}
