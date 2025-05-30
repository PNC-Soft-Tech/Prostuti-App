// ENHANCED OTP WIDGET USAGE EXAMPLES
// ==================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/common/widgets/otp_input_widget.dart';

/*
USAGE EXAMPLE 1: Basic OTP Input
================================
*/
class BasicOTPExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OTPInputWidget(
          length: 4,
          onCompleted: (otp) {
            print('OTP Completed: $otp');
            // Handle OTP completion
          },
          onChanged: (otp) {
            print('OTP Changed: $otp');
            // Handle OTP changes
          },
        ),
      ),
    );
  }
}

/*
USAGE EXAMPLE 2: OTP with Error State
=====================================
*/
class ErrorStateOTPExample extends StatefulWidget {
  @override
  _ErrorStateOTPExampleState createState() => _ErrorStateOTPExampleState();
}

class _ErrorStateOTPExampleState extends State<ErrorStateOTPExample> {
  bool hasError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OTPInputWidget(
              length: 6, // 6-digit OTP
              hasError: hasError,
              errorText: errorMessage,
              enableHapticFeedback: true,
              onCompleted: (otp) {
                // Simulate OTP verification
                if (otp == '123456') {
                  setState(() {
                    hasError = false;
                    errorMessage = '';
                  });
                  Get.snackbar('Success', 'OTP verified successfully!');
                } else {
                  setState(() {
                    hasError = true;
                    errorMessage = 'Invalid OTP. Please try again.';
                  });
                }
              },
              onChanged: (otp) {
                // Clear error when user starts typing
                if (hasError) {
                  setState(() {
                    hasError = false;
                    errorMessage = '';
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate error
                setState(() {
                  hasError = true;
                  errorMessage = 'Network error. Please try again.';
                });
              },
              child: Text('Simulate Error'),
            ),
          ],
        ),
      ),
    );
  }
}

/*
USAGE EXAMPLE 3: Customized OTP Widget
======================================
*/
class CustomizedOTPExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OTPInputWidget(
          length: 4,
          fieldWidth: 70,
          fieldHeight: 70,
          spacing: 20,
          autoFocus: true,
          cursorColor: Colors.blue,
          textStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
          onCompleted: (otp) {
            print('Custom OTP: $otp');
          },
        ),
      ),
    );
  }
}

/*
USAGE EXAMPLE 4: OTP with Controller Integration
===============================================
*/
class ControllerOTPExample extends StatelessWidget {
  final OTPController controller = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => OTPInputWidget(
          length: 4,
          hasError: controller.hasError.value,
          errorText: controller.errorMessage.value,
          enableHapticFeedback: true,
          onCompleted: controller.verifyOTP,
          onChanged: controller.onOTPChanged,
        )),
      ),
    );
  }
}

class OTPController extends GetxController {
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxString currentOTP = ''.obs;

  void onOTPChanged(String otp) {
    currentOTP.value = otp;
    // Clear error when user types
    if (hasError.value) {
      hasError.value = false;
      errorMessage.value = '';
    }
  }

  void verifyOTP(String otp) {
    // Simulate verification logic
    if (otp == '1234') {
      Get.snackbar('Success', 'OTP verified!');
    } else {
      hasError.value = true;
      errorMessage.value = 'Invalid OTP';
    }
  }
}

/*
USAGE EXAMPLE 5: OTP with Advanced Features
===========================================
*/
class AdvancedOTPExample extends StatefulWidget {
  @override
  _AdvancedOTPExampleState createState() => _AdvancedOTPExampleState();
}

class _AdvancedOTPExampleState extends State<AdvancedOTPExample> {
  final GlobalKey<State<StatefulWidget>> otpKey = GlobalKey();
  bool isVerifying = false;
  bool hasError = false;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced OTP')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter verification code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            
            // Enhanced OTP Widget
            OTPInputWidget(
              key: otpKey,
              length: 6,
              fieldWidth: 55,
              fieldHeight: 55,
              spacing: 12,
              autoFocus: true,
              hasError: hasError,
              errorText: errorText,
              enableHapticFeedback: true,
              onCompleted: _verifyOTP,
              onChanged: _onOTPChanged,
            ),
            
            SizedBox(height: 30),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearOTP,
                  child: Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: _resendOTP,
                  child: Text('Resend'),
                ),
              ],
            ),
            
            if (isVerifying) ...[
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  void _onOTPChanged(String otp) {
    if (hasError) {
      setState(() {
        hasError = false;
        errorText = '';
      });
    }
  }

  void _verifyOTP(String otp) async {
    setState(() {
      isVerifying = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isVerifying = false;
    });

    // Simulate verification result
    if (otp == '123456') {
      Get.snackbar('Success', 'OTP verified successfully!');
    } else {
      setState(() {
        hasError = true;
        errorText = 'Invalid OTP. Please try again.';
      });
      
      // Trigger shake animation if widget supports it
      // This would need proper implementation with animation controller
    }
  }

  void _clearOTP() {
    // If widget had a clear method, we could call it here
    // For now, we'll reset the error state
    setState(() {
      hasError = false;
      errorText = '';
    });
  }

  void _resendOTP() {
    Get.snackbar('Info', 'OTP resent successfully!');
    _clearOTP();
  }
}

/*
WIDGET PARAMETERS REFERENCE:
============================

Required Parameters:
- onCompleted: Function(String) - Called when all fields are filled
- length: int - Number of OTP digits (default: 4)

Optional Parameters:
- onChanged: Function(String)? - Called on every input change
- fieldWidth: double - Width of each input field (default: 60.0)
- fieldHeight: double - Height of each input field (default: 60.0)
- spacing: double - Space between fields (default: 16.0)
- textStyle: TextStyle? - Custom text style for input
- decoration: InputDecoration? - Custom decoration for fields
- autoFocus: bool - Auto-focus first field (default: false)
- obscureText: bool - Hide input text (default: false)
- cursorColor: Color? - Custom cursor color
- initialValue: List<String>? - Pre-fill values
- enabled: bool - Enable/disable input (default: true)
- hasError: bool - Error state flag (default: false)
- errorText: String? - Error message to display
- enableHapticFeedback: bool - Enable haptic feedback (default: true)

Public Methods (if accessible):
- clear() - Clear all input fields
- getCurrentOTP() - Get current OTP value
- setOTP(String) - Set OTP value programmatically
- shakeAnimation() - Trigger error shake animation
*/
