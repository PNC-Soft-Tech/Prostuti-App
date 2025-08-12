import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/app_color.dart';

class BkashWebViewWidget extends StatefulWidget {
  final String paymentUrl;
  final String paymentId;
  final Function(String transactionId) onPaymentSuccess;
  final VoidCallback onPaymentFailed;
  final VoidCallback onPaymentCancelled;

  const BkashWebViewWidget({
    super.key,
    required this.paymentUrl,
    required this.paymentId,
    required this.onPaymentSuccess,
    required this.onPaymentFailed,
    required this.onPaymentCancelled,
  });

  @override
  State<BkashWebViewWidget> createState() => _BkashWebViewWidgetState();
}

class _BkashWebViewWidgetState extends State<BkashWebViewWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2136E),
        title: Text(
          'bKash Payment',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            _showCancelConfirmation();
          },
        ),
        actions: [
          if (_isLoading)
            Container(
              margin: EdgeInsets.only(right: 16.w),
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // For now, we'll simulate the bKash payment process
          // In a real implementation, you would use webview_flutter package
          _buildSimulatedPaymentView(),
          
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

  Widget _buildSimulatedPaymentView() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE2136E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFFE2136E),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.payment,
                  size: 60.sp,
                  color: const Color(0xFFE2136E),
                ),
                SizedBox(height: 16.h),
                Text(
                  'bKash Payment Gateway',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Payment ID: ${widget.paymentId}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Please complete your payment using bKash mobile app or USSD',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Payment simulation buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _simulatePaymentSuccess(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Simulate Payment Success',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _simulatePaymentFailure(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Simulate Payment Failure',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _showCancelConfirmation(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(color: Colors.grey[400]!),
                          ),
                        ),
                        child: Text(
                          'Cancel Payment',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.amber),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.amber[700],
                  size: 20.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Development Mode',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[700],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'This is a simulation. In production, this would integrate with actual bKash payment gateway.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _simulatePaymentSuccess() {
    // Generate a mock transaction ID
    final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
    
    // Show success animation/feedback
    Get.snackbar(
      'Payment Successful',
      'Transaction ID: $transactionId',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    
    // Call success callback after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); // Close this webview
      widget.onPaymentSuccess(transactionId);
    });
  }

  void _simulatePaymentFailure() {
    Get.snackbar(
      'Payment Failed',
      'Transaction could not be completed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); // Close this webview
      widget.onPaymentFailed();
    });
  }

  void _showCancelConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Cancel Payment',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this payment?',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Continue Payment',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close webview
              widget.onPaymentCancelled();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
