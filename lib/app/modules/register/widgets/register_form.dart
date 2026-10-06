import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../controllers/register_controller.dart';
import '../models/register_model.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;

  // Reasonable email regex — RFC-perfect is a rabbit hole; this catches the
  // common typos ("name@", "name@x", "name@x.") without rejecting valid input.
  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  // Bangladeshi mobile: 11 digits, must start with 01 then 3-9.
  static final _bdPhoneRegex = RegExp(r'^01[3-9]\d{8}$');

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<RegisterController>();
    if (controller.isRegistering.value) return;

    final result = await controller.registerUser(
      RegisterRequestModel(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      ),
    );

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor:
            result.success ? const Color(0xFF1F8F4E) : const Color(0xFFC4302B),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: Duration(seconds: result.success ? 3 : 5),
        content: Row(
          children: [
            Icon(
              result.success
                  ? Icons.check_circle_rounded
                  : Icons.error_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result.success ? 'Account created' : 'Registration failed',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    result.message,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            _LabeledField(
              label: 'Full name',
              child: TextFormField(
                controller: _fullNameController,
                focusNode: _fullNameFocus,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                style: _fieldTextStyle(),
                decoration: _fieldDecoration(
                  hint: 'Enter your full name',
                  icon: Icons.person_outline_rounded,
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Full name is required';
                  if (v.length < 2) return 'Please enter your full name';
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.h),
            _LabeledField(
              label: 'Email',
              child: TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                style: _fieldTextStyle(),
                decoration: _fieldDecoration(
                  hint: 'you@example.com',
                  icon: Icons.alternate_email_rounded,
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Email is required';
                  if (!_emailRegex.hasMatch(v)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.h),
            _LabeledField(
              label: 'Phone',
              child: TextFormField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                style: _fieldTextStyle(),
                decoration: _fieldDecoration(
                  hint: '01XXXXXXXXX',
                  icon: Icons.phone_iphone_rounded,
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Phone number is required';
                  if (!_bdPhoneRegex.hasMatch(v)) {
                    return 'Enter a valid 11-digit number (e.g. 017XXXXXXXX)';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.h),
            _LabeledField(
              label: 'Password',
              helper: 'At least 6 characters',
              child: TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                onFieldSubmitted: (_) => _submit(),
                style: _fieldTextStyle(),
                decoration: _fieldDecoration(
                  hint: 'Create a password',
                  icon: Icons.lock_outline_rounded,
                ).copyWith(
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    tooltip: _isPasswordVisible
                        ? 'Hide password'
                        : 'Show password',
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.gray,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                validator: (value) {
                  final v = value ?? '';
                  if (v.isEmpty) return 'Password is required';
                  if (v.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 28.h),
            Obx(
              () {
                final busy = controller.isRegistering.value;
                return SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed: busy ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: busy
                        ? SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Create account',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _fieldTextStyle() => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryColor,
      );

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(
        color: AppColors.lightGray.withValues(alpha: 0.4),
        width: 1,
      ),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 14.sp,
        color: AppColors.lightGray,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      isDense: true,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 14.w, right: 10.w),
        child: Icon(icon, color: AppColors.gray, size: 20.sp),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: Color(0xFFC4302B), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: Color(0xFFC4302B), width: 1.4),
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 11.sp,
        color: const Color(0xFFC4302B),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String? helper;
  final Widget child;

  const _LabeledField({
    required this.label,
    required this.child,
    this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
              letterSpacing: -0.1,
            ),
          ),
        ),
        child,
        if (helper != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 4.w),
            child: Text(
              helper!,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppColors.gray,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
