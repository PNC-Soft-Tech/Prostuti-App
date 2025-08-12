class Option {
  final  String id;
  final String title;
  final String order;
  final bool isCorrect;
  final bool isSelected;

  Option({
    required this.id,
    required this.title,
    required this.isCorrect,
    required this.order,
     this.isSelected=false,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      order: json['order'].toString() ?? '',
      isSelected: json['isSelected'] ?? false,
      isCorrect: json['isCorrect'] ?? false,
    );
  }
  
  // Empty factory constructor for error cases
  factory Option.empty() {
    return Option(
      title: '',
      order: '',
      id: '',
      isCorrect: false,

    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id':id,
      'isCorrect': isCorrect,
      'order': order,
      'isSelected': isSelected,
    };
  }
}
