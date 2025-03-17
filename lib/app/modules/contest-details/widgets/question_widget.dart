import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../questions/models/question_model.dart';
import '../controller/contest_details_controller.dart';

import 'question_option_widget.dart';

class QuestionWidget extends GetWidget<ContestDetailsController> {
  final Question question;
  final int index;


  const QuestionWidget({
    Key? key,
    required this.question,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
          
          // Check if the title contains a base64 image
    bool containsBase64Image = question.title.contains("data:image");

    // Remove unnecessary HTML tags from the title (optional)
    String cleanedTitle =  question.title.replaceAll('<p>', '').replaceAll('</p>', '');
    return Obx((){

       return Container(
      key: controller.questionKeys[question.id],
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: controller.isMarkedQuestion(question.id),
              child: Container(
                width: 4.w,
                height: double.infinity,
                color: controller.isMarkedQuestion(question.id)
                    ? const Color(0xFFFF8143)
                    : Colors.black,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HtmlWidget("${index + 1}) ${question.title.replaceAll('<p>', '')}"),
                  HtmlWidget("${index + 1}) ${cleanedTitle}"),
                         if (containsBase64Image)
          // Render as HTML if it contains a Base64 image
          HtmlWidget(
            "$cleanedTitle",
            textStyle: TextStyle(fontSize: 16),
              onErrorBuilder: (context, element, error) {
    return Text('Failed to load HTML content.');
  },
  onLoadingBuilder: (context, element, loadingProgress) {
    return CircularProgressIndicator();
  },
buildAsync: true, 

          ),
                   Row(
                      children: [
                        Icon(Icons.flag,
                            color: controller.isMarkedQuestion(question.id)
                                ? const Color(0xFFFF8143)
                                : Colors.black),
                        SizedBox(
                          width: 5.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.markUnmarkQuestion(question.id);
                            debugPrint("qid-----> ${question.id}");
                          },
                          child: Text('Mark this Question',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: controller
                                              .isMarkedQuestion(question.id)
                                          ? const Color(0xFFFF8143)
                                          : Colors.black))),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  SizedBox(
                      height: 15.h,
                    ),
                  QuestionOptionsWidget(question: question), // ✅ Use the separated widget
                ],
              ),
            ),
          ],
        ),
      ),
    ); });
  }
}
