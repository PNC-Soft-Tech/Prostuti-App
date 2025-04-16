import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/modules/ranking/controllers/ranking_controller.dart';
import 'package:prostuti/app/constant/app_color.dart'; // Assuming you have this constant file

class RankingFilterBottomSheet extends StatelessWidget {
  const RankingFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the controller to bind the selected values
    final controller = Get.find<RankingController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title of the bottom sheet
            Text(
              'Select Ranking Type',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),

            // Radio buttons for ranking type selection
            Column(
              children: [
                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: const Text('Overall Top 10'),
                    leading: Radio<String>(
                      value: 'overall',
                      groupValue: controller.selectedRankingType.value,
                      onChanged: (value) {
                        controller.updateRankingType(value!);
                      },
                      activeColor: AppColors
                          .primary, // Custom color for the radio button
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Divider(),
                ),

                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: const Text('Division-wise Top 10'),
                    leading: Radio<String>(
                      value: 'division',
                      groupValue: controller.selectedRankingType.value,
                      onChanged: (value) {
                        controller.updateRankingType(value!);
                      },
                      activeColor: AppColors.primary,
                    ),
                  );
                }),
                // Conditionally render the Division dropdown based on ranking type
                Obx(() {
                  if (controller.selectedRankingType.value == 'division') {
                    return DropdownButton<String>(
                      hint: const Text("Select Division"),
                      value: controller.selectedDivision.value,
                      onChanged: (String? newValue) {
                        controller.updateFilters(division: newValue);
                      },
                      items: const [
                        DropdownMenuItem(
                            value: 'Barishal', child: Text('Barishal')),
                        DropdownMenuItem(value: 'Dhaka', child: Text('Dhaka')),
                      ],
                    );
                  } else {
                    return SizedBox.shrink(); // Empty widget if not 'division'
                  }
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Divider(),
                ),

                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: const Text('District-wise Top 10'),
                    leading: Radio<String>(
                      value: 'district',
                      groupValue: controller.selectedRankingType.value,
                      onChanged: (value) {
                        controller.updateRankingType(value!);
                      },
                      activeColor: AppColors.primary,
                    ),
                  );
                }),
                // Conditionally render the District dropdown based on ranking type
                Obx(() {
                  if (controller.selectedRankingType.value == 'district') {
                    return DropdownButton<String>(
                      hint: const Text("Select District"),
                      value: controller.selectedDistrict.value,
                      onChanged: (String? newValue) {
                        controller.updateFilters(district: newValue);
                      },
                      items: const [
                        DropdownMenuItem(
                            value: 'Barishal District',
                            child: Text('Barishal District')),
                        DropdownMenuItem(
                            value: 'Dhaka District',
                            child: Text('Dhaka District')),
                      ],
                    );
                  } else {
                    return SizedBox.shrink(); // Empty widget if not 'district'
                  }
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Divider(),
                ),

                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: const Text('Upazila-wise Top 10'),
                    leading: Radio<String>(
                      value: 'upazila',
                      groupValue: controller.selectedRankingType.value,
                      onChanged: (value) {
                        controller.updateRankingType(value!);
                      },
                      activeColor: AppColors.primary,
                    ),
                  );
                }),
                // Conditionally render the Upazila dropdown based on ranking type
                Obx(() {
                  if (controller.selectedRankingType.value == 'upazila') {
                    return DropdownButton<String>(
                      hint: const Text("Select Upazila"),
                      value: controller.selectedUpazila.value,
                      onChanged: (String? newValue) {
                        controller.updateFilters(upazila: newValue);
                      },
                      items: const [
                        DropdownMenuItem(
                            value: 'Polashpur', child: Text('Polashpur')),
                        DropdownMenuItem(
                            value: 'Magura', child: Text('Magura')),
                      ],
                    );
                  } else {
                    return SizedBox.shrink(); // Empty widget if not 'upazila'
                  }
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Divider(),
                ),

                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    title: const Text('Institute-wise Top 10'),
                    leading: Radio<String>(
                      value: 'institution',
                      groupValue: controller.selectedRankingType.value,
                      onChanged: (value) {
                        controller.updateRankingType(value!);
                      },
                      activeColor: AppColors.primary,
                    ),
                  );
                }),
                // Conditionally render the Institution dropdowns based on ranking type
                Obx(() {
                  if (controller.selectedRankingType.value == 'institution') {
                    return Column(
                      children: [
                        DropdownButton<String>(
                          hint: const Text("Select Institute Type"),
                          value: controller.selectedInstitutionType.value,
                          onChanged: (String? newValue) {
                            controller.updateFilters(institutionType: newValue);
                          },
                          items: const [
                            DropdownMenuItem(
                                value: 'University', child: Text('University')),
                            DropdownMenuItem(
                                value: 'College', child: Text('College')),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        DropdownButton<String>(
                          hint: const Text("Select Institution Name"),
                          value: controller.selectedInstitutionName.value,
                          onChanged: (String? newValue) {
                            controller.updateFilters(institutionName: newValue);
                          },
                          items: const [
                            DropdownMenuItem(
                                value: 'University of Barishal',
                                child: Text('University of Barishal')),
                            DropdownMenuItem(
                                value: 'Dhaka University',
                                child: Text('Dhaka University')),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return SizedBox
                        .shrink(); // Empty widget if not 'institution'
                  }
                }),
              ],
            ),

            // Apply Ranking button
            SizedBox(height: 30.h),
            CustomButton.button(
              mainAxisSize: MainAxisSize.min,
              text: "Apply Filter",
              fontSize: 14,
              padding: 10,
              isImageLeft: false,
              fontWeight: FontWeight.w500,
              onPressed: () {
                // Handle Apply Ranking logic here
                print("Apply Ranking Button Pressed");
              },
            ),
          ],
        ),
      ),
    );
  }
}
