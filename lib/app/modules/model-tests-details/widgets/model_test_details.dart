import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../constant/app_color.dart';
import '../controllers/model_test_details_controller.dart';


class ModelTestDetailsWidget extends GetWidget<ModelTestDetailsController> {
  const ModelTestDetailsWidget({super.key});

  /// ✅ Left Column Row (Label & Icon)
  Widget _buildLeftColumnRow({required String img, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Image.asset(img),
          SizedBox(width: 12.53.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Right Column Row (Value)
  Widget _buildRightColumnRow({required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.sp,
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ✅ Main Contest Details Widget
  Widget _buildDetailsWidget() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: Get.width / 3,
              child: Column(
                children: [
                  _buildLeftColumnRow(title: "বিষয়", img: 'assets/subject.png'),
                  _buildLeftColumnRow(title: "সর্বমান", img: 'assets/total-marks.png'),
                  _buildLeftColumnRow(title: "সময়", img: 'assets/total-time.png'),
                  // _buildLeftColumnRow(title: "প্রতিযোগী", img: 'assets/participiants.png'),
                  _buildLeftColumnRow(title: "লাস্ট পড়াঃ", img: 'assets/contest-start.png'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRightColumnRow(
                    value: "${controller.modelDetails.value?.contest.stringTopics}",
                  ),
                  _buildRightColumnRow(
                    value: "${controller.modelDetails.value?.contest.totalMarks} মার্কস",
                  ),
                  _buildRightColumnRow(
                    value: "${controller.modelDetails.value?.contest.totalTime} মিনিট",
                  ),
                  // _buildRightColumnRow(
                  //   value: "${controller.modelDetails.value?.contest.registeredCount} জন",
                  // ),
                  _buildRightColumnRow(
                    value: Utils.formatDateToBangla(
                      controller.modelDetails.value?.contest.endContest ?? DateTime.now(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDetailsWidget();
  }
}
