import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../modules/questions/models/option_model.dart';
import '../../modules/questions/models/question_model.dart';

class SharedQuestionOptionsWidget extends StatelessWidget {
  final Question question;
  final Function? onOptionSelected;
  final bool isSelected;
  final int? selectedOptionOrder;

  const SharedQuestionOptionsWidget({
    super.key,
    required this.question,
    this.onOptionSelected,
    this.isSelected = false,
    this.selectedOptionOrder,
  });

  @override
  Widget build(BuildContext context) {
    return question.isGrid == true
        ? _buildGridOptions()
        : _buildListOptions();
  }

  Widget _buildGridOptions() {
    if (question.options.isEmpty) {
      return const Text("No options");
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 16.h,
        children: question.options.map((option) => _buildOptionItem(option)).toList(),
      ),
    );
  }

  Widget _buildListOptions() {
    if (question.options.isEmpty) {
      return const Text("No options");
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: question.options.map((option) => _buildOptionItem(option)).toList(),
      ),
    );
  }

  Widget _buildOptionItem(Option option) {
    bool isOptionSelected = selectedOptionOrder == option.order;

    return GestureDetector(
      onTap: () => onOptionSelected?.call(option),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Row(
          children: [
            _buildSelectionIndicator(isOptionSelected),
            SizedBox(width: 8.w),
            Expanded(
              child: HtmlWidget(
                option.title,
                customWidgetBuilder: (element) {
                  if (element.classes.contains('latex') ||
                      element.classes.contains('ql-syntax')) {
                    return Math.tex(
                      element.text,
                      textStyle: const TextStyle(fontSize: 20),
                    );
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: Colors.black, width: 1),
        color: Colors.transparent,
      ),
      child: isSelected
          ? Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: const Color(0xFF50BDB4),
              ),
            )
          : const SizedBox(height: 20, width: 20),
    );
  }
}
