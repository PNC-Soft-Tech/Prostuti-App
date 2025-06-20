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
      examTypeId.value = args['examTypeId'] ?? '';
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
    
    // If contestTypeFilter is empty, fetch all contests (Job Preparation Corner)
    // Otherwise use filtered API call
    final result = contestTypeFilter.value.isEmpty
        ? await _apiHelper.fetchAllContests()
        : await _apiHelper.fetchFilteredContests(contestTypeFilter.value);

    result.fold(
      (error) {
        log('Error fetching ${cornerType.value} contests: ${error.message}');
        isLoading.value = false;
      },
      (contestsData) {
        contests.value = contestsData;
        isLoading.value = false;
        log('Fetched ${contests.length} ${cornerType.value} contests');
      },
    );
  }
  Future<void> fetchModelTests() async {
    isLoading.value = true;
    
    // If modelTypeFilter is empty, fetch all model tests (Job Preparation Corner)
    // Otherwise use filtered API call
    final result = modelTypeFilter.value.isEmpty
        ? await _apiHelper.fetchAllModelTests()
        : await _apiHelper.fetchFilteredModelTests(modelTypeFilter.value);

    result.fold(
      (error) {
        log('Error fetching ${cornerType.value} model tests: ${error.message}');
        isLoading.value = false;
      },
      (modelTestsData) {
        modelTests.value = modelTestsData;
        isLoading.value = false;
        log('Fetched ${modelTests.length} ${cornerType.value} model tests');
      },
    );
  }
  Future<void> fetchCustomExams() async {
    isLoading.value = true;

    // If customExamTypeFilter is empty, fetch all custom exams (Job Preparation Corner)
    // Otherwise use filtered API call
    final result = customExamTypeFilter.value.isEmpty
        ? await _apiHelper.fetchCustomExams(
            page: customExamsPage.value,
            limit: 10,
          )
        : await _apiHelper.fetchFilteredCustomExams(
            customExamTypeFilter: customExamTypeFilter.value,
            page: customExamsPage.value,
            limit: 10,
          );

    result.fold(
      (error) {
        log('Error fetching ${cornerType.value} custom exams: ${error.message}');
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
        log('Fetched ${data.length} ${cornerType.value} custom exams. Total: ${customExams.length}');
      },
    );
  }

  void loadMoreCustomExams() {
    if (!isLoading.value && customExamsHasMore.value) {
      customExamsPage.value++;
      fetchCustomExams();
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
