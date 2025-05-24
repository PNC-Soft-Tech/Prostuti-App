import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../models/model_tests_list_response.dart';

class ModelTestsListController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  // Observable state
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var modelTestsResponse = Rxn<ModelTestsListResponse>();
  var modelTests = <ModelTestListItem>[].obs;
  var filteredModelTests = <ModelTestListItem>[].obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMore = false.obs;

  // Search and Filter
  var searchController = TextEditingController();
  var searchQuery = ''.obs;
  var selectedFilter = 'All'.obs;

  // Filter options
  final List<String> filterOptions = [
    'All',
    'Recent',
    'Most Questions',
    'Highest Marks',
    'BCS Tests',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchModelTests();
    
    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterModelTests();
    });

    // Listen to filter changes
    ever(searchQuery, (_) => _filterModelTests());
    ever(selectedFilter, (_) => _filterModelTests());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  Future<void> fetchModelTests({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      modelTests.clear();
    }

    isLoading.value = isRefresh ? true : currentPage.value == 1;

    try {
      // Use the existing fetchAllModelTests method first, then add pagination support later
      final result = await _apiHelper.fetchAllModelTests();
      
      result.fold(
        (error) {
          log('Error fetching model tests: ${error.message}');
          Get.snackbar(
            'Error', 
            'Failed to fetch model tests: ${error.message}',
            snackPosition: SnackPosition.BOTTOM,
          );
        },        (modelTestsData) {
          // Convert ModelTest to ModelTestListItem
          final listItems = modelTestsData.map((modelTest) => ModelTestListItem(
            id: modelTest.id,
            name: modelTest.name ?? 'Unnamed Test',
            description: modelTest.description ?? '',
            totalMarks: (modelTest.totalMarks is int) ? modelTest.totalMarks : (modelTest.totalMarks?.toInt() ?? 0),
            totalTime: modelTest.totalTime ?? 0,
            questions: modelTest.questions.map((q) => q.id).toList(),
            user: 'System', // Default value since not available in ModelTest
            createdAt: modelTest.startContest, // Use startContest as createdAt
            updatedAt: modelTest.endContest, // Use endContest as updatedAt
          )).toList();
          
          if (isRefresh) {
            modelTests.value = listItems;
          } else {
            modelTests.addAll(listItems);
          }
          
          // For now, simulate pagination with all data
          totalPages.value = 1;
          hasMore.value = false;
          
          _filterModelTests();
          
          log('Fetched ${listItems.length} model tests. Total: ${modelTests.length}');
        },
      );
    } catch (e) {
      log('Error fetching model tests: $e');
      Get.snackbar(
        'Error', 
        'Network error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreModelTests() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++;
    
    await fetchModelTests();
  }

  Future<void> refreshModelTests() async {
    await fetchModelTests(isRefresh: true);
  }

  void _filterModelTests() {
    List<ModelTestListItem> filtered = List.from(modelTests);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((test) {
        final query = searchQuery.value.toLowerCase();
        return test.cleanName.toLowerCase().contains(query) ||
               test.cleanDescription.toLowerCase().contains(query);
      }).toList();
    }

    // Apply category filter
    switch (selectedFilter.value) {
      case 'Recent':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Most Questions':
        filtered.sort((a, b) => b.questionCount.compareTo(a.questionCount));
        break;
      case 'Highest Marks':
        filtered.sort((a, b) => b.totalMarks.compareTo(a.totalMarks));
        break;
      case 'BCS Tests':
        filtered = filtered.where((test) {
          final name = test.cleanName.toLowerCase();
          return name.contains('bcs') || name.contains('বিসিএস');
        }).toList();
        break;
      case 'All':
      default:
        // Keep original order or sort by creation date
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    filteredModelTests.value = filtered;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void navigateToModelTest(ModelTestListItem modelTest) {
    // Show access mode bottom sheet
    Get.bottomSheet(
      _buildAccessModeBottomSheet(modelTest),
      backgroundColor: Colors.transparent,
      isDismissible: true,
    );
  }
  Widget _buildAccessModeBottomSheet(ModelTestListItem modelTest) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose Access Mode',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            modelTest.cleanName,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Read Mode',
                  description: 'Learn with solutions',
                  color: Colors.green,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/model-test-details/', arguments: {
                      'modelTestId': modelTest.id,
                      'mode': 'read',
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModeCard(
                  icon: Icons.quiz_rounded,
                  title: 'Exam Mode',
                  description: 'Timed practice test',
                  color: Colors.blue,
                  onTap: () {
                    Get.back();
                    Get.toNamed('/model-test-details/', arguments: {
                      'modelTestId': modelTest.id,
                      'mode': 'exam',
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
