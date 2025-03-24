import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_bottom_fixed_button.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/questions/models/question_model.dart';

import '../../../common/custom_simple_appbar.dart';
import '../../../common/widgets/countdown_timer.dart';
import '../../contest-details/widgets/contest_action_widget.dart';
import '../../contest-details/widgets/contest_details_widget.dart';
import '../../contest-details/widgets/contest_status_widget.dart';
import '../../contest-details/widgets/question_navigator.dart';
import '../../contest-details/widgets/question_widget.dart';
import '../../contest-details/widgets/subject_tabs_widget.dart';
import '../../contests/controller/contest_controller.dart';
import '../../questions/widgets/question_widgets.dart';
import '../controllers/model_test_details_controller.dart';


class ModelTestDetailsView extends GetView<ModelTestDetailsController> {
  const ModelTestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isQuestionInViewport(String questionId) {
      final context = controller.questionKeys[questionId]?.currentContext;
      if (context == null) return false;

      final RenderBox box = context.findRenderObject() as RenderBox;
      final Offset offset = box.localToGlobal(Offset.zero);
      final double screenHeight = Get.height;
      final double widgetHeight = box.size.height;

      final double minVisibleY = 50.0; // Adjust if you have an AppBar
      final double maxVisibleY = screenHeight - 50.0; // Adjust for BottomBar

      return (offset.dy + widgetHeight > minVisibleY) &&
          (offset.dy < maxVisibleY);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(title: "${controller.modelDetails.value?.contest.name}"),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                  child: CupertinoActivityIndicator(
                color: AppColors.primary,
              ));
            } else {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    debugPrint(
                        "Scroll detected! ✅"); // ✅ Ensure this prints when scrolling

                    List<String> visibleIds = [];
                    for (var question in controller.filteredQuestions) {
                      if (isQuestionInViewport(question.id)) {
                        visibleIds.add(question.id);
                      }
                    }

                    debugPrint(
                        "Updated Visible Questions: $visibleIds ✅"); // ✅ Track visible questions
                    controller.updateVisibleQuestions(visibleIds);
                    return true;
                  },
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (!controller.isQuestionOpened.value)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  controller.modelDetails.value?.contest
                                                  .imageUrl !=
                                              null &&
                                          controller.modelDetails.value!
                                              .contest.imageUrl!
                                              .contains('http')
                                      ? Image.network(
                                          controller.modelDetails.value
                                                  ?.contest.imageUrl ??
                                              '',
                                          height: 34.r,
                                          width: 34.r,
                                        )
                                      : Image.asset(
                                          'assets/govt-bd.png',
                                          height: 34.r,
                                          width: 34.r,
                                        ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  HtmlWidget(controller
                                          .modelDetails.value?.contest.name ??
                                      "বিসিএস কনটেস্ট-০১")
                                  // Text(
                                  //   controller
                                  //           .contestDetails.value?.contest.name ??
                                  //       "বিসিএস কনটেস্ট-০১",
                                  //   style: GoogleFonts.notoSansBengali(
                                  //       textStyle: TextStyle(
                                  //     fontSize: 20.sp,
                                  //     color: AppColors.textPrimaryColor,
                                  //     fontWeight: FontWeight.w600,
                                  //   )),
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 19.h,
                              ),
                              Text(
                                " ${controller.modelDetails.value?.contest.stringTopics ?? 'গনিত - জ্যামিতি'}",
                                style: GoogleFonts.notoSansBengali(
                                    textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                )),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              // if (!controller.isQuestionOpened.value)
                              //   const ContestStatusWidget(), // ✅ Displays running or countdown UI
                              if (!controller.isQuestionOpened.value)
                                const ContestDetailsWidget(), // ✅ Displays contest details
                            ],
                          ),
                          Text("Length: ${controller.filteredQuestions.length}"),
                        SizedBox(
                          height: 20.h,
                        ),
                   
                        Obx(() {
                          final filteredQuestions =
                              controller.filteredQuestions; // Use filtered list

                          return Column(
                            children: List.generate(filteredQuestions.length,
                                (index) {
                              // ✅ Find the correct index in the full question list
                              final originalIndex = controller
                                  .modelDetails.value?.contest.questions
                                  .indexWhere(
                                (q) => q.id == filteredQuestions[index].id,
                              );
                              return   
                              
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: QuestionWidget(
                                  // key: controller.questionKeys[filteredQuestions[index].id],
                                  question: filteredQuestions[index],
                                  index: originalIndex ?? index,
                                ),
                              );
                            }),
                          );
                        }),
                        SizedBox(
                          height: 80.h,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
          // const ContestActionWidget(), // ✅ Handles submit/register buttons
          const QuestionNavigatorWidget(), // ✅ Handles floating question navigator
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  color: Colors.white, child: SubjectTabsWidget())),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
