class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.general,
      ),
      isRead: json['isRead'] ?? false,
    );
  }
}

enum NotificationType {
  general,
  contest,
  exam,
  announcement,
  update,
  reminder,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.general:
        return 'General';
      case NotificationType.contest:
        return 'Contest';
      case NotificationType.exam:
        return 'Exam';
      case NotificationType.announcement:
        return 'Announcement';
      case NotificationType.update:
        return 'Update';
      case NotificationType.reminder:
        return 'Reminder';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.general:
        return '📢';
      case NotificationType.contest:
        return '🏆';
      case NotificationType.exam:
        return '📝';
      case NotificationType.announcement:
        return '📣';
      case NotificationType.update:
        return '🔄';
      case NotificationType.reminder:
        return '⏰';
    }
  }
}