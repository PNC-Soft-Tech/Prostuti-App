import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../custom-exam/widgets/custom_exam_home_card_widget.dart';
import '../../exam-topics/widgets/exam_topics_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';
import '../../job-circulars/widgets/job_circular_home_widget.dart';
import '../../model-tests/widgets/model_test_home_widget.dart';
import 'exam_corners_widget.dart';
import '../controller/home_controller.dart';

class HomeMainWidget extends GetWidget<HomeController> {
  const HomeMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 19.w),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // FutureBuilder<String?>(
            //   future: StorageHelper.getUserData(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData && snapshot.data != null) {
            //       try {
            //         final userData = jsonDecode(snapshot.data!);
            //         final fullName = userData['fullName'] as String? ?? 'User';
            //         return Text(
            //           'Hi $fullName',
            //           style: TextStyle(
            //               fontSize: 16.sp, fontWeight: FontWeight.w600),
            //         );
            //       } catch (e) {
            //         print('Error parsing user data: $e');
            //         return Text(
            //           'Hi User',
            //           style: TextStyle(
            //               fontSize: 16.sp, fontWeight: FontWeight.w600),
            //         );
            //       }
            //     }
            //     if (snapshot.hasError) {
            //       return Text(
            //         'Hi User',
            //         style:
            //             TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            //       );
            //     }
            //     return const CircularProgressIndicator();
            //   },
            // ),            const ContestHomeCardsWrapperWidget(),
            SizedBox(height: 23.h),
            const ExamCornersWidget(),
            SizedBox(height: 23.h),
            const ExamCategoriesWidget(),
            SizedBox(height: 23.h),
            const ExamTopicsWidget(),
            SizedBox(height: 23.h),
            const ModelTestHomeWidget(),
            SizedBox(height: 23.h),
            const JobCircularHomeWidget(),
            SizedBox(height: 23.h),
            const CustomExamHomeCardWidget()
          ],
        ),
      ),
    );
  }
}
