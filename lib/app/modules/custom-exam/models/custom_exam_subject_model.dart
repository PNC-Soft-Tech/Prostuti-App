import 'dart:core';

class CustomExamSubject {
  final String? id;
  final String? subjectName;
  final String? topic;
  final int? question;
  CustomExamSubject({this.id, this.question, this.subjectName, this.topic});
  factory CustomExamSubject.fromJson(Map<String, dynamic> json) {
    return CustomExamSubject(
        id: json['id'],
        question: json['question'],
        subjectName: json['subjectName'],
        topic: json['topic']);
  }
}
