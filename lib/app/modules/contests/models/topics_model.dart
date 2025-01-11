class Topic {
  final String id;
  final String name;
  final String? slug;
  final String? category;

  Topic({
    required this.id,
    required this.name,
    this.slug,
    this.category,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      category: json['category'],
    );
  }
}
