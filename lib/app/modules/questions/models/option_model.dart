class Option {
  final String title;
  final String order;
  final bool isSelected;

  Option({
    required this.title,
    required this.order,
     this.isSelected=false,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      title: json['title'] ?? '',
      order: json['order'].toString() ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }
}
