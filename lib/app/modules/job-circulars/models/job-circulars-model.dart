import '../../../models/job-category-model.dart';

class JobCircular {
  final String id;
  final String title;
  final String company;
  final JobCategory jobCategory;
  final DateTime deadline;
  final String link;

  JobCircular({
    required this.id,
    required this.title,
    required this.company,
    required this.jobCategory,
    required this.deadline,
    required this.link,
  });

  factory JobCircular.fromJson(Map<String, dynamic> json) {
    return JobCircular(
      id: json['_id'],
      title: json['title'],
      company: json['company'],
      jobCategory: JobCategory.fromJson(json['jobCategory']),
      deadline: DateTime.parse(json['deadline']),
      link: json['link'],
    );
  }
}
