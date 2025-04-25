import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/models/district_model.dart';
import 'package:prostuti/app/models/division_model.dart';
import 'package:prostuti/app/models/institution.dart';
import 'package:prostuti/app/models/institution_type.dart';
import 'package:prostuti/app/models/upazila_model.dart';
import 'package:prostuti/app/modules/ranking/controllers/ranking_controller.dart';
import 'package:prostuti/app/constant/app_color.dart'; // Assuming you have this constant file

class RankingFilterBottomSheet extends StatelessWidget {
  RankingFilterBottomSheet({super.key});
  final divKey = GlobalKey<DropdownSearchState>();

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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0), // not working actually
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

                Obx(() {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: DropdownSearch<Division>(
                        key: divKey,
                        selectedItem: controller.selectedDivision.value,
                        items: (filter, infiniteScrollProps) =>
                            controller.divisions,
                        itemAsString: (Division division) => division.name,
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: 'Select Division',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        compareFn: (item1, item2) =>
                            item1.name.toLowerCase() ==
                            item2.name.toLowerCase(),
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                          fit: FlexFit.tight,
                          // constraints: BoxConstraints(
                          //   maxHeight:
                          //       200, // Set the maximum height for the dropdown
                          // ),
                        ),
                        filterFn: (division, filter) {
                          if (filter.isEmpty) {
                            return true; // Return all divisions if no filter
                          }
                          return division.name.toLowerCase().contains(
                              filter.toLowerCase()); // Filter by division name
                        },
                      ),
                    );
                  } else {
                    return const SizedBox
                        .shrink(); // Empty widget if not 'division'
                  }
                }),

                Obx(() {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: DropdownSearch<District>(
                        key: divKey,
                        selectedItem: controller.selectedDistrict.value,
                        items: (filter, infiniteScrollProps) =>
                            controller.districts,
                        itemAsString: (District district) => district.name,
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: 'Select District',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        compareFn: (item1, item2) =>
                            item1.name.toLowerCase() ==
                            item2.name.toLowerCase(),
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                          fit: FlexFit.tight,
                          // constraints: BoxConstraints(
                          //   maxHeight:
                          //       200, // Set the maximum height for the dropdown
                          // ),
                        ),
                        filterFn: (district, filter) {
                          if (filter.isEmpty) {
                            return true; // Return all districts if no filter
                          }
                          return district.name.toLowerCase().contains(
                              filter.toLowerCase()); // Filter by district name
                        },
                      ),
                    );
                  } else {
                    return const SizedBox
                        .shrink(); // Empty widget if not 'district'
                  }
                }),

                Obx(() {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: DropdownSearch<Upazila>(
                        key: divKey,
                        selectedItem: controller.selectedUpazila.value,
                        items: (filter, infiniteScrollProps) =>
                            controller.upazilas,
                        itemAsString: (Upazila upazila) => upazila.name,
                        decoratorProps: const DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: 'Select Upazila',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        compareFn: (item1, item2) =>
                            item1.name.toLowerCase() ==
                            item2.name.toLowerCase(),
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                          fit: FlexFit.tight,
                          // constraints: BoxConstraints(
                          //   maxHeight:
                          //       200, // Set the maximum height for the dropdown
                          // ),
                        ),
                        filterFn: (upazila, filter) {
                          if (filter.isEmpty) {
                            return true; // Return all upazilas if no filter
                          }
                          return upazila.name.toLowerCase().contains(
                              filter.toLowerCase()); // Filter by upazila name
                        },
                      ),
                    );
                  } else {
                    return const SizedBox
                        .shrink(); // Empty widget if not 'upazila'
                  }
                }),

                Obx(() {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: DropdownSearch<InstitutionType>(
                            key: divKey,
                            selectedItem:
                                controller.selectedInstitutionType.value,
                            items: (filter, infiniteScrollProps) =>
                                controller.institutionTypes,
                            itemAsString: (InstitutionType institutionType) =>
                                institutionType.name,
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: 'Select Institution Type',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            compareFn: (item1, item2) =>
                                item1.name.toLowerCase() ==
                                item2.name.toLowerCase(),
                            popupProps: const PopupProps.dialog(
                              showSearchBox: true,
                              fit: FlexFit.tight,
                              // constraints: BoxConstraints(
                              //   maxHeight:
                              //       200, // Set the maximum height for the dropdown
                              // ),
                            ),
                            filterFn: (institutionType, filter) {
                              if (filter.isEmpty) {
                                return true; // Return all upazilas if no filter
                              }
                              return institutionType.name
                                  .toLowerCase()
                                  .contains(filter
                                      .toLowerCase()); // Filter by institutionType name
                            },
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: DropdownSearch<Institution>(
                            selectedItem: controller.institutions
                                .firstWhereOrNull((i) =>
                                    i.name ==
                                    controller.selectedInstitutionName.value),
                            items: (filter, infiniteScrollProps) =>
                                controller.institutions,
                            itemAsString: (inst) => inst.name,
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: 'Select Institution Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            compareFn: (item1, item2) =>
                                item1.name.toLowerCase() ==
                                item2.name.toLowerCase(),
                            popupProps: const PopupProps.dialog(
                              showSearchBox: true,
                              fit: FlexFit.tight,
                            ),
                            onChanged: (inst) {
                              controller.updateFilters(
                                  institutionName: inst?.name);
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox
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
              onPressed: () async {
                // Handle Apply Ranking logic here
                Get.back();
                await controller.displayLeaderboardRanks();
              },
            ),
          ],
        ),
      ),
    );
  }
}
