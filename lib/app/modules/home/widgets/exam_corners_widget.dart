import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../../../storage/storage_helper.dart';

class ExamCornersWidget extends StatelessWidget {
  const ExamCornersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 19.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam Corners',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildCornerCard(
            title: 'SSC Corner',
            subtitle: 'Secondary School Certificate',
            icon: Icons.school,
            color: Colors.blue,
            onTap: () => _navigateToCorner('SSC'),
          ),
          SizedBox(height: 12.h),
          _buildCornerCard(
            title: 'HSC Corner',
            subtitle: 'Higher Secondary Certificate',
            icon: Icons.school_outlined,
            color: Colors.green,
            onTap: () => _navigateToCorner('HSC'),
          ),          SizedBox(height: 12.h),
          _buildCornerCard(
            title: 'Admission Test Corner',
            subtitle: 'University Admission Tests',
            icon: Icons.library_books,
            color: Colors.orange,
            onTap: () => _navigateToAdmissionCorner(),
          ),
          SizedBox(height: 12.h),          _buildCornerCard(
            title: 'Jobs Corner',
            subtitle: 'Government & Private Job Preparations',
            icon: Icons.work,
            color: Colors.purple,
            onTap: () => _navigateToJobsCorner(),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

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
    }    Get.toNamed(Routes.corner, arguments: filterParams);
  }
  void _navigateToJobsCorner() {
    // Show selection dialog for exam type
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Exam Type',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: 20.h),            // Loading state and exam types will be loaded dynamically
            FutureBuilder(
              future: _loadExamTypes(),
              builder: (context, snapshot) {
                print('🔍 FutureBuilder state: ${snapshot.connectionState}');
                print('🔍 Has data: ${snapshot.hasData}');
                print('🔍 Has error: ${snapshot.hasError}');
                print('🔍 Data: ${snapshot.data}');
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('⏳ Showing loading indicator');
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('❌ Showing error: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Error loading exam types: ${snapshot.error}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                      ),
                    ),
                  );                } else if (snapshot.hasData) {
                  final examTypes = snapshot.data as List<dynamic>;
                  print('📊 Rendering ${examTypes.length} exam types');
                  return Column(
                    children: [
                      // Add "All Jobs" option
                      _buildJobsOption(
                        title: 'All Jobs',
                        subtitle: 'All government & private job preparations',
                        icon: Icons.work_outline,
                        color: Colors.purple,
                        onTap: () => _navigateToJobsCornerType(null),
                      ),
                      // Dynamic exam types (only show if we have data)
                      if (examTypes.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        ...examTypes.map((examType) => Column(
                          children: [
                            _buildJobsOption(
                              title: examType['title'] ?? 'Unknown',
                              subtitle: 'Preparation for ${examType['title'] ?? 'Unknown'}',
                              icon: Icons.assignment,
                              color: Colors.purple.shade400,
                              onTap: () => _navigateToJobsCornerType(examType['_id']),
                            ),
                            SizedBox(height: 12.h),
                          ],
                        )).toList(),
                      ] else ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Login to see more job categories',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildJobsOption(
                        title: 'All Jobs',
                        subtitle: 'All government & private job preparations',
                        icon: Icons.work_outline,
                        color: Colors.purple,
                        onTap: () => _navigateToJobsCornerType(null),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'No additional job categories available',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _navigateToAdmissionCorner() {
    // Show selection dialog for admission test type
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Admission Test Type',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            _buildAdmissionOption(
              title: 'Medical Admission',
              subtitle: 'MBBS, BDS & other medical courses',
              icon: Icons.medical_services,
              color: Colors.red,
              onTap: () => _navigateToAdmissionCornerType('Medical'),
            ),
            SizedBox(height: 12.h),
            _buildAdmissionOption(
              title: 'Engineering Admission',
              subtitle: 'BUET, RUET & other engineering universities',
              icon: Icons.engineering,
              color: Colors.indigo,
              onTap: () => _navigateToAdmissionCornerType('Engineering'),
            ),
            SizedBox(height: 12.h),
            _buildAdmissionOption(
              title: 'GST Admission',
              subtitle: 'General Science & Technology',
              icon: Icons.science,
              color: Colors.purple,
              onTap: () => _navigateToAdmissionCornerType('GST'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAdmissionOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAdmissionCornerType(String admissionType) {
    Get.back(); // Close bottom sheet
    
    Map<String, String> filterParams;
    
    switch (admissionType) {
      case 'Medical':
        filterParams = {
          'cornerType': 'Admission',
          'admissionType': 'Medical',
          'contestType': '6850390198547b005cc285fb',
          'modelType': '685456f1b62630909f4b133b',
          'customExamType': '685032222b005cc23222',
        };
        break;
      case 'Engineering':
        filterParams = {
          'cornerType': 'Admission',
          'admissionType': 'Engineering',
          'contestType': '685457c9b62630909f4b1348',
          'modelType': '685457f5b62630909f4b134f',
          'customExamType': '6322222fe005cc23e34',
        };
        break;
      case 'GST':
        filterParams = {
          'cornerType': 'Admission',
          'admissionType': 'GST',
          'contestType': '68545874b62630909f4b135c',
          'modelType': '68545852b62630909f4b1355',
          'customExamType': '543ef2222fe3wdf5gfvfd',
        };
        break;
      default:
        return;
    }    Get.toNamed(Routes.corner, arguments: filterParams);
  }  // Load exam types from API
  Future<List<Map<String, dynamic>>> _loadExamTypes() async {
    try {
      print('🔄 Loading exam types from API...');
      
      // Check authentication first
      final AuthService authService = Get.find<AuthService>();
      print('🔍 Checking authentication...');
      
      // Debug: Check individual authentication components
      final hasToken = await StorageHelper.hasToken();
      final token = await StorageHelper.getToken();
      final userData = await StorageHelper.getUserData();
      final userId = await StorageHelper.getUserId();
      
      print('🔍 Has token: $hasToken');
      print('🔍 Token exists: ${token != null && token.isNotEmpty}');
      print('🔍 User data exists: ${userData != null && userData.isNotEmpty}');
      print('🔍 User ID exists: ${userId != null && userId.isNotEmpty}');
      
      final isAuthenticated = await authService.isAuthenticated();
      print('🔍 Is authenticated: $isAuthenticated');
        // If not authenticated, return empty list (will show login prompt in UI)
      if (!isAuthenticated) {
        print('❌ User not authenticated, returning empty list');
        return [];
      }
      
      print('✅ Authentication successful, proceeding with API call');
      final ApiHelper apiHelper = Get.find<ApiHelper>();
      
      print('📡 Making API call to /exam-types...');
      final result = await apiHelper.getExamTypes();
      
      return result.fold(        (error) {
          print('❌ API Error loading exam types: ${error.message}');
          print('❌ Error details: $error');
          return [];
        },
        (examTypes) {
          print('✅ Exam types loaded successfully: ${examTypes.length} items');
          for (var examType in examTypes) {
            print('   - ${examType.title} (${examType.id})');
          }
          final mappedData = examTypes.map((examType) => {
            '_id': examType.id,
            'title': examType.title,
            'slug': examType.slug,
          }).toList();
          print('📋 Mapped data: $mappedData');
          return mappedData;
        },
      );
    } catch (e) {
      print('🚨 Exception loading exam types: $e');
      print('🚨 Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  // Build jobs option card (similar to admission option)
  Widget _buildJobsOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToJobsCornerType(String? examTypeId) {
    Get.back(); // Close bottom sheet
    
    Map<String, String> filterParams;
    
    if (examTypeId == null) {
      // Show all jobs (no filtering)
      filterParams = {
        'cornerType': 'Jobs',
        'cornerName': 'Jobs Corner',
      };
    } else {
      // Filter by specific exam type
      filterParams = {
        'cornerType': 'Jobs',
        'cornerName': 'Jobs Corner',
        // 'examTypeId': examTypeId,
        'examType': examTypeId,
        'contestType': examTypeId,
        'modelType': examTypeId,
        'customExamType': examTypeId,
      };
    }

    Get.toNamed(Routes.corner, arguments: filterParams);
  }
}
