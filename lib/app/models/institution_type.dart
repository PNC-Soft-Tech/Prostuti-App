class InstitutionType {
  final String id;
  final String name;
  final String slug;

  InstitutionType({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory InstitutionType.fromJson(Map<String, dynamic> json) {
    return InstitutionType(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
    };
  }
}
