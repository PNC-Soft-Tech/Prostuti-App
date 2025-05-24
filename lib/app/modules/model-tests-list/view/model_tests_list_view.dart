import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../constant/app_color.dart';
import '../controller/model_tests_list_controller.dart';
import '../widgets/model_test_card.dart';
import '../widgets/model_tests_search_bar.dart';
import '../widgets/model_tests_filter_chips.dart';
import '../widgets/model_tests_empty_state.dart';
import '../widgets/model_tests_loading_card.dart';

class ModelTestsListView extends GetView<ModelTestsListController> {
  const ModelTestsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomSimpleAppBar.appBar(
        titleWidget: Text(
          'Model Tests',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: controller.refreshModelTests,
          ),
        ],
      ),
      body: Column(        children: [
          // Search Bar
          Obx(() => ModelTestsSearchBar(
            searchController: controller.searchController,
            onClear: controller.clearSearch,
            searchQuery: controller.searchQuery.value,
          )),

          // Filter Chips
          Obx(() => ModelTestsFilterChips(
                filterOptions: controller.filterOptions,
                selectedFilter: controller.selectedFilter.value,
                onFilterSelected: controller.selectFilter,
              )),

          // Results Count
          Obx(() {
            if (controller.isLoading.value && controller.modelTests.isEmpty) {
              return const SizedBox.shrink();
            }
            
            final totalCount = controller.filteredModelTests.length;
            final searchQuery = controller.searchQuery.value;
            final selectedFilter = controller.selectedFilter.value;
            
            String resultText = '$totalCount model tests';
            if (searchQuery.isNotEmpty) {
              resultText += ' for "$searchQuery"';
            }
            if (selectedFilter != 'All') {
              resultText += ' in $selectedFilter';
            }
            
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                resultText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),

          // Main Content
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value && controller.modelTests.isEmpty) {
                return _buildLoadingList();
              }

              // Empty state
              if (controller.filteredModelTests.isEmpty && !controller.isLoading.value) {
                if (controller.searchQuery.value.isNotEmpty || controller.selectedFilter.value != 'All') {
                  return ModelTestsEmptyState(
                    message: 'No results found',
                    subtitle: 'Try adjusting your search or filter criteria',
                    onRetry: controller.refreshModelTests,
                  );
                } else {
                  return ModelTestsEmptyState(
                    message: 'No model tests available',
                    subtitle: 'Check back later for new model tests',
                    onRetry: controller.refreshModelTests,
                  );
                }
              }

              // Main list
              return RefreshIndicator(
                onRefresh: controller.refreshModelTests,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.filteredModelTests.length + 
                            (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading more indicator
                    if (index == controller.filteredModelTests.length) {
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final modelTest = controller.filteredModelTests[index];
                    
                    // Load more when near the end
                    if (index == controller.filteredModelTests.length - 2) {
                      controller.loadMoreModelTests();
                    }

                    return ModelTestCard(
                      modelTest: modelTest,
                      onTap: () => controller.navigateToModelTest(modelTest),
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

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 6,
      itemBuilder: (context, index) => const ModelTestsLoadingCard(),
    );
  }
}
