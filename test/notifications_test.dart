import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/modules/notifications/controllers/notification_controller.dart';
import 'package:prostuti/app/modules/notifications/models/notification_model.dart';

void main() {
  group('NotificationController Tests', () {
    late NotificationController controller;

    setUp(() {
      Get.testMode = true;
      controller = NotificationController();
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with empty notifications', () {
      expect(controller.notifications.isEmpty, true);
      expect(controller.isLoading.value, false);
    });

    test('should load dummy notifications', () {
      controller.loadNotifications();
      
      // Wait for the mock delay
      Future.delayed(const Duration(seconds: 2), () {
        expect(controller.notifications.isNotEmpty, true);
        expect(controller.isLoading.value, false);
      });
    });

    test('should mark notification as read', () {
      // Add a test notification
      final testNotification = NotificationModel(
        id: 'test-1',
        title: 'Test Notification',
        message: 'This is a test message',
        timestamp: DateTime.now(),
        type: NotificationType.general,
        isRead: false,
      );
      
      controller.notifications.add(testNotification);
      
      // Mark as read
      controller.markAsRead('test-1');
      
      expect(controller.notifications.first.isRead, true);
    });

    test('should delete notification', () {
      // Add a test notification
      final testNotification = NotificationModel(
        id: 'test-delete',
        title: 'Test Delete',
        message: 'This will be deleted',
        timestamp: DateTime.now(),
        type: NotificationType.general,
      );
      
      controller.notifications.add(testNotification);
      expect(controller.notifications.length, 1);
      
      // Delete notification
      controller.deleteNotification('test-delete');
      
      expect(controller.notifications.isEmpty, true);
    });

    test('should filter notifications by type', () {
      // Add test notifications of different types
      controller.notifications.addAll([
        NotificationModel(
          id: 'contest-1',
          title: 'Contest',
          message: 'Contest notification',
          timestamp: DateTime.now(),
          type: NotificationType.contest,
        ),
        NotificationModel(
          id: 'general-1',
          title: 'General',
          message: 'General notification',
          timestamp: DateTime.now(),
          type: NotificationType.general,
        ),
      ]);
      
      // Filter by contest type
      controller.setFilter(NotificationType.contest);
      
      final filtered = controller.filteredNotifications;
      expect(filtered.length, 1);
      expect(filtered.first.type, NotificationType.contest);
    });

    test('should search notifications', () {
      // Add test notifications
      controller.notifications.addAll([
        NotificationModel(
          id: 'search-1',
          title: 'Important Update',
          message: 'System update available',
          timestamp: DateTime.now(),
          type: NotificationType.update,
        ),
        NotificationModel(
          id: 'search-2',
          title: 'Contest Alert',
          message: 'New contest starting soon',
          timestamp: DateTime.now(),
          type: NotificationType.contest,
        ),
      ]);
      
      // Search for "update"
      controller.setSearchQuery('update');
      
      final filtered = controller.filteredNotifications;
      expect(filtered.length, 1);
      expect(filtered.first.title.toLowerCase().contains('update'), true);
    });

    test('should count unread notifications', () {
      controller.notifications.addAll([
        NotificationModel(
          id: 'unread-1',
          title: 'Unread 1',
          message: 'First unread',
          timestamp: DateTime.now(),
          type: NotificationType.general,
          isRead: false,
        ),
        NotificationModel(
          id: 'read-1',
          title: 'Read 1',
          message: 'First read',
          timestamp: DateTime.now(),
          type: NotificationType.general,
          isRead: true,
        ),
        NotificationModel(
          id: 'unread-2',
          title: 'Unread 2',
          message: 'Second unread',
          timestamp: DateTime.now(),
          type: NotificationType.general,
          isRead: false,
        ),
      ]);
      
      expect(controller.unreadCount, 2);
    });
  });
}