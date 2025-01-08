import 'custom_exam_subject_model.dart';

class CustomExamModel {
 final String? id; 
 final CustomExamSubject? subject;

    CustomExamModel({this.id, this.subject});
factory CustomExamModel.fromJson(Map<String, dynamic> json){
  return CustomExamModel(id: json['id'], subject: json['subject']);
}
}