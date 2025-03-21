import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latext/latext.dart';

import '../../../common/utils/prostuti_html_renderer.dart';
import '../../../common/utils/prostuti_utils.dart';
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
    // Step 1: Strip HTML tags and handle entities
    String cleanTitle = Utils.stripHtmlTags(question.title)
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&');

    // Step 2: Check if the LaTeX content is correctly formatted
    String latexFormatted = r'$\displaystyle ' +
        cleanTitle.replaceAll(RegExp(r'\$'), '\\\$') +
        r'$';
    print("LaTeX String: $latexFormatted"); // Print LaTeX content for debugging

    return Obx(() {
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

            //         Utils.containsFormulaExpression(question.title)
            //             ? TeXView(
            //                 child: TeXViewDocument(
            //                   """
            // <div>
            //   <p>Here is the question:</p>
            
            //   <p>Another LaTeX example: 
            //     \\(\\int_{0}^{\\infty} e^{-x^2} dx\\)
            //   </p>
            // </div>
            // """,
            //                   style: TeXViewStyle(
            //                     textAlign: TeXViewTextAlign.left,
            //                   ),
            //                 ),
            //                 loadingWidgetBuilder: (_) =>
            //                     Center(child: CircularProgressIndicator()),
            //               )
            //             : HtmlWidget(
            //                 "${index + 1}) ${question.title.replaceAll('<p>', '')}"),
                
                 Utils.containsFormulaExpression(question.title)
                        ?
                    Builder(builder: (context) {
                      String formattedTitle =
                          question.title; // Get the title from API
                      String cleanTitle = Utils.stripHtmlTags(question.title)
                          .replaceAll('&nbsp;', ' ')
                          .replaceAll('&amp;', '&');

                      // For debugging
                      print("LaTeX content: $cleanTitle");
                      formattedTitle = r'$\displaystyle ' +
                          Utils.stripHtmlTags(formattedTitle)
                              .replaceAll(RegExp(r'\$'), '\\\$') +
                          r'$'; // Properly escape $

                      // Check the title to debug
                      print("Formatted LaTeX: $cleanTitle");
                      return LaTexT(  equationStyle: GoogleFonts.notoSansBengali(
                                        textStyle: 
                              
                              TextStyle(fontSize: 15)),
                          laTeXCode: Text(formattedTitle,
                              style: GoogleFonts.notoSansBengali(
                                        textStyle: 
                              
                              TextStyle(fontSize: 15))));
                    }):HtmlWidget(
                            "${index + 1}) ${question.title.replaceAll('<p>', '')}"),
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
                    QuestionOptionsWidget(
                        question: question), // ✅ Use the separated widget
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
