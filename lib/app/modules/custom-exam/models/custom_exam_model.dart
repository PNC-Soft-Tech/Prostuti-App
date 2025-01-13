import 'custom_exam_subject_model.dart';

class CustomExamModel {
  final String? id;
   List<CustomExamSubject>? subjects;

  CustomExamModel({this.id, this.subjects});
  factory CustomExamModel.fromJson(Map<String, dynamic> json) {
    return CustomExamModel(
      id: json['id'],
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((subjectJson) => CustomExamSubject.fromJson(subjectJson))
          .toList(),
    );
  }
}
