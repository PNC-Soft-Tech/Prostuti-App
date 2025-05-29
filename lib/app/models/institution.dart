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
    // Helper function to safely parse nested objects
    Map<String, dynamic>? safelyGetMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      print('Cannot convert to Map<String, dynamic>: $value (${value.runtimeType})');
      return null;
    }
    
    InstitutionType? institutionType;
    final institutionTypeData = json['institutionType'];
    
    if (institutionTypeData != null) {
      final institutionTypeMap = safelyGetMap(institutionTypeData);
      if (institutionTypeMap != null) {
        try {
          institutionType = InstitutionType.fromJson(institutionTypeMap);
        } catch (e) {
          print('Error creating nested InstitutionType object: $e');
        }
      }
    }
    
    return Institution(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      institutionType: institutionType,
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
  
  // Override equality operator for correct dropdown comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Institution && other.id == id;
  }
    // Override hashCode to match equality
  @override
  int get hashCode => id.hashCode;
  
  // Override toString for debugging
  @override
  String toString() => 'Institution(id: $id, name: $name)';
}
