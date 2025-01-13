import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../exam-topics/widgets/exam_topics_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [
         const ExamCategoriesWidget(),
            SizedBox(height: 23.h),
            const ExamTopicsWidget(),
            SizedBox(height: 23.h),
    ],),);
  }
}