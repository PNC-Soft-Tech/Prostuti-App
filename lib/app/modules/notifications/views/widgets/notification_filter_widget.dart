import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../../controllers/notification_controller.dart';
import '../../models/notification_model.dart';

class NotificationFilterWidget extends GetView<NotificationController> {
  const NotificationFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: controller.selectedFilter.value == null,
            onTap: () => controller.setFilter(null),
          ),
          SizedBox(width: 8.w),
          ...NotificationType.values.map((type) => Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: _buildFilterChip(
              label: type.displayName,
              icon: type.icon,
              isSelected: controller.selectedFilter.value == type,
              onTap: () => controller.setFilter(type),
            ),
          )),
        ],
      )),
    );
  }

  Widget _buildFilterChip({
    required String label,
    String? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightGray,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(
                icon,
                style: TextStyle(fontSize: 12.sp),
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimaryColor,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}