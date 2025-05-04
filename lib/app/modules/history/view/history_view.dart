import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/history/controller/history_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class HistoryView extends GetWidget<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              const BorderedButtonGroup(),
              SizedBox(height: 16.h),
              Obx(() => _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    switch (controller.selectedTabIndex.value) {
      case 0:
        return _buildContestList();
      case 1:
        return _buildModelTestList();
      case 2:
        return _buildCustomExamList();
      default:
        return const Center(child: Text('Invalid tab index'));
    }
  }

  Widget _buildContestList() {
    if (controller.contests.isEmpty) {
      return Center(
        child: Text(
          'No contest history found',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimaryColor,
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contest List',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<String>(
              value: 'Sort By Date',
              icon: Icon(Icons.arrow_drop_down, size: 20.sp),
              underline: Container(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
              onChanged: (String? newValue) {
                print('Selected: $newValue');
              },
              items: <String>['Sort By Date', 'Sort By Rank', 'Sort By Point']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.contests.length,
          itemBuilder: (context, index) {
            final contest = controller.contests[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.contestDetails, arguments: {'contestId': contest.id});
                },
                child: ContestCard(contest: contest),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModelTestList() {
    if (controller.modelTests.isEmpty) {
      return Center(
        child: Text(
          'No model test history found',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimaryColor,
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Model Test List',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<String>(
              value: 'Sort By Date',
              icon: Icon(Icons.arrow_drop_down, size: 20.sp),
              underline: Container(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
              onChanged: (String? newValue) {
                print('Selected: $newValue');
              },
              items: <String>['Sort By Date', 'Sort By Score']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.modelTests.length,
          itemBuilder: (context, index) {
            final modelTest = controller.modelTests[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.modelTestDetails, arguments: {'modelTestId': modelTest.id});
                },
                child: ModelTestCard(modelTest: modelTest),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomExamList() {
    if (controller.customExams.isEmpty) {
      return Center(
        child: Text(
          'No custom exam history found',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textPrimaryColor,
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Custom Exam List',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<String>(
              value: 'Sort By Date',
              icon: Icon(Icons.arrow_drop_down, size: 20.sp),
              underline: Container(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ),
              onChanged: (String? newValue) {
                print('Selected: $newValue');
              },
              items: <String>['Sort By Date', 'Sort By Score']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.customExams.length,
          itemBuilder: (context, index) {
            final customExam = controller.customExams[index];
            
            // Load more data when reaching the end
            if (index == controller.customExams.length - 2 && controller.customExamsHasMore.value) {
              controller.loadMoreCustomExams();
            }
            
            return Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.customExamDetails, arguments: {'customExamId': customExam['_id']});
                },
                child: CustomExamCard(customExam: customExam),
              ),
            );
          },
        ),
        
        // Show loading indicator when loading more data
        Obx(() => Visibility(
          visible: controller.isLoading.value && controller.customExamsPage.value > 1,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        )),
      ],
    );
  }
}

class BorderedButtonGroup extends StatelessWidget {
  const BorderedButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find<HistoryController>();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      height: 50.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.textPrimaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildButton('Contests', 0, controller)),
          Expanded(child: _buildButton('Model Tests', 1, controller)),
          Expanded(child: _buildButton('Custom Exams', 2, controller)),
        ],
      ),
    );
  }

  Widget _buildButton(String title, int index, HistoryController controller) {
    return Obx(() {
      final isSelected = controller.selectedTabIndex.value == index;
      
      return TextButton(
        onPressed: () {
          controller.changeTab(index);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 7),
          minimumSize: const Size(0, 0),
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      );
    });
  }
}

class ContestCard extends StatelessWidget {
  final dynamic contest;
  
  const ContestCard({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    final String contestName = contest.name?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'Unnamed Contest';
    final String? description = contest.description?.replaceAll(RegExp(r'<[^>]*>'), '');
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (contest.imageUrl != null)
                        Image.network(
                          contest.imageUrl,
                          height: 28,
                          width: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/govt-bd.png',
                              height: 28,
                              width: 28,
                            );
                          },
                        )
                      else
                        Image.asset(
                          'assets/govt-bd.png',
                          height: 28,
                          width: 28,
                        ),
                      SizedBox(width: 9.w),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          contestName,
                          style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (description != null) ...[
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        description,
                        style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${contest.totalMarks} Marks',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    '${contest.totalTime} mins',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(contest.startContest)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ModelTestCard extends StatelessWidget {
  final dynamic modelTest;
  
  const ModelTestCard({super.key, required this.modelTest});

  @override
  Widget build(BuildContext context) {
    final String modelTestName = modelTest.name?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'Unnamed Model Test';
    final String? description = modelTest.description?.replaceAll(RegExp(r'<[^>]*>'), '');
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.rule_folder, size: 28, color: AppColors.primary),
                      SizedBox(width: 9.w),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          modelTestName,
                          style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (description != null) ...[
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        description,
                        style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${modelTest.questions.length} Q',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    '${modelTest.totalTime} mins',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(modelTest.startContest),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomExamCard extends StatelessWidget {
  final Map<String, dynamic> customExam;
  
  const CustomExamCard({super.key, required this.customExam});

  @override
  Widget build(BuildContext context) {
    final String examName = customExam['name'] ?? 'Unnamed Exam';
    final int totalMarks = customExam['totalMarks'] as int? ?? 0;
    final int totalTime = customExam['totalTime'] as int? ?? 0;
    final List<dynamic> selectedTopics = customExam['selectedTopics'] as List<dynamic>? ?? [];
    
    // Get subjects from topics
    final Set<String> subjects = {};
    for (var topicData in selectedTopics) {
      final topic = topicData['topic'] as Map<String, dynamic>?;
      if (topic != null && topic['subject'] != null) {
        final subjectName = topic['subject']['name'] as String?;
        if (subjectName != null) {
          subjects.add(subjectName);
        }
      }
    }
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment, size: 28, color: AppColors.primary),
                      SizedBox(width: 9.w),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          examName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (subjects.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        subjects.join(', '),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$totalMarks Marks',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    '$totalTime mins',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                'Topics: ${selectedTopics.length}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
