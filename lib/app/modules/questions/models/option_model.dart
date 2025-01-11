class Option {
  final String title;
  final String order;

  Option({
    required this.title,
    required this.order,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      title: json['title'] ?? '',
      order: json['order'] ?? '',
    );
  }
}
