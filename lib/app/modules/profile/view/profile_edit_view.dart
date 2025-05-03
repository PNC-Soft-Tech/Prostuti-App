import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:prostuti/app/common/custom_simple_appbar.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/common/widgets/bottom_nav_bar_widget.dart';
import 'package:prostuti/app/constant/app_color.dart';
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
                  child: dropdownField(
                      labelText: 'Gender',
                      hintText: 'Select',
                      value: 'Male',
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (newValue) => print(newValue)),
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
                  child: dropdownField(
                      labelText: 'Division',
                      hintText: 'Select',
                      value: 'Barishal',
                      items: ['Barishal', 'Dhaka', 'Rangpur'],
                      onChanged: (newValue) => print(newValue)),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: dropdownField(
                      labelText: 'District',
                      hintText: 'Select',
                      value: 'Barishal',
                      items: ['Barishal', 'Patuakhali', 'Barguna'],
                      onChanged: (newValue) => print(newValue)),
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
                  child: dropdownField(
                      labelText: 'Upazilla',
                      hintText: 'Select',
                      value: 'Barishal Sadar',
                      items: ['Barishal Sadar', 'Bakerganj', 'Babuganj'],
                      onChanged: (newValue) => print(newValue)),
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
                  child: dropdownField(
                      labelText: 'Hon\'s Institution Type',
                      hintText: 'Select',
                      value: 'National',
                      items: ['National', 'Public', 'Private'],
                      onChanged: (newValue) => print(newValue)),
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
            profileTextField(
                labelText: 'Institution Name',
                hintText: 'ex: University of Dhaka, Dhaka',
                controller: controller.institutionNameController),
            SizedBox(
              height: 20.w,
            ),
          ]))),
      bottomNavigationBar:
          CustomBottomNavButton(buttonText: 'Save Details', onPressed: () {}),
    );
  }

  Column profileTextField(
      {required String labelText,
      required String hintText,
      required TextEditingController controller,
      isPhoneNumber = false}) {
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
          decoration: // !isPhoneNumber ?
              CustomStyles.profileInputDecoration(hintText),
          // : CustomStyles.profileInputDecoration(hintText).copyWith(
          //     prefixIcon: Padding(
          //       padding: const EdgeInsets.all(0),
          //       child: Image.asset(
          //         "assets/profile/flag-bd.png",
          //         height: 23,
          //       ),
          //     ),
          //   )
          validator: (value) =>
              value == null || value.isEmpty ? 'Full Name is required' : null,
        ),
      ],
    );
  }

  Column dropdownField({
    required String labelText,
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.charcoalGray,
              fontWeight: FontWeight.normal,
            ),
            labelStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.charcoalGray,
              fontWeight: FontWeight.normal,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4), // Reduced padding to make the field more compact
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                  color: AppColors.blueGray.withOpacity(0.4), width: 0.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: AppColors.primary, width: 0.5),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style: TextStyle(
                      fontSize: 14.sp, color: AppColors.charcoalGray)),
            );
          }).toList(),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.charcoalGray,
            fontWeight: FontWeight.normal,
          ),
          isDense: true, // Ensures that the input field itself is dense
        ),
      ],
    );
  }

  Widget datePickerField(
    BuildContext context, {
    required String labelText,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 12.sp, color: AppColors.gray),
        ),
        SizedBox(height: 5.w),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 12.sp),
            labelStyle: TextStyle(fontSize: 12.sp),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                color: AppColors.blueGray.withOpacity(0.4),
                width: 0.5,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: AppColors.primary, width: 0.5),
            ),
          ),
          readOnly: true,
          style: TextStyle(fontSize: 14.sp, color: AppColors.charcoalGray),
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context, // now valid
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
            }
          },
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
