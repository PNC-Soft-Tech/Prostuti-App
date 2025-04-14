import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../modules/questions/models/question_model.dart';
import 'shared_question_options_widget.dart';

class SharedQuestionWidget extends StatelessWidget {
  final Question question;
  final int index;
  final bool isMarkedQuestion;
  final Function(String) onMarkQuestion;
  final bool isExplanationEnabled;
  final Widget? explanationWidget;
  final Function? onOptionSelected;

  const SharedQuestionWidget({
    Key? key,
    required this.question,
    required this.index,
    required this.isMarkedQuestion,
    required this.onMarkQuestion,
    this.isExplanationEnabled = false,
    this.explanationWidget,
    this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isMarkedQuestion)
              Container(
                width: 4.w,
                color: const Color(0xFFFF8143),
              ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(
                    '${index + 1}) ${question.title}',
                    customWidgetBuilder: (element) {
                      if (element.classes.contains('latex') ||
                          element.classes.contains('ql-syntax')) {
                        return Math.tex(
                          element.text,
                          textStyle: TextStyle(fontSize: 20),
                        );
                      }
                      return null;
                    },
                  ),
                  _buildMarkQuestionButton(),
                  SizedBox(height: 15.h),
                  SharedQuestionOptionsWidget(
                    question: question,
                    onOptionSelected: onOptionSelected,
                  ),
                  SizedBox(height: 15.h),
                  if (isExplanationEnabled && explanationWidget != null)
                    explanationWidget!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkQuestionButton() {
    return Row(
      children: [
        Icon(Icons.flag,
            color: isMarkedQuestion ? const Color(0xFFFF8143) : Colors.black),
        SizedBox(width: 5.w),
        GestureDetector(
          onTap: () => onMarkQuestion(question.id),
          child: Text(
            'Mark this Question',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: isMarkedQuestion ? const Color(0xFFFF8143) : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
