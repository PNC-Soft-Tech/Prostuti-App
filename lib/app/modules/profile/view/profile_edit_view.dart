import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/app/common/custom_simple_appbar.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/common/widgets/bottom_nav_bar_widget.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/models/institution.dart';
import 'package:prostuti/app/models/institution_type.dart';
import 'package:prostuti/app/modules/profile/controllers/profile_controller.dart';
import 'package:prostuti/app/modules/profile/widgets/progress_circle.dart';

class ProfileEditView extends GetView<ProfileController> {
  const ProfileEditView({super.key});

//   @override
//   State<ProfileEditView> createState() => _ProfileEditViewState();
// }

// class _ProfileEditViewState extends State<ProfileEditView> {
  // final fullNameController = TextEditingController();
  // final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  // final dobController = TextEditingController();
  // final genderController = TextEditingController();
  // final divisionController = TextEditingController();
  // final districtController = TextEditingController();
  // final upazillaController = TextEditingController();
  // final postCodeController = TextEditingController();
  // final presentAddressController = TextEditingController();
  // final parmanentAddressController = TextEditingController();
  // final institutionTypeController = TextEditingController();
  // final cgpaController = TextEditingController();
  // final institutionNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Make sure the controller is in memory
    // (Optional) if you have an existing profile from args or API:
    // final UserProfile profile = Get.arguments as UserProfile;
    // c.loadProfile(profile);
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: 'Edit Profile'),
      backgroundColor: Colors.white,
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.h),
          child: SingleChildScrollView(
              child: Column(children: [
            const BorderedCircleAvatar(),
            SizedBox(
              height: 10.h,
            ),
            const ProgressCircle(
              progress: 0.4,
            ),
            SizedBox(
              height: 25.h,
            ),
            profileTextField(
                labelText: 'Full Name',
                hintText: 'Enter Full Name',
                controller: controller.fullNameController),
            SizedBox(
              height: 20.h,
            ),
            profileTextField(
                labelText: 'Email',
                hintText: 'Enter Email',
                controller: controller.emailController),
            SizedBox(
              height: 20.h,
            ),
            profileTextField(
                labelText: 'Phone',
                hintText: 'Enter Phone',
                controller: controller.phoneController,
                isPhoneNumber: true),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: datePickerField(context,
                      labelText: 'Date of Birth',
                      hintText: 'dd/mm/yyyy',
                      controller: controller.dobController),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: Obx(() => dropdownField<String>(
                      labelText: 'Gender',
                      hintText: 'Select',
                      value: controller.selectedGender.value,
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (newValue) => controller.selectedGender.value = newValue)),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() => dropdownField<String>(
                      labelText: 'Division',
                      hintText: 'Select',
                      value: controller.selectedDivision.value,
                      items: ['Barishal', 'Dhaka', 'Rangpur', 'Chittagong', 'Khulna', 'Sylhet', 'Rajshahi', 'Mymensingh'],
                      onChanged: (newValue) => controller.selectedDivision.value = newValue)),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: Obx(() => dropdownField<String>(
                      labelText: 'District',
                      hintText: 'Select',
                      value: controller.selectedDistrict.value,
                      items: ['Barishal', 'Patuakhali', 'Barguna', 'Dhaka', 'Gazipur'],
                      onChanged: (newValue) => controller.selectedDistrict.value = newValue)),
                ),
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() => dropdownField<String>(
                      labelText: 'Upazilla',
                      hintText: 'Select',
                      value: controller.selectedUpazilla.value,
                      items: ['Barishal Sadar', 'Bakerganj', 'Babuganj', 'Savar', 'Dhamrai'],
                      onChanged: (newValue) => controller.selectedUpazilla.value = newValue)),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: profileTextField(
                      labelText: 'Post Code',
                      hintText: 'ex: 8200',
                      controller: controller.postCodeController),
                ),
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            profileTextField(
                labelText: 'Present Address',
                hintText: 'ex: 49 Ranipukur Street, Kajipara',
                controller: controller.presentAddressController),
            SizedBox(
              height: 20.w,
            ),
            profileTextField(
                labelText: 'Parmanent Address',
                hintText: 'ex: 49 Ranipukur Street, Kajipara',
                controller: controller.permanentAddressController),
            SizedBox(
              height: 20.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() => dropdownField<InstitutionType>(
                      labelText: 'Hon\'s Institution Type',
                      hintText: 'Select',
                      value: controller.selectedInstitutionType.value,
                      items: controller.institutionTypes,
                      itemToString: (type) => type.name,
                      onChanged: (newValue) => controller.onInstitutionTypeChanged(newValue))),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: profileTextField(
                      labelText: 'Hon\'s CGPA',
                      hintText: 'ex: 3.25',
                      controller: controller.cgpaController),
                ),
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            // Institution name as a dropdown
            Obx(() => dropdownField<Institution>(
                labelText: 'Institution Name',
                hintText: 'Select Institution',
                value: controller.selectedInstitution.value,
                items: controller.institutions,
                itemToString: (institution) => institution.name,
                isLoading: controller.isLoadingInstitutions.value,
                onChanged: (newValue) => controller.onInstitutionChanged(newValue))),
            SizedBox(
              height: 20.w,
            ),
          ]))),
      bottomNavigationBar:
          CustomBottomNavButton(
            buttonText: 'Save Details', 
            onPressed: () => controller.saveProfile(),
          ),
    );
  }

  Column profileTextField(
      {required String labelText,
      required String hintText,
      required TextEditingController controller,
      bool isPhoneNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
        ),
        SizedBox(
          height: 5.w,
        ),
        TextFormField(
          controller: controller,
          style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.charcoalGray,
              fontWeight: FontWeight.normal),
          decoration: !isPhoneNumber 
              ? CustomStyles.profileInputDecoration(hintText)
              : CustomStyles.profileInputDecoration(hintText).copyWith(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/profile/flag-bd.png",
                      height: 23,
                    ),
                  ),
                ),
          validator: (value) =>
              value == null || value.isEmpty ? 'This field is required' : null,
        ),
      ],
    );
  }

  Column datePickerField(BuildContext context,
      {required String labelText,
      required String hintText,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
        ),
        SizedBox(
          height: 5.w,
        ),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
            }
          },
          child: TextFormField(
            controller: controller,
            enabled: false,
            style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.charcoalGray,
                fontWeight: FontWeight.normal),
            decoration: CustomStyles.profileInputDecoration(hintText).copyWith(
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: AppColors.gray,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column dropdownField<T>({
    required String labelText,
    required String hintText,
    required T? value,
    required List<T> items,
    String Function(T)? itemToString,
    bool isLoading = false,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
        ),
        SizedBox(
          height: 5.w,
        ),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: isLoading
              ? const Center(child: CupertinoActivityIndicator(color: AppColors.primary))
              : DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    isExpanded: true,
                    value: value,
                    hint: Text(
                      hintText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: onChanged,
                    items: items.map<DropdownMenuItem<T>>((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          itemToString != null 
                              ? itemToString(item) 
                              : item.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.charcoalGray,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }
}

class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 3.w,
          ),
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 75.w,
              backgroundColor: Colors.transparent,
              child: SvgPicture.asset(
                "assets/default-male.svg",
                width: 100.w,
                height: 100.h,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  "assets/profile/camera-gray-bg.svg",
                  width: 46.w,
                  height: 46.h,
                ))
          ],
        ),
      ),
    );
  }
}
