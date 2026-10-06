class Option {
  final String id;
  final String title;
  final String order;
  final bool isSelected;

  Option({
    required this.id,
    required this.title,
    required this.order,
     this.isSelected=false,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      order: json['order'].toString() ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }

  // Empty factory constructor for error cases
  factory Option.empty() {
    return Option(
      id: '',
      title: '',
      order: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'order': order,
      'isSelected': isSelected,
    };
  }
}
