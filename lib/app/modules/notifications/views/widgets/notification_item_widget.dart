import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../../models/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkAsRead;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primaryOpacity,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isRead 
                ? AppColors.lightGray.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Type badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                          fontSize: 10.sp,
                          color: _getTypeColor(notification.type),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                SizedBox(width: 8.w),
                // More options
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    size: 18.w,
                    color: AppColors.gray,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'mark_read':
                        onMarkAsRead();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(Icons.mark_email_read, size: 16),
                            SizedBox(width: 8),
                            Text('Mark as Read'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Title
            Text(
              notification.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            
            // Message
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimaryColor.withOpacity(0.7),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            
            // Footer
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14.w,
                  color: AppColors.gray,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.gray,
                  ),
                ),
                const Spacer(),
                // Read more indicator
                if (notification.message.length > 100)
                  Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
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
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}