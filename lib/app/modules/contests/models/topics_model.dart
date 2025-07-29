import '../../subjects/models/subjects_model.dart';

class Topic {
  final String id;
  final String name;
  final String? slug;
  final String? category;
  final Subjects? subject;
  final int? totalQuestions;

  Topic({
    required this.id,
    required this.name,
    this.slug,
    this.category,
    this.subject,
    this.totalQuestions,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('topic') && json.containsKey('totalQuestions')) {
      return Topic(
        id: json['topic'] ?? '',
        name: '',
        totalQuestions: json['totalQuestions'] as int? ?? 0,
      );
    }

    return Topic(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      category: json['category'],
      subject: json['subject'] != null 
          ? (json['subject'] is Map<String, dynamic>
              ? Subjects.fromJson(json['subject'] as Map<String, dynamic>)
              : null) // Skip parsing if subject is just a String ID
          : null,
    );
  }
  // tojson method to convert the object to JSON
  Map<String, dynamic> toJson() {
    if (totalQuestions != null) {
      return {
        'topic': id,
        'totalQuestions': totalQuestions,
      };
    }
    
    final Map<String, dynamic> data = {};
    if (id.isNotEmpty) data['_id'] = id;
    if (name.isNotEmpty) data['name'] = name;
    if (slug != null) data['slug'] = slug;
    if (category != null) data['category'] = category;
    if (subject != null) data['subject'] = subject?.toJson();
    return data;
  }
}
