import 'package:get/get.dart';
import 'dart:developer';
import '../../../APIs/api_helper.dart';
import '../../contests/models/contest_model.dart';
import '../../model-tests/models/model_test_model.dart';
import '../../custom-exam-details/models/custom_exam_response_model.dart';

class HistoryController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  
  // Observable variables
  var isLoading = false.obs;
  var selectedTabIndex = 0.obs;
  
  // Data for each tab
  var contests = <Contest>[].obs;
  var modelTests = <ModelTest>[].obs;
  var customExams = <Map<String, dynamic>>[].obs;
  
  // Pagination variables
  var customExamsPage = 1.obs;
  var customExamsHasMore = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchDataForSelectedTab();
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
    final result = await _apiHelper.fetchAllContests();
    
    result.fold(
      (error) {
        log('Error fetching contests: ${error.message}');
        isLoading.value = false;
      },
      (contestsData) {
        contests.value = contestsData;
        isLoading.value = false;
        log('Fetched ${contests.length} contests');
      },
    );
  }
  
  Future<void> fetchModelTests() async {
    isLoading.value = true;
    final result = await _apiHelper.fetchAllModelTests();
    
    result.fold(
      (error) {
        log('Error fetching model tests: ${error.message}');
        isLoading.value = false;
      },
      (modelTestsData) {
        modelTests.value = modelTestsData;
        isLoading.value = false;
        log('Fetched ${modelTests.length} model tests');
      },
    );
  }
  
  Future<void> fetchCustomExams() async {
    isLoading.value = true;
    
    final result = await _apiHelper.fetchCustomExams(
      page: customExamsPage.value,
      limit: 10
    );
    
    result.fold(
      (error) {
        log('Error fetching custom exams: ${error.message}');
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
        log('Fetched ${data.length} custom exams. Total: ${customExams.length}');
      },
    );
  }
  
  void loadMoreCustomExams() {
    if (!isLoading.value && customExamsHasMore.value) {
      customExamsPage.value++;
      fetchCustomExams();
    }
  }
}
