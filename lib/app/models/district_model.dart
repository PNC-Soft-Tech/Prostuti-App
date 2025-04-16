class District {
  final String id;
  final String divisionId;
  final String name;
  final String bnName;

  District({
    required this.id,
    required this.divisionId,
    required this.name,
    required this.bnName,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      divisionId: json['division_id'],
      name: json['name'],
      bnName: json['bn_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'division_id': divisionId,
      'name': name,
      'bn_name': bnName,
    };
  }
}
