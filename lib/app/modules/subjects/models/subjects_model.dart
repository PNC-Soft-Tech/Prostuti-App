class Subjects {
  final String id;
  final String name;
  final String slug;

  Subjects({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
