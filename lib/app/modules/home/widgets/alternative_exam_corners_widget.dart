import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/routes/app_pages.dart';

class AlternativeExamCornersWidget extends StatelessWidget {
  const AlternativeExamCornersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exam Preparation Hub',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Your gateway to academic excellence',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Feature Cards Layout
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      title: 'SSC',
                      fullTitle: 'SSC Corner',
                      subtitle: 'Secondary School\nCertificate',
                      icon: Icons.school,
                      primaryColor: const Color(0xFF2196F3),
                      secondaryColor: const Color(0xFFBBDEFB),
                      onTap: () => _navigateToCorner('SSC'),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildFeatureCard(
                      title: 'HSC',
                      fullTitle: 'HSC Corner',
                      subtitle: 'Higher Secondary\nCertificate',
                      icon: Icons.school_outlined,
                      primaryColor: const Color(0xFF4CAF50),
                      secondaryColor: const Color(0xFFC8E6C9),
                      onTap: () => _navigateToCorner('HSC'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      title: 'Admission',
                      fullTitle: 'Admission Test',
                      subtitle: 'University\nAdmissions',
                      icon: Icons.library_books,
                      primaryColor: const Color(0xFFFF9800),
                      secondaryColor: const Color(0xFFFFE0B2),
                      onTap: () => _navigateToAdmissionCorner(),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildFeatureCard(
                      title: 'Jobs',
                      fullTitle: 'Jobs Corner',
                      subtitle: 'Govt & Private\nJob Preparation',
                      icon: Icons.work,
                      primaryColor: const Color(0xFF9C27B0),
                      secondaryColor: const Color(0xFFE1BEE7),
                      onTap: () => _navigateToJobsCorner(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String fullTitle,
    required String subtitle,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with background
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      icon,
                      color: primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  
                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Hover indicator
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: primaryColor,
                  size: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation methods (same as main widget)
  void _navigateToCorner(String cornerType) {
    Map<String, String> filterParams;
    
    switch (cornerType) {
      case 'SSC':
        filterParams = {
          'cornerType': 'SSC',
          'contestType': '68539e723b5190a2557d73d1',
          'modelType': '6842298a2464c0fa0b572e85',
          'customExamType': '3rf432ggjdk90a2557d73d1',
        };
        break;
      case 'HSC':
        filterParams = {
          'cornerType': 'HSC',
          'contestType': '6850464498547b005cc28615',
          'modelType': '6842221ee824fbddc1f6ab1d',
          'customExamType': '55355sshfefedc1f6ab1d',
        };
        break;
      default:
        return;
    }
    
    Get.toNamed(Routes.corner, arguments: filterParams);
  }
  
  void _navigateToAdmissionCorner() {
    // Implementation same as original widget
    // You can copy from the main widget
  }
  
  void _navigateToJobsCorner() {
    // Implementation same as original widget  
    // You can copy from the main widget
  }
}
