class Upazila {
  final String id;
  final String districtId;
  final String name;
  final String bnName;

  Upazila({
    required this.id,
    required this.districtId,
    required this.name,
    required this.bnName,
  });

  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['id'],
      districtId: json['district_id'],
      name: json['name'],
      bnName: json['bn_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district_id': districtId,
      'name': name,
      'bn_name': bnName,
    };
  }
}
