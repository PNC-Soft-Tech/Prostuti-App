class ModelTestsListResponse {
  final bool success;
  final List<ModelTestListItem> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ModelTestsListResponse({
    required this.success,
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ModelTestsListResponse.fromJson(Map<String, dynamic> json) {
    return ModelTestsListResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => ModelTestListItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class ModelTestListItem {
  final int totalMarks;
  final int totalTime;
  final String id;
  final String name;
  final String description;
  final List<String> questions;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  ModelTestListItem({
    required this.totalMarks,
    required this.totalTime,
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelTestListItem.fromJson(Map<String, dynamic> json) {
    return ModelTestListItem(
      totalMarks: json['totalMarks'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      user: json['user'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Helper methods
  String get cleanName {
    return name.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  String get cleanDescription {
    return description.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  int get questionCount => questions.length;

  String get formattedTime {
    if (totalTime <= 0) return 'No time limit';
    final hours = totalTime ~/ 60;
    final minutes = totalTime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedMarks {
    if (totalMarks <= 0) return 'No marks set';
    return '$totalMarks marks';
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
