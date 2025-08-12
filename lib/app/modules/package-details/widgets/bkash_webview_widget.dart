import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/app_color.dart';
import '../controllers/package_details_controller.dart';

class BkashWebViewWidget extends StatefulWidget {
  final String paymentUrl;
  final String paymentId;
  final PackageDetailsController controller;

  const BkashWebViewWidget({
    super.key,
    required this.paymentUrl,
    required this.paymentId,
    required this.controller,
  });

  @override
  State<BkashWebViewWidget> createState() => _BkashWebViewWidgetState();
}

class _BkashWebViewWidgetState extends State<BkashWebViewWidget> {
  bool _isLoading = true;
  bool _paymentCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bKash Payment',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFE2136E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitConfirmation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Since flutter_inappwebview is not available, we'll simulate the payment process
          _buildPaymentSimulation(),
          
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE2136E)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentSimulation() {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: Colors.grey[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/logo/bkash_payment_logo.png',
                  width: 120.w,
                  height: 40.h,
                ),
                SizedBox(height: 20.h),
                const Icon(
                  Icons.security,
                  size: 40,
                  color: Color(0xFFE2136E),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Secure Payment Gateway',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Payment ID: ${widget.paymentId}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'In a real implementation, this would open the bKash payment gateway. For demo purposes, you can simulate payment completion.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30.h),
                
                if (!_paymentCompleted) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _simulatePaymentFailure,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Simulate Failure',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _simulatePaymentSuccess,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2136E),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Simulate Success',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const Icon(
                    Icons.check_circle,
                    size: 50,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Payment Successful!',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _completePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _simulatePaymentSuccess() {
    setState(() {
      _isLoading = true;
    });

    // Simulate processing time
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _paymentCompleted = true;
      });
    });
  }

  void _simulatePaymentFailure() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Payment Failed',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'The payment could not be processed. Please try again or contact customer support.',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close webview
            },
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close webview
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _completePayment() {
    // Close webview and show success message
    Get.back();
    
    // Since this is a simulation, we'll just show a success message
    // In a real implementation, the payment would already be verified
    Get.snackbar(
      'Payment Successful',
      'Your subscription has been activated successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showExitConfirmation() {
    if (_paymentCompleted) {
      _completePayment();
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text(
          'Cancel Payment?',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this payment? Your transaction will not be completed.',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue Payment'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close webview
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
