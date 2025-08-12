import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/app_color.dart';
import '../controllers/package_details_controller.dart';
import '../models/package_model.dart';

class BkashPaymentDialog extends StatefulWidget {
  final PackageModel package;
  final PackageDetailsController controller;

  const BkashPaymentDialog({
    super.key,
    required this.package,
    required this.controller,
  });

  @override
  State<BkashPaymentDialog> createState() => _BkashPaymentDialogState();
}

class _BkashPaymentDialogState extends State<BkashPaymentDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildPackageInfo(),
                SizedBox(height: 20.h),
                _buildPhoneInput(),
                SizedBox(height: 16.h),
                _buildTermsCheckbox(),
                SizedBox(height: 20.h),
                _buildPaymentButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE2136E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            'assets/logo/bkash_payment_logo.png',
            width: 120.w,
            height: 40.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Complete Payment',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Secure payment through bKash',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPackageInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Package Details',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.package.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                'Duration: ${widget.package.period}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.payment,
                size: 16.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 8.w),
              Text(
                'Amount: ${widget.package.formattedPrice}',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'bKash Account Number',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: widget.controller.phoneController,
            decoration: InputDecoration(
              hintText: '01XXXXXXXXX',
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Text(
                  '+88',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              suffixIcon: widget.controller.phoneController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: widget.controller.clearPhone,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onChanged: (value) {
              setState(() {}); // Refresh to show/hide clear button
            },
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Enter your bKash mobile number to proceed with payment',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) {
            setState(() {
              _agreedToTerms = value ?? false;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.grey[700],
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButtons() {
    return Obx(() {
      final isProcessing = widget.controller.isPaymentProcessing.value;
      final canProceed = _agreedToTerms &&
          widget.controller.phoneController.text.length >= 11 &&
          !isProcessing;

      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: canProceed
                  ? () => widget.controller.initiateBkashPayment(widget.package)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed ? const Color(0xFFE2136E) : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: canProceed ? 2 : 0,
              ),
              child: isProcessing
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Pay ${widget.package.formattedPrice}',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: canProceed ? Colors.white : Colors.grey[600],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: TextButton(
              onPressed: isProcessing ? null : () => Get.back(),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isProcessing ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
