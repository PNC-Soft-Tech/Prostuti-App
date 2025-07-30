import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/custom_simple_appbar.dart';
import '../controller/corner_controller.dart';
import '../../history/view/history_view.dart'; // Import for reusing card components

class CornerView extends GetWidget<CornerController> {
  const CornerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(
        titleWidget: Obx(() => Text(
          controller.cornerTitle,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Tab buttons
            const CornerTabSelector(),
            SizedBox(height: 16.h),
            // Tab content
            Expanded(
              child: Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                        color: Colors.white,
                        child: _buildTabContent(
                            key: ValueKey(controller.selectedTabIndex.value))),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent({Key? key}) {
    if (controller.isLoading.value) {
      return _buildShimmerLoading(key: key);
    }

    switch (controller.selectedTabIndex.value) {
      case 0:
        return _buildContestList(key: key);
      case 1:
        return _buildModelTestList(key: key);
      case 2:
        return _buildCustomExamList(key: key);
      default:
        return Center(
          key: key,
          child: const Text('Invalid tab index'),
        );
    }
  }

  // Shimmer loading widget
  Widget _buildShimmerLoading({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header shimmer
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 80.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // List shimmer
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 6, // Show 6 shimmer cards
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: _buildShimmerCard(),
            ),
          ),
        ),
      ],
    );
  }

  // Individual shimmer card
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 8.h),
            // Subtitle shimmer
            Container(
              width: 200.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 12.h),
            // Bottom row shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 60.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestList({Key? key}) {
    if (controller.contests.isEmpty) {
      return Center(
        key: key,
        child: Text(
          'No contests found for ${controller.cornerTitle}',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimaryColor,
          ),
        ),
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.cornerTitle} Contests',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildSortDropdown('Sort by Date'),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.contests.length,
            itemBuilder: (context, index) {
              final contest = controller.contests[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.contestDetails,
                        arguments: {'contestId': contest.id});
                  },
                  child: ContestCard(contest: contest),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModelTestList({Key? key}) {
    if (controller.modelTests.isEmpty) {
      return Center(
        key: key,
        child: Text(
          'No model tests found for ${controller.cornerType.value}',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimaryColor,
          ),
        ),
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.cornerTitle} Model Tests',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildSortDropdown('Latest Tests'),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.modelTests.length,
            itemBuilder: (context, index) {
              final modelTest = controller.modelTests[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.modelTestDetails,
                        arguments: {'modelTestId': modelTest.id});
                  },
                  child: ModelTestCard(modelTest: modelTest),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomExamList({Key? key}) {
    if (controller.customExams.isEmpty) {
      return Center(
        key: key,
        child: Text(
          'No custom exams found for ${controller.cornerType.value}',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimaryColor,
          ),
        ),
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${controller.cornerTitle} Custom Exams',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildSortDropdown('Latest Tests'),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                controller.loadMoreCustomExams();
              }
              return true;
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.customExams.length +
                  (controller.customExamsHasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.customExams.length) {
                  return Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: const Center(
                        child: CupertinoActivityIndicator(color: AppColors.primary),
                      ),
                    ),
                  );
                }

                final customExam = controller.customExams[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.customExamDetails,
                          arguments: {'customExamId': customExam['_id']});
                    },
                    child: CustomExamCard(customExam: customExam),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.arrow_drop_down, size: 20.sp, color: Colors.grey),
        ],
      ),
    );
  }
}

class CornerTabSelector extends StatelessWidget {
  const CornerTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final CornerController controller = Get.find<CornerController>();

    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Obx(() {
          return Row(
            children: [
              _buildTabButton('Contests', 0, controller),
              _buildTabButton('Model Tests', 1, controller),
              _buildTabButton('Custom Exams', 2, controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTabButton(
      String title, int index, CornerController controller) {
    final isSelected = controller.selectedTabIndex.value == index;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26.r),
            onTap: () => controller.changeTab(index),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
