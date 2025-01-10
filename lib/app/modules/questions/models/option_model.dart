class Option {
  final String id;
  final String title;
  final String order;

  Option({
    required this.id,
    required this.title,
    required this.order,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['_id'],
      title: json['title'],
      order: json['order'],
    );
  }
}
