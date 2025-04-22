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

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (slug != null) data['slug'] = slug;
    // Add other fields if needed
    return data;
  }
}
