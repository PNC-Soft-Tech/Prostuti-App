import 'package:prostuti/app/models/institution_type.dart';

class Institution {
  final String id;
  final String name;
  final String slug;
  final InstitutionType? institutionType;

  Institution({
    required this.id,
    required this.name,
    required this.slug,
    this.institutionType,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      institutionType: json['institutionType'] != null
          ? InstitutionType.fromJson(json['institutionType'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'institutionType': institutionType?.toJson(),
    };
  }
}
