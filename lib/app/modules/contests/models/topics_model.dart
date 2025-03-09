import '../../subjects/models/subjects_model.dart';

class Topic {
  final String id;
  final String name;
  final String? slug;
  final String? category;
  final Subjects? subject;

  Topic({
    required this.id,
    required this.name,
    this.slug,
    this.category,
    this.subject,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      category: json['category'],
      subject: json['subject'] != null 
      ? Subjects.fromJson(json['subject']) 
      : null,
    );
  }
}
