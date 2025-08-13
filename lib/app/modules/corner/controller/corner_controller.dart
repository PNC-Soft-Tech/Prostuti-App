import 'package:get/get.dart';
import 'dart:developer';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../../contests/models/contest_model.dart';
import '../../model-tests/models/model_test_model.dart';

class CornerController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  // Observable variables
  var isLoading = false.obs;
  var selectedTabIndex = 0.obs;

  // Data for each tab
  var contests = <Contest>[].obs;
  var modelTests = <ModelTest>[].obs;
  var customExams = <Map<String, dynamic>>[].obs;

  // Pagination variables for custom exams
  var customExamsPage = 1.obs;
  var customExamsHasMore = true.obs;  // Corner type and filter parameters
  var cornerType = ''.obs;
  var originalCornerType = ''.obs; // Store original for display purposes
  var admissionType = ''.obs; // For admission test subtypes
  var examTypeId = ''.obs; // For jobs corner exam type filtering
  var examTypeTitle = ''.obs; // For jobs corner exam type title display
  var contestTypeFilter = ''.obs;
  var modelTypeFilter = ''.obs;
  var customExamTypeFilter = ''.obs;
  @override
  void onInit() {
    super.onInit();    // Get corner configuration from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      cornerType.value = args['cornerType'] ?? '';
      originalCornerType.value = args['cornerType'] ?? ''; // Store original for display
      admissionType.value = args['admissionType'] ?? '';
      examTypeId.value = args['examType'] ?? ''; // Use 'examType' parameter directly
      examTypeTitle.value = args['examTypeTitle'] ?? ''; // Get exam type title
      contestTypeFilter.value = args['contestType'] ?? '';
      modelTypeFilter.value = args['modelType'] ?? '';
      customExamTypeFilter.value = args['customExamType'] ?? '';
    }
      // If no specific corner type is provided, default to Job Preparation Corner
    // Also treat "Jobs" corner type as Job Preparation Corner (shows all content)
    if (cornerType.value.isEmpty || cornerType.value == 'Jobs') {
      // Keep original type for display purposes
      if (originalCornerType.value.isEmpty) {
        originalCornerType.value = 'Job Preparation';
      }
      cornerType.value = 'Job Preparation';
      
      // For Jobs corner with exam type, use exam type ID as filter
      if (examTypeId.value.isNotEmpty) {
        contestTypeFilter.value = examTypeId.value;
        modelTypeFilter.value = examTypeId.value;
        customExamTypeFilter.value = examTypeId.value;
      } else {
        // Set default filter values for Job Preparation Corner (no filtering)
        contestTypeFilter.value = '';
        modelTypeFilter.value = '';
        customExamTypeFilter.value = '';
      }
    }
    
    _checkAuthAndLoadData();
  }
  /// Check authentication and load data if authenticated
  void _checkAuthAndLoadData() async {
    final cornerName = cornerType.value.isEmpty ? 'Job Preparation' : cornerType.value;
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: '$cornerName corner',
      customMessage: 'Please login to view $cornerName corner exams and tests.',
    );

    if (hasAccess) {
      fetchDataForSelectedTab();
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    fetchDataForSelectedTab();
  }

  void fetchDataForSelectedTab() {
    switch (selectedTabIndex.value) {
      case 0:
        fetchContests();
        break;
      case 1:
        fetchModelTests();
        break;
      case 2:
        fetchCustomExams();
        break;
    }
  }
  Future<void> fetchContests() async {
    isLoading.value = true;
    
    // Determine category and examType based on corner configuration
    String category = _getCategoryFromCornerType();
    String examType = _getExamTypeFromCornerType();
    
    final result = await _apiHelper.fetchContestsByCategory(
      category: category,
      examType: examType,
    );

    result.fold(
      (error) {
        log('Error fetching $category contests with examType $examType: ${error.message}');
        isLoading.value = false;
      },
      (contestsData) {
        contests.value = contestsData;
        isLoading.value = false;
        log('Fetched ${contests.length} contests for category: $category, examType: $examType');
      },
    );
  }
  Future<void> fetchModelTests() async {
    isLoading.value = true;
    
    // Determine category and examType based on corner configuration
    String category = _getCategoryFromCornerType();
    String examType = _getExamTypeFromCornerType();
    
    final result = await _apiHelper.fetchModelTestsByCategory(
      category: category,
      examType: examType,
    );

    result.fold(
      (error) {
        log('Error fetching $category model tests with examType $examType: ${error.message}');
        isLoading.value = false;
      },
      (modelTestsData) {
        modelTests.value = modelTestsData;
        isLoading.value = false;
        log('Fetched ${modelTests.length} model tests for category: $category, examType: $examType');
      },
    );
  }
  Future<void> fetchCustomExams() async {
    isLoading.value = true;

    // Determine category and examType based on corner configuration
    String category = _getCategoryFromCornerType();
    String examType = _getExamTypeFromCornerType();
    
    final result = await _apiHelper.fetchCustomExamsByCategory(
      category: category,
      examType: examType,
      page: customExamsPage.value,
      limit: 10,
    );

    result.fold(
      (error) {
        log('Error fetching $category custom exams with examType $examType: ${error.message}');
        isLoading.value = false;
      },
      (data) {
        if (customExamsPage.value == 1) {
          customExams.clear();
        }

        customExams.addAll(data);

        // Check if we've loaded all items
        customExamsHasMore.value = data.length == 10;

        isLoading.value = false;
        log('Fetched ${data.length} custom exams for category: $category, examType: $examType. Total: ${customExams.length}');
      },
    );
  }

  void loadMoreCustomExams() {
    if (!isLoading.value && customExamsHasMore.value) {
      customExamsPage.value++;
      fetchCustomExams();
    }
  }

  /// Helper method to determine API category from corner type
  String _getCategoryFromCornerType() {
    switch (cornerType.value.toLowerCase()) {
      case 'ssc':
        return 'ssc';
      case 'hsc':
        return 'hsc';
      case 'admission':
        return 'admission';
      case 'jobs':
      case 'job preparation':
        return 'job';
      default:
        return 'job'; // Default to job category
    }
  }

  /// Helper method to determine API examType from corner configuration
  String _getExamTypeFromCornerType() {
    switch (cornerType.value.toLowerCase()) {
      case 'ssc':
      case 'hsc':
        return ''; // Empty examType for SSC and HSC
      case 'admission':
        // For admission, use the specific admission type or default to 'mbbs'
        return admissionType.value.isNotEmpty ? admissionType.value.toLowerCase() : 'mbbs';
      case 'jobs':
      case 'job preparation':
        // For jobs, use the specific exam type ID or default to 'bcs'
        return examTypeId.value.isNotEmpty ? examTypeId.value : 'bcs';
      default:
        return 'bcs'; // Default to bcs for job category
    }
  }  String get cornerTitle {
    // Use original corner type for display if available
    final displayType = originalCornerType.value.isNotEmpty ? originalCornerType.value : cornerType.value;
    
    switch (displayType) {
      case 'SSC':
        return 'SSC Corner';
      case 'HSC':
        return 'HSC Corner';
      case 'Admission':
        if (admissionType.value.isNotEmpty) {
          return '${admissionType.value} Admission Corner';
        }
        return 'Admission Test Corner';
      case 'Jobs':
        // If a specific exam type is selected, show its title
        if (examTypeTitle.value.isNotEmpty) {
          return examTypeTitle.value;
        }
        return 'Jobs Corner';
      case 'Job Preparation':
        return 'Job Preparation Corner';
      default:
        return 'Job Preparation Corner'; // Default to Job Preparation Corner
    }
  }
}
