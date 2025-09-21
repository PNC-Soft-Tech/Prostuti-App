import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/history/controller/history_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';

class HistoryView extends GetWidget<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Tab buttons
            const TabSelector(),
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
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          key: key,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15.h, left: 16.w, right: 16.w),
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          },
        ),
      );
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

  Widget _buildContestList({Key? key}) {
    if (controller.contests.isEmpty) {
      return Center(
        key: key,
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
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contests List',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildSortDropdown('Sort by Date'),
          ],
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
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
          'No model test history found',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Model Tests List',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildSortDropdown('Latest Tests'),
          ],
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
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
          'No custom exam history found',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Custom Exams List',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            _buildSortDropdown('Latest Tests'),
          ],
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
              itemCount: controller.customExams.length +
                  (controller.customExamsHasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.customExams.length) {
                  return Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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

class TabSelector extends StatelessWidget {
  const TabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find<HistoryController>();

    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          30.r,
        ),
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
      String title, int index, HistoryController controller) {
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

class ContestCard extends StatelessWidget {
  final dynamic contest;

  const ContestCard({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    final String contestName =
        contest.name?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'Unnamed Contest';
    final String? description =
        contest.description?.replaceAll(RegExp(r'<[^>]*>'), '');
    final int score = (contest.totalMarks as num?)?.toInt() ?? 0;
    const int maxScore = 100;

    print('\ncontest.totalTime: ${contest.totalTime}');
    print('contest.startContest: ${contest.startContest}');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        // divides two row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // name, desc mark | rank
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                // name, desc, mark
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (contest.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            contest.imageUrl,
                            height: 28,
                            width: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultContestIcon(),
                          ),
                        )
                      else
                        _buildDefaultContestIcon(),
                      SizedBox(
                        width: 9.w,
                      ),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 250.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contestName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSansBengali(
                                  textStyle: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColors.textPrimaryColor,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    SizedBox(height: 10.w),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 300.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansBengali(
                              textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // other children...
                        ],
                      ),
                    )
                  ],
                  SizedBox(height: 10.w),
                  Row(
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        '/$maxScore',
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
              //
              _buildRankBadge(123),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            // time, date | view details
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/total-time.png',
                    scale: 1.5,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                      '${Utils.convertNumberToBengali(contest.totalTime)} মিনিট',
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor))),
                  SizedBox(width: 10.w),
                  Image.asset(
                    'assets/contest-start.png',
                    scale: 1.5,
                  ),
                  SizedBox(width: 4.w),
                  Text(Utils.formatDateToBangla(contest.startContest),
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor))),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View Details',
                  style: TextStyle(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      decorationColor: AppColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContestIcon() {
    return Container(
      height: 28.h,
      width: 28.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.emoji_events,
        color: AppColors.primary,
        size: 24.sp,
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          'assets/rank/rank-top.svg',
          width: 50.w,
        ),
        Positioned(
          bottom: -22.w,
          left: 12.w,
          child: SvgPicture.asset(
            'assets/rank/rank-star.svg',
            width: 25.w,
            height: 25.h,
          ),
        ),
        Positioned(
          top: 3.w,
          left: 15.w,
          right: 0,
          child: const Text(
            '20',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class ModelTestCard extends StatelessWidget {
  final dynamic modelTest;

  const ModelTestCard({super.key, required this.modelTest});

  @override
  Widget build(BuildContext context) {
    final String modelTestName =
        modelTest.name?.replaceAll(RegExp(r'<[^>]*>'), '') ??
            'Unnamed Model Test';
    final String? description =
        modelTest.description?.replaceAll(RegExp(r'<[^>]*>'), '');
    // final String? topics = modelTest?.stringTopics.replaceAll(RegExp(r'<[^>]*>'), '');
    final int score = (modelTest.totalMarks as num?)?.toInt() ?? 0;
    final int maxScore = 100;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        // divides two row
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // name, desc mark | rank
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                // name, desc, mark
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.description,
                          color: Colors.blue,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(
                        width: 9.w,
                      ),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 250.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modelTestName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSansBengali(
                                  textStyle: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColors.textPrimaryColor,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    SizedBox(height: 10.w),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 350.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansBengali(
                              textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // other children...
                        ],
                      ),
                    )
                  ],
                  SizedBox(height: 10.w),
                  Row(
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        '/$maxScore',
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            // time, date | view details
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.question_mark_outlined,
                      size: 16.sp, color: AppColors.textPrimaryColor),
                  SizedBox(width: 4.w),
                  Text(
                      '${Utils.convertNumberToBengali(modelTest.questions.length)} প্রশ্ন',
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor))),
                  SizedBox(width: 10.w),
                  Row(
                    children: [
                      Image.asset(
                        'assets/total-time.png',
                        scale: 1.5,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                          '${Utils.convertNumberToBengali(modelTest.totalTime)} মিনিট',
                          style: GoogleFonts.notoSansBengali(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textPrimaryColor))),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View Details',
                  style: TextStyle(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      decorationColor: AppColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/*

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.description,
            color: Colors.blue,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                modelTestName,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),

    // SizedBox(height: 12.h),
    // Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
    // SizedBox(height: 12.h),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null && description.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              '$score',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
            ),
            Text(
              '/$maxScore',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    ),

    // Footer
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.help_outline, size: 16.sp, color: Colors.grey),
            SizedBox(width: 4.w),
            Text(
              '${modelTest.questions.length} questions',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
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
        Stack(
          children: [
            Text(
              'View Details',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Divider(
                  height: 1,
                  color: AppColors.primary,
                  thickness: 1,
                  indent: 4.w,
                  endIndent: 4.w,
                ))
          ],
        ),
      ],
    ),
  ],
)

*/
class CustomExamCard extends StatelessWidget {
  final Map<String, dynamic> customExam;

  const CustomExamCard({super.key, required this.customExam});

  @override
  Widget build(BuildContext context) {
    final String examName = customExam['name'] ?? 'Unnamed Exam';
    final int totalMarks = customExam['totalMarks'] as int? ?? 0;
    final int totalTime = customExam['totalTime'] as int? ?? 0;
    final List<dynamic> selectedTopics =
        customExam['selectedTopics'] as List<dynamic>? ?? [];

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

    // Create subject chips
    final List<Widget> subjectChips = subjects
        .map((subject) => Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                // color: Color(0XFF50AFFF26),
                color: AppColors.primary.withOpacity(0.28),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                subject,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black,
                ),
              ),
            ))
        .toList();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0XFF212D4033)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 0,
        //     blurRadius: 6,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              // Container(
              //   height: 40.h,
              //   width: 40.w,
              //   decoration: BoxDecoration(
              //     color: Colors.green.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(8.r),
              //   ),
              //   child: Icon(
              //     Icons.assignment,
              //     color: Colors.green,
              //     size: 24.sp,
              //   ),
              // ),
              // SizedBox(width: 12.w),
              Flexible(
                child: Text(
                  examName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // SizedBox(height: 12.h),
          // Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          SizedBox(height: 12.h),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              if (subjectChips.isNotEmpty)
                Wrap(
                    //color bg based on  primaryColor
                    spacing: 4.w,
                    runSpacing: 4.h,
                    children: subjectChips),
            ],
          ),
          SizedBox(height: 12.h),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    '$totalMarks questions',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
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
              Stack(
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Divider(
                        height: 1,
                        color: AppColors.primary,
                        thickness: 1,
                        indent: 4.w,
                        endIndent: 4.w,
                      ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
