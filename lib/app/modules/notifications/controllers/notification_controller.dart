import 'package:get/get.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  // Observable list of notifications
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  
  // Filter options
  final Rx<NotificationType?> selectedFilter = Rx<NotificationType?>(null);
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Search query
  final RxString searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }
  
  // Load notifications (using dummy data for now)
  void loadNotifications() {
    isLoading.value = true;
    
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      notifications.value = _generateDummyNotifications();
      isLoading.value = false;
    });
  }
  
  // Generate dummy notifications
  List<NotificationModel> _generateDummyNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'New Contest Available',
        message: 'BCS Preliminary Mock Test is now live! Join now to test your preparation level.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: NotificationType.contest,
      ),
      NotificationModel(
        id: '2',
        title: 'System Update',
        message: 'We have updated our app with new features and bug fixes. Please update to the latest version.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.update,
        isRead: true,
      ),
      NotificationModel(
        id: '3',
        title: 'Exam Reminder',
        message: 'Your scheduled practice exam "General Knowledge Test" starts in 1 hour. Get ready!',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: NotificationType.reminder,
      ),
      NotificationModel(
        id: '4',
        title: 'Important Announcement',
        message: 'Due to server maintenance, the app will be unavailable from 12:00 AM to 2:00 AM tonight.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.announcement,
      ),
      NotificationModel(
        id: '5',
        title: 'New Study Material',
        message: 'Latest question bank for Primary Teacher Recruitment has been added to your study materials.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.general,
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        title: 'Contest Results Published',
        message: 'Results for "Weekly Math Quiz" are now available. Check your ranking!',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.contest,
        isRead: true,
      ),
      NotificationModel(
        id: '7',
        title: 'Profile Update Required',
        message: 'Please update your profile information to continue accessing premium features.',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        type: NotificationType.general,
      ),
      NotificationModel(
        id: '8',
        title: 'Special Discount',
        message: 'Get 30% off on all premium packages. Limited time offer! Use code: STUDY30',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        type: NotificationType.announcement,
        isRead: true,
      ),
    ];
  }
  
  // Get filtered notifications based on search and filter
  List<NotificationModel> get filteredNotifications {
    List<NotificationModel> filtered = notifications.toList();
    
    // Apply type filter
    if (selectedFilter.value != null) {
      filtered = filtered.where((notification) => 
        notification.type == selectedFilter.value).toList();
    }
    
    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((notification) =>
        notification.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        notification.message.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
    
    // Sort by timestamp (newest first)
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return filtered;
  }
  
  // Get unread notifications count
  int get unreadCount {
    return notifications.where((notification) => !notification.isRead).length;
  }
  
  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();
    }
  }
  
  // Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    notifications.refresh();
  }
  
  // Delete notification
  void deleteNotification(String notificationId) {
    notifications.removeWhere((notification) => notification.id == notificationId);
  }
  
  // Clear all notifications
  void clearAllNotifications() {
    notifications.clear();
  }
  
  // Set filter
  void setFilter(NotificationType? type) {
    selectedFilter.value = type;
  }
  
  // Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  // Refresh notifications
  void refreshNotifications() {
    loadNotifications();
  }
}