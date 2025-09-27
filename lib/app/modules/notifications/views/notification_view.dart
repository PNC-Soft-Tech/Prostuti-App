import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../../../common/custom_simple_appbar.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';
import 'widgets/notification_item_widget.dart';
import 'widgets/notification_filter_widget.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
       appBar: CustomSimpleAppBar.appBar(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications, color: AppColors.primary),
              SizedBox(width: 8.w),
              const Text(
                'Notifications',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5.w),
                // Mark all as read button
          Obx(() => controller.unreadCount > 0
              ? TextButton(
                  onPressed: controller.markAllAsRead,
                  child: Text(
                    'Mark All Read',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : const SizedBox()),
          // More options menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  _showClearAllDialog(context);
                  break;
                case 'refresh':
                  controller.refreshNotifications();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
            ],
          ),
          centerTitle: true,
        ),
      // appBar: AppBar(
      //   title: const Text(
      //     'Notifications',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 20.0,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: AppColors.primary,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      //     onPressed: () => Get.back(),
      //   ),
      //   actions: [
      //     // Mark all as read button
      //     Obx(() => controller.unreadCount > 0
      //         ? TextButton(
      //             onPressed: controller.markAllAsRead,
      //             child: Text(
      //               'Mark All Read',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 12.sp,
      //                 fontWeight: FontWeight.w500,
      //               ),
      //             ),
      //           )
      //         : const SizedBox()),
      //     // More options menu
      //     PopupMenuButton<String>(
      //       icon: const Icon(Icons.more_vert, color: Colors.white),
      //       onSelected: (value) {
      //         switch (value) {
      //           case 'clear_all':
      //             _showClearAllDialog(context);
      //             break;
      //           case 'refresh':
      //             controller.refreshNotifications();
      //             break;
      //         }
      //       },
      //       itemBuilder: (context) => [
      //         const PopupMenuItem(
      //           value: 'refresh',
      //           child: Row(
      //             children: [
      //               Icon(Icons.refresh, size: 20),
      //               SizedBox(width: 8),
      //               Text('Refresh'),
      //             ],
      //           ),
      //         ),
      //         const PopupMenuItem(
      //           value: 'clear_all',
      //           child: Row(
      //             children: [
      //               Icon(Icons.clear_all, size: 20),
      //               SizedBox(width: 8),
      //               Text('Clear All'),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          // Search bar and filter
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.lightGray.withOpacity(0.3)),
                  ),
                  child: TextField(
                    onChanged: controller.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search notifications...',
                      hintStyle: TextStyle(
                        color: AppColors.gray,
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.gray,
                        size: 20.w,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Filter chips
                const NotificationFilterWidget(),
              ],
            ),
          ),
          
          // Notifications list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              final filteredNotifications = controller.filteredNotifications;

              if (filteredNotifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none_outlined,
                        size: 80.w,
                        color: AppColors.gray.withOpacity(0.5),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        controller.searchQuery.value.isNotEmpty ||
                                controller.selectedFilter.value != null
                            ? 'No notifications found'
                            : 'No notifications yet',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.searchQuery.value.isNotEmpty ||
                                controller.selectedFilter.value != null
                            ? 'Try adjusting your search or filter'
                            : 'We\'ll notify you when something new arrives',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.gray.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.refreshNotifications();
                },
                color: AppColors.primary,
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: filteredNotifications.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[index];
                    return NotificationItemWidget(
                      notification: notification,
                      onTap: () => _showNotificationDetail(context, notification),
                      onDelete: () => _showDeleteDialog(context, notification),
                      onMarkAsRead: () => controller.markAsRead(notification.id),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationModel notification) {
    // Mark as read when viewing detail
    if (!notification.isRead) {
      controller.markAsRead(notification.id);
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notification.type.icon,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          notification.type.displayName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: _getTypeColor(notification.type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Title
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: 12.h),
              
              // Message
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimaryColor.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.h),
              
              // Timestamp
              Text(
                _formatTimestamp(notification.timestamp),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(height: 20.h),
              
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      _showDeleteDialog(context, notification);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, NotificationModel notification) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteNotification(notification.id);
              Get.back();
              if (Get.isDialogOpen == true) {
                Get.back(); // Close detail dialog if open
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearAllNotifications();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.contest:
        return const Color(0xFF4CAF50);
      case NotificationType.exam:
        return const Color(0xFF2196F3);
      case NotificationType.announcement:
        return const Color(0xFFFF9800);
      case NotificationType.update:
        return const Color(0xFF9C27B0);
      case NotificationType.reminder:
        return const Color(0xFFFF5722);
      case NotificationType.general:
        return AppColors.gray;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}