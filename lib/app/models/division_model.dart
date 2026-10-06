class Division {
  final String id;
  final String name;
  final String bnName;

  Division({
    required this.id,
    required this.name,
    required this.bnName,
  });

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'],
      name: json['name'],
      bnName: json['bn_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bn_name': bnName,
    };
  }
}
