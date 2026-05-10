import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/history/controller/history_controller.dart';
import 'package:prostuti/app/routes/app_pages.dart';

const double _kHorizontalGutter = 20;

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
            Padding(
              padding: EdgeInsets.fromLTRB(_kHorizontalGutter.w, 8.h,
                  _kHorizontalGutter.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity',
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Your contests, tests and custom exams.',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: _kHorizontalGutter.w),
              child: const _HistoryTabSelector(),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(controller.selectedTabIndex.value),
                    child: _buildTabContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (controller.isLoading.value) {
      return const Center(
        child: CupertinoActivityIndicator(color: AppColors.primary),
      );
    }
    switch (controller.selectedTabIndex.value) {
      case 0:
        return _ContestList();
      case 1:
        return _ModelTestList();
      case 2:
        return _CustomExamList();
      default:
        return const SizedBox.shrink();
    }
  }
}

// ---------------------------------------------------------------------------
// Tab selector
// ---------------------------------------------------------------------------

class _HistoryTabSelector extends StatelessWidget {
  const _HistoryTabSelector();

  static const _labels = ['Contests', 'Model Tests', 'Custom Exams'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(() {
        final selected = controller.selectedTabIndex.value;
        return Row(
          children: List.generate(_labels.length, (i) {
            final isActive = selected == i;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9.r),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(9.r),
                    onTap: () => controller.changeTab(i),
                    child: Center(
                      child: Text(
                        _labels[i],
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive
                              ? AppColors.textPrimaryColor
                              : AppColors.gray,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty / list scaffolding
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          _kHorizontalGutter.w, 80.h, _kHorizontalGutter.w, 24.h),
      children: [
        Center(
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryOpacity,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36.sp, color: AppColors.primary),
          ),
        ),
        SizedBox(height: 18.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor,
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.gray,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _ContestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return Obx(() {
      if (controller.contests.isEmpty) {
        return const _EmptyState(
          icon: Icons.emoji_events_outlined,
          title: 'No contests yet',
          subtitle:
              'Once you participate in a contest it will show up here.',
        );
      }
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: EdgeInsets.fromLTRB(
            _kHorizontalGutter.w, 0, _kHorizontalGutter.w, 24.h),
        itemCount: controller.contests.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final contest = controller.contests[index];
          return _HistoryCard(
            icon: Icons.emoji_events_rounded,
            title: _stripHtml(contest.name) ?? 'Contest',
            description: _stripHtml(contest.description),
            stats: [
              _statQuestion(contest.questions.length),
              _statTime(contest.totalTime),
              _Stat(
                icon: Icons.calendar_today_rounded,
                label: Utils.formatDateToBangla(contest.startContest),
              ),
            ],
            onTap: () => Get.toNamed(
              Routes.contestDetails,
              arguments: {'contestId': contest.id},
            ),
          );
        },
      );
    });
  }
}

class _ModelTestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return Obx(() {
      if (controller.modelTests.isEmpty) {
        return const _EmptyState(
          icon: Icons.description_outlined,
          title: 'No model tests yet',
          subtitle:
              'Take a model test from Home and your attempts will appear here.',
        );
      }
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: EdgeInsets.fromLTRB(
            _kHorizontalGutter.w, 0, _kHorizontalGutter.w, 24.h),
        itemCount: controller.modelTests.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final mt = controller.modelTests[index];
          return _HistoryCard(
            icon: Icons.description_rounded,
            title: _stripHtml(mt.name) ?? 'Model Test',
            description: _stripHtml(mt.description),
            stats: [
              _statQuestion((mt.questions as List?)?.length ?? 0),
              _statTime(mt.totalTime),
            ],
            onTap: () => Get.toNamed(
              Routes.modelTestDetails,
              arguments: {'modelTestId': mt.id},
            ),
          );
        },
      );
    });
  }
}

class _CustomExamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return Obx(() {
      if (controller.customExams.isEmpty) {
        return const _EmptyState(
          icon: Icons.tune_rounded,
          title: 'No custom exams yet',
          subtitle:
              'Create a custom exam from More → Give a Custom Exam to get started.',
        );
      }
      final hasMore = controller.customExamsHasMore.value;
      return NotificationListener<ScrollNotification>(
        onNotification: (info) {
          if (info.metrics.pixels >= info.metrics.maxScrollExtent - 80) {
            controller.loadMoreCustomExams();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          padding: EdgeInsets.fromLTRB(
              _kHorizontalGutter.w, 0, _kHorizontalGutter.w, 24.h),
          itemCount: controller.customExams.length + (hasMore ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            if (index == controller.customExams.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const Center(
                  child:
                      CupertinoActivityIndicator(color: AppColors.primary),
                ),
              );
            }
            final exam = controller.customExams[index];
            return _CustomExamHistoryCard(exam: exam);
          },
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Cards
// ---------------------------------------------------------------------------

class _HistoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final List<_Stat> stats;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.icon,
    required this.title,
    required this.stats,
    required this.onTap,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.lightGray.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOpacity,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: AppColors.primary, size: 22.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSansBengali(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor,
                            height: 1.25,
                          ),
                        ),
                        if (description != null && description!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansBengali(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.gray,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.sp,
                    color: AppColors.lightGray,
                  ),
                ],
              ),
              if (stats.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 6.h,
                  children: stats.map(_renderStat).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderStat(_Stat s) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 14.sp, color: AppColors.gray),
          SizedBox(width: 4.w),
          Text(
            s.label,
            style: GoogleFonts.notoSansBengali(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.gray,
            ),
          ),
        ],
      );
}

class _CustomExamHistoryCard extends StatelessWidget {
  final Map<String, dynamic> exam;

  const _CustomExamHistoryCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    final name = (exam['name'] as String?) ?? 'Custom Exam';
    final totalQuestions = exam['totalQuestions'] as int? ?? 0;
    final totalTime = exam['totalTime'] as int? ?? 0;

    final selectedTopics = (exam['selectedTopics'] as List?) ?? const [];
    final subjects = <String>{};
    for (final t in selectedTopics) {
      if (t is Map) {
        final topic = t['topic'];
        if (topic is Map) {
          final subj = topic['subject'];
          if (subj is Map) {
            final n = subj['name'];
            if (n is String && n.isNotEmpty) subjects.add(n);
          }
        }
      }
    }

    return _HistoryCard(
      icon: Icons.tune_rounded,
      title: name,
      description: subjects.isEmpty ? null : subjects.join(' · '),
      stats: [
        _statQuestion(totalQuestions),
        _statTime(totalTime),
      ],
      onTap: () => Get.toNamed(
        Routes.customExamDetails,
        arguments: {'customExamId': exam['_id']},
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _Stat {
  final IconData icon;
  final String label;
  const _Stat({required this.icon, required this.label});
}

_Stat _statQuestion(int count) => _Stat(
      icon: Icons.help_outline_rounded,
      label: '${Utils.convertNumberToBengali(count)} প্রশ্ন',
    );

_Stat _statTime(dynamic minutes) {
  final m = (minutes is num) ? minutes.toInt() : 0;
  return _Stat(
    icon: Icons.schedule_rounded,
    label: '${Utils.convertNumberToBengali(m)} মিনিট',
  );
}

String? _stripHtml(String? input) {
  if (input == null) return null;
  final cleaned = input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  return cleaned.isEmpty ? null : cleaned;
}
