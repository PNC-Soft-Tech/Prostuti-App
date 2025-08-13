class ExamType {
  final String id;
  final String title;
  final String slug;
  final String? category; // Optional category field
  final DateTime createdAt;
  final DateTime updatedAt;

  ExamType({
    required this.id,
    required this.title,
    required this.slug,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamType.fromJson(Map<String, dynamic> json) {
    return ExamType(
      id: json['_id'],
      title: json['title'],
      slug: json['slug'],
      category: json['category'], // Parse category from JSON
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
