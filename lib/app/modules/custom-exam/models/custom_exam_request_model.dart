import '../../contests/models/topics_model.dart';
import '../../subjects/models/subjects_model.dart';

class CustomExamRequestModel {
  final String? name;
  final String? description;
  final String? startCustomExam;
  final String? endCustomExam;
  final int? totalMarks;
  final int? totalQuestions;
  final int? totalTime;
  final List<Topic>? selectedTopics;

  final String? id;
  List<Subjects>? subjects;

  CustomExamRequestModel({
    this.name,
    this.description,
    this.startCustomExam,
    this.endCustomExam,
    this.totalMarks,
    this.totalQuestions,
    this.totalTime,
    this.selectedTopics,
    this.id,
    this.subjects,
  });

  factory CustomExamRequestModel.fromJson(Map<String, dynamic> json) {
    try {
      return CustomExamRequestModel(
        name: json['name'] as String?,
        description: json['description'] as String?,
        startCustomExam: json['startCustomExam'] as String?,
        endCustomExam: json['endCustomExam'] as String?,
        totalMarks: json['totalMarks'] as int?,
        totalQuestions: json['totalQuestions'] as int?,
        totalTime: json['totalTime'] as int?,
        selectedTopics: json['selectedTopics'] != null 
            ? List<Topic>.from((json['selectedTopics'] as List)
                .map((topicJson) => Topic.fromJson(topicJson as Map<String, dynamic>)))
            : null,
        id: json['id'] as String?,
        subjects: json['subjects'] != null
            ? List<Subjects>.from((json['subjects'] as List)
                .map((subjectJson) => Subjects.fromJson(subjectJson as Map<String, dynamic>)))
            : null,
      );
    } catch (e) {
      print('Error parsing CustomExamRequestModel: $e');
      rethrow;
    }
  }

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = {};

  if (name != null) data['name'] = name;
  if (description != null) data['description'] = description;
  if (startCustomExam != null) data['startCustomExam'] = startCustomExam;
  if (endCustomExam != null) data['endCustomExam'] = endCustomExam;
  if (totalMarks != null) data['totalMarks'] = totalMarks;
  if (totalQuestions != null) data['totalQuestions'] = totalQuestions;
  if (totalTime != null) data['totalTime'] = totalTime;
  if (selectedTopics != null) {
    data['selectedTopics'] = selectedTopics!.map((topic) => topic.toJson()).toList();
  }
  if (id != null) data['id'] = id;
  if (subjects != null) {
    data['subjects'] = subjects!.map((subject) => subject.toJson()).toList();
  }

  return data;
}
}
