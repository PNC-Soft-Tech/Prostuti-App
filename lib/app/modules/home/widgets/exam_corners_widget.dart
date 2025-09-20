import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';

class ExamCornersWidget extends StatelessWidget {
  const ExamCornersWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 19.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exam Corners',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Choose your preparation path',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Popular',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
            // Grid Layout for Exam Corners
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.95, // Increased height to prevent overflow
            children: [
              _buildModernCornerCard(
                title: 'SSC Corner',
                subtitle: 'Secondary School Certificate',
                icon: Icons.school,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                ),
                iconBg: const Color(0xFFE3F2FD),
                onTap: () => _navigateToCorner('SSC'),
              ),
              _buildModernCornerCard(
                title: 'HSC Corner',
                subtitle: 'Higher Secondary Certificate',
                icon: Icons.school_outlined,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF34A853), Color(0xFF0F9D58)],
                ),
                iconBg: const Color(0xFFE8F5E8),
                onTap: () => _navigateToCorner('HSC'),
              ),
              _buildModernCornerCard(
                title: 'Admission Test',
                subtitle: 'University Admissions',
                icon: Icons.library_books,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                ),
                iconBg: const Color(0xFFFFF3E0),
                onTap: () => _navigateToAdmissionCorner(),
              ),
              _buildModernCornerCard(
                title: 'Jobs Corner',
                subtitle: 'Government & Private Jobs',
                icon: Icons.work,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                ),
                iconBg: const Color(0xFFF3E5F5),
                onTap: () => _navigateToJobsCorner(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernCornerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),        child: Stack(
          children: [
            // Background Pattern
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 70.w, // Slightly smaller
                height: 70.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -8,
              left: -8,
              child: Container(
                width: 50.w, // Slightly smaller
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
              // Content
            Padding(
              padding: EdgeInsets.all(16.w), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 45.w, // Slightly smaller icon container
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: gradient.colors.first,
                      size: 24.sp, // Reduced icon size
                    ),
                  ),
                  
                  SizedBox(height: 12.h), // Fixed spacing instead of Spacer
                  
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp, // Slightly smaller font
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 3.h), // Reduced spacing
                  
                  // Subtitle
                  Expanded( // Use Expanded to prevent overflow
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp, // Smaller subtitle font
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                        height: 1.2, // Reduced line height
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  SizedBox(height: 6.h), // Reduced spacing
                  
                  // Arrow indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w), // Reduced padding
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14.sp, // Smaller arrow icon
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCorner(String cornerType) {
    Map<String, String> filterParams;
    
    switch (cornerType.toLowerCase()) { // Convert to lowercase for case-insensitive matching
      case 'ssc':
        filterParams = {
          'cornerType': 'SSC',
          'contestType': '68539e723b5190a2557d73d1',
          'modelType': '6842298a2464c0fa0b572e85',
          'customExamType': '3rf432ggjdk90a2557d73d1',
        };
        break;
      case 'hsc':
        filterParams = {
          'cornerType': 'HSC',
          'contestType': '6850464498547b005cc28615',
          'modelType': '6842221ee824fbddc1f6ab1d',
          'customExamType': '55355sshfefedc1f6ab1d',
        };
        break;
      default:
        print('❌ Unknown corner type: $cornerType');
        return;
    }
    
    print('🚀 Navigating to $cornerType corner with params: $filterParams');
    Get.toNamed(Routes.corner, arguments: filterParams);
  }
  void _navigateToJobsCorner() {
    // Show selection dialog for exam type with search
    Get.bottomSheet(
      JobsCornerBottomSheet(),
      isScrollControlled: true,
    );
  }

  void _navigateToAdmissionCorner() {
    // Show dynamic admission test type selection
    Get.bottomSheet(
      AdmissionCornerBottomSheet(),
      isScrollControlled: true,
    );
  }

  }

  // Dynamic AdmissionCornerBottomSheet widget
class JobsCornerBottomSheet extends StatefulWidget {
  const JobsCornerBottomSheet({super.key});

  @override
  State<JobsCornerBottomSheet> createState() => _JobsCornerBottomSheetState();
}

class _JobsCornerBottomSheetState extends State<JobsCornerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allExamTypes = [];
  List<Map<String, dynamic>> _filteredExamTypes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExamTypes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterExamTypes();
    });
  }

  void _filterExamTypes() {
    if (_searchQuery.isEmpty) {
      _filteredExamTypes = List.from(_allExamTypes);
    } else {
      _filteredExamTypes = _allExamTypes.where((examType) {
        final title = (examType['title'] ?? '').toString().toLowerCase();
        return title.contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> _loadExamTypes() async {
    setState(() => _isLoading = true);
    
    try {
      print('🔄 Loading job category exam types from API...');
      
      // Check authentication first
      final AuthService authService = Get.find<AuthService>();
      final isAuthenticated = await authService.isAuthenticated();
      
      if (!isAuthenticated) {
        print('❌ User not authenticated, returning empty list');
        setState(() {
          _allExamTypes = [];
          _filteredExamTypes = [];
          _isLoading = false;
        });
        return;
      }
      
      final ApiHelper apiHelper = Get.find<ApiHelper>();
      // Use category-filtered API for job exam types
      final result = await apiHelper.getExamTypesByCategory('job');
      
      result.fold(
        (error) {
          print('❌ API Error loading job exam types: ${error.message}');
          setState(() {
            _allExamTypes = [];
            _filteredExamTypes = [];
            _isLoading = false;
          });
        },
        (examTypes) {
          print('✅ Job exam types loaded successfully: ${examTypes.length} items');
          final mappedData = examTypes.map((examType) => {
            '_id': examType.id,
            'title': examType.title,
            'slug': examType.slug,
            'category': examType.category, // Keep category info
          }).toList();
          
          setState(() {
            _allExamTypes = mappedData;
            _filteredExamTypes = List.from(mappedData);
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      print('🚨 Exception loading job exam types: $e');
      setState(() {
        _allExamTypes = [];
        _filteredExamTypes = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Job Category',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 24.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search job categories...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20.sp,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 20.sp,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                : _buildJobsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    // Always show "All Jobs" option
    final allJobsOption = _buildJobsOption(
      title: 'All Jobs',
      subtitle: 'All government & private job preparations',
      icon: Icons.work_outline,
      color: Colors.purple,
      onTap: () => _navigateToJobsCornerType(null),
    );

    if (_filteredExamTypes.isEmpty && _searchQuery.isNotEmpty) {
      // No search results
      return Column(
        children: [
          allJobsOption,
          SizedBox(height: 20.h),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No results found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Try searching with different keywords',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_filteredExamTypes.isEmpty && !_isLoading) {
      // No exam types available
      return Column(
        children: [
          allJobsOption,
          SizedBox(height: 20.h),
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
      );
    }

    // Show all available options
    return ListView(
      children: [
        allJobsOption,
        if (_filteredExamTypes.isNotEmpty) ...[
          SizedBox(height: 12.h),
          ...(_filteredExamTypes.map((examType) => Column(
            children: [
              _buildJobsOption(
                title: examType['title'] ?? 'Unknown',
                subtitle: 'Preparation for ${examType['title'] ?? 'Unknown'}',
                icon: Icons.assignment,
                color: Colors.purple.shade400,
                onTap: () {
                  print('🔥 Job Corner item clicked: ${examType['title']} (ID: ${examType['_id']})');
                  _navigateToJobsCornerType(examType['_id'], examType['title']);
                },
              ),
              SizedBox(height: 12.h),
            ],
          )).toList()),
        ],
      ],
    );
  }

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
                  // Highlight search term in title
                  _buildHighlightedText(
                    title,
                    _searchQuery,
                    TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor,
                    ),
                    TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                      backgroundColor: Colors.purple.withOpacity(0.1),
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

  Widget _buildHighlightedText(
    String text,
    String query,
    TextStyle normalStyle,
    TextStyle highlightStyle,
  ) {
    if (query.isEmpty) {
      return Text(text, style: normalStyle);
    }

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();
    
    if (!lowercaseText.contains(lowercaseQuery)) {
      return Text(text, style: normalStyle);
    }

    final startIndex = lowercaseText.indexOf(lowercaseQuery);
    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          if (startIndex > 0)
            TextSpan(
              text: text.substring(0, startIndex),
              style: normalStyle,
            ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: highlightStyle,
          ),
          if (endIndex < text.length)
            TextSpan(
              text: text.substring(endIndex),
              style: normalStyle,
            ),
        ],
      ),
    );
  }

  void _navigateToJobsCornerType(String? examTypeId, [String? examTypeTitle]) {
    print('🚀 _navigateToJobsCornerType called with examTypeId: $examTypeId, examTypeTitle: $examTypeTitle');
    Get.back(); // Close bottom sheet
    print('🚀 Bottom sheet closed');
    
    Map<String, String> filterParams;
    
    if (examTypeId == null) {
      // Show all jobs (no filtering) - use empty examType for job category
      filterParams = {
        'cornerType': 'Jobs',
        'cornerName': 'Jobs Corner',
      };
    } else {
      // Filter by specific exam type using slug for examType parameter
      Map<String, dynamic> examType;
      try {
        examType = _allExamTypes.firstWhere(
          (type) => type['_id'] == examTypeId,
        );
      } catch (e) {
        examType = {'slug': examTypeId, '_id': examTypeId};
      }
      final examTypeSlug = examType['slug']?.toString() ?? examTypeId;
      
      filterParams = {
        'cornerType': 'Jobs',
        'cornerName': 'Jobs Corner',
        'examTypeId': examTypeId, // Use slug instead of ID for API compatibility
        'examTypeTitle': examTypeTitle ?? 'Job Preparation',
        'contestType': examTypeSlug,
        'modelType': examTypeSlug,
        'customExamType': examTypeSlug,
      };
    }

    print('🚀 Navigating to Jobs Corner with params: $filterParams');
    print('🚀 About to call Get.toNamed(${Routes.corner})');
    print('🚀 Routes.corner value: ${Routes.corner}');
    try {
      Get.toNamed(Routes.corner, arguments: filterParams);
      print('🚀 Get.toNamed called successfully');
    } catch (e) {
      print('❌ Error during navigation: $e');
    }
  }
}

// Dynamic AdmissionCornerBottomSheet widget
class AdmissionCornerBottomSheet extends StatefulWidget {
  const AdmissionCornerBottomSheet({super.key});

  @override
  State<AdmissionCornerBottomSheet> createState() => _AdmissionCornerBottomSheetState();
}

class _AdmissionCornerBottomSheetState extends State<AdmissionCornerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allExamTypes = [];
  List<Map<String, dynamic>> _filteredExamTypes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAdmissionExamTypes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterExamTypes();
    });
  }

  void _filterExamTypes() {
    if (_searchQuery.isEmpty) {
      _filteredExamTypes = List.from(_allExamTypes);
    } else {
      _filteredExamTypes = _allExamTypes.where((examType) {
        final title = (examType['title'] ?? '').toString().toLowerCase();
        return title.contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> _loadAdmissionExamTypes() async {
    setState(() => _isLoading = true);
    
    try {
      print('🔄 Loading admission category exam types from API...');
      
      // Check authentication first
      final AuthService authService = Get.find<AuthService>();
      final isAuthenticated = await authService.isAuthenticated();
      
      if (!isAuthenticated) {
        print('❌ User not authenticated, returning empty list');
        setState(() {
          _allExamTypes = [];
          _filteredExamTypes = [];
          _isLoading = false;
        });
        return;
      }
      
      final ApiHelper apiHelper = Get.find<ApiHelper>();
      // Use category-filtered API for admission exam types
      final result = await apiHelper.getExamTypesByCategory('admission');
      
      result.fold(
        (error) {
          print('❌ API Error loading admission exam types: ${error.message}');
          setState(() {
            _allExamTypes = [];
            _filteredExamTypes = [];
            _isLoading = false;
          });
        },
        (examTypes) {
          print('✅ Admission exam types loaded successfully: ${examTypes.length} items');
          final mappedData = examTypes.map((examType) => {
            '_id': examType.id,
            'title': examType.title,
            'slug': examType.slug,
            'category': examType.category, // Keep category info
          }).toList();
          
          setState(() {
            _allExamTypes = mappedData;
            _filteredExamTypes = List.from(mappedData);
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      print('🚨 Exception loading admission exam types: $e');
      setState(() {
        _allExamTypes = [];
        _filteredExamTypes = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Admission Test Type',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 24.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search admission tests...',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 20.sp,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[500],
                          size: 20.sp,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  )
                : _buildAdmissionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdmissionsList() {
    // Always show "All Admissions" option
    final allAdmissionsOption = _buildAdmissionOption(
      title: 'All Admission Tests',
      subtitle: 'All university admission preparations',
      icon: Icons.school,
      color: Colors.orange,
      onTap: () => _navigateToAdmissionCornerType(null),
    );

    if (_filteredExamTypes.isEmpty && _searchQuery.isNotEmpty) {
      // No search results
      return Column(
        children: [
          allAdmissionsOption,
          SizedBox(height: 20.h),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No results found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Try searching with different keywords',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_filteredExamTypes.isEmpty && !_isLoading) {
      // No exam types available
      return Column(
        children: [
          allAdmissionsOption,
          SizedBox(height: 20.h),
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
                    'Login to see more admission test types',
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
      );
    }

    // Show all available options
    return ListView(
      children: [
        allAdmissionsOption,
        if (_filteredExamTypes.isNotEmpty) ...[
          SizedBox(height: 12.h),
          ...(_filteredExamTypes.map((examType) => Column(
            children: [
              _buildAdmissionOption(
                title: examType['title'] ?? 'Unknown',
                subtitle: 'Preparation for ${examType['title'] ?? 'Unknown'} admission',
                icon: _getAdmissionIcon(examType['title'] ?? ''),
                color: _getAdmissionColor(examType['title'] ?? ''),
                onTap: () {
                  print('🔥 Admission Corner item clicked: ${examType['title']} (ID: ${examType['_id']})');
                  _navigateToAdmissionCornerType(examType['_id'], examType['title']);
                },
              ),
              SizedBox(height: 12.h),
            ],
          )).toList()),
        ],
      ],
    );
  }

  IconData _getAdmissionIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('medical') || lowerTitle.contains('mbbs') || lowerTitle.contains('bds')) {
      return Icons.medical_services;
    } else if (lowerTitle.contains('engineering') || lowerTitle.contains('buet')) {
      return Icons.engineering;
    } else if (lowerTitle.contains('gst') || lowerTitle.contains('science')) {
      return Icons.science;
    } else {
      return Icons.library_books;
    }
  }

  Color _getAdmissionColor(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('medical') || lowerTitle.contains('mbbs') || lowerTitle.contains('bds')) {
      return Colors.red;
    } else if (lowerTitle.contains('engineering') || lowerTitle.contains('buet')) {
      return Colors.indigo;
    } else if (lowerTitle.contains('gst') || lowerTitle.contains('science')) {
      return Colors.purple;
    } else {
      return Colors.orange;
    }
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
                  // Highlight search term in title
                  _buildHighlightedText(
                    title,
                    _searchQuery,
                    TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor,
                    ),
                    TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                      backgroundColor: Colors.orange.withOpacity(0.1),
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

  Widget _buildHighlightedText(
    String text,
    String query,
    TextStyle normalStyle,
    TextStyle highlightStyle,
  ) {
    if (query.isEmpty) {
      return Text(text, style: normalStyle);
    }

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();
    
    if (!lowercaseText.contains(lowercaseQuery)) {
      return Text(text, style: normalStyle);
    }

    final startIndex = lowercaseText.indexOf(lowercaseQuery);
    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          if (startIndex > 0)
            TextSpan(
              text: text.substring(0, startIndex),
              style: normalStyle,
            ),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: highlightStyle,
          ),
          if (endIndex < text.length)
            TextSpan(
              text: text.substring(endIndex),
              style: normalStyle,
            ),
        ],
      ),
    );
  }

  void _navigateToAdmissionCornerType(String? examTypeId, [String? examTypeTitle]) {
    print('🚀 _navigateToAdmissionCornerType called with examTypeId: $examTypeId, examTypeTitle: $examTypeTitle');
    Get.back(); // Close bottom sheet
    print('🚀 Bottom sheet closed');
    
    Map<String, String> filterParams;
    
    if (examTypeId == null) {
      // Show all admissions (no filtering) - use empty examType for admission category
      filterParams = {
        'cornerType': 'Admission',
        'cornerName': 'Admission Test Corner',
      };
    } else {
      // Filter by specific exam type using slug for examType parameter
      Map<String, dynamic> examType;
      try {
        examType = _allExamTypes.firstWhere(
          (type) => type['_id'] == examTypeId,
        );
      } catch (e) {
        examType = {'slug': examTypeId, '_id': examTypeId};
      }
      final examTypeSlug = examType['slug']?.toString() ?? examTypeId;
      
      filterParams = {
        'cornerType': 'Admission',
        'cornerName': 'Admission Test Corner',
        'examTypeId': examTypeId, // Use slug instead of ID for API compatibility
        'examTypeTitle': examTypeTitle ?? 'Admission Test',
        'examTypeSlug': examTypeSlug,
        'admissionType': examTypeTitle ?? 'Admission Test',
        'contestType': examTypeSlug,
        'modelType': examTypeSlug,
        'customExamType': examTypeSlug,
      };
    }

    print('🚀 Navigating to Admission Corner with params: $filterParams');
    print('🚀 About to call Get.toNamed(${Routes.corner})');
    print('🚀 Routes.corner value: ${Routes.corner}');
    try {
      Get.toNamed(Routes.corner, arguments: filterParams);
      print('🚀 Get.toNamed called successfully');
    } catch (e) {
      print('❌ Error during navigation: $e');
    }
  }
}
