class SubjectTopics {
  final String id;
  final String name;
  final String slug;
  final String categoryId;

  SubjectTopics({
    required this.id,
    required this.name,
    required this.slug,
    required this.categoryId,
  });

  factory SubjectTopics.fromJson(Map<String, dynamic> json) {
    return SubjectTopics(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      categoryId: json['category'] ?? '',
    );
  }
}
