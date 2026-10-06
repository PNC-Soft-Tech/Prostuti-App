import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/app_color.dart';
import '../custom_styles.dart';

class OTPInputWidget extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final int length;
  final double fieldWidth;
  final double fieldHeight;
  final double spacing;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final bool autoFocus;
  final bool obscureText;
  final Color? cursorColor;
  final List<String>? initialValue;
  final bool enabled;
  final bool hasError; // New: Error state
  final String? errorText; // New: Error message
  final bool enableHapticFeedback; // New: Haptic feedback option

  const OTPInputWidget({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 4,
    this.fieldWidth = 60.0,
    this.fieldHeight = 60.0,
    this.spacing = 16.0,
    this.textStyle,
    this.decoration,
    this.autoFocus = false,
    this.obscureText = false,
    this.cursorColor,
    this.initialValue,
    this.enabled = true,
    this.hasError = false, // New
    this.errorText, // New
    this.enableHapticFeedback = true, // New
  });

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _otpValues;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(
        text: widget.initialValue != null && widget.initialValue!.length > index
            ? widget.initialValue![index]
            : '',
      ),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _otpValues = List.generate(widget.length, (index) => '');

    // Auto focus on first field if enabled
    if (widget.autoFocus && _focusNodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }

    // Initialize values from controllers
    for (int i = 0; i < widget.length; i++) {
      _otpValues[i] = _controllers[i].text;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      // Handle paste operation
      if (value.length > 1) {
        _handlePaste(value, index);
        return;
      }

      // Regular single character input
      if (value.isNotEmpty && RegExp(r'^[0-9]$').hasMatch(value)) {
        _otpValues[index] = value;
        _controllers[index].text = value;

        // Provide haptic feedback when enabled
        if (widget.enableHapticFeedback) {
          HapticFeedback.lightImpact();
        }

        // Move to next field
        if (index < widget.length - 1) {
          _focusNodes[index + 1].requestFocus();
        } else {
          // Last field, remove focus
          _focusNodes[index].unfocus();
        }
      } else if (value.isEmpty) {
        _otpValues[index] = '';
        _controllers[index].text = '';
      }

      _updateCallbacks();
    });
  }

  void _handlePaste(String pastedText, int startIndex) {
    // Extract only digits from pasted text
    String digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Provide haptic feedback for paste operation
    if (widget.enableHapticFeedback && digits.isNotEmpty) {
      HapticFeedback.mediumImpact();
    }
    
    // Fill the fields starting from the current index
    for (int i = 0; i < digits.length && (startIndex + i) < widget.length; i++) {
      int fieldIndex = startIndex + i;
      _otpValues[fieldIndex] = digits[i];
      _controllers[fieldIndex].text = digits[i];
    }

    // Focus on the next empty field or last field
    int nextFocusIndex = startIndex + digits.length;
    if (nextFocusIndex < widget.length) {
      _focusNodes[nextFocusIndex].requestFocus();
    } else {
      _focusNodes[widget.length - 1].unfocus();
    }

    _updateCallbacks();
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      // Handle backspace
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Move to previous field if current is empty
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
          _otpValues[index - 1] = '';
          _updateCallbacks();
        }
      }
      // Handle arrow keys for navigation
      else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      else if (event.logicalKey == LogicalKeyboardKey.arrowRight && index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    }
  }

  void _updateCallbacks() {
    String currentOTP = _otpValues.join('');
    
    // Call onChanged callback
    if (widget.onChanged != null) {
      widget.onChanged!(currentOTP);
    }

    // Call onCompleted callback if all fields are filled
    if (currentOTP.length == widget.length) {
      // Provide haptic feedback for completion
      if (widget.enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      widget.onCompleted(currentOTP);
    }
  }

  InputDecoration _getDecoration(int index) {
    bool hasFocus = _focusNodes[index].hasFocus;
    bool hasValue = _otpValues[index].isNotEmpty;
    bool hasError = widget.hasError;
    
    return widget.decoration ??
        InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: hasError 
                  ? Colors.red
                  : hasValue 
                      ? AppColors.primary 
                      : hasFocus 
                          ? AppColors.primary
                          : AppColors.blueGray.withValues(alpha: 0.3),
              width: hasError || hasValue || hasFocus ? 2.0 : 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: hasError 
                  ? Colors.red
                  : hasValue 
                      ? AppColors.primary 
                      : AppColors.blueGray.withValues(alpha: 0.3),
              width: hasError || hasValue ? 2.0 : 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: hasError ? Colors.red : AppColors.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),          filled: true,
          fillColor: hasError
              ? Colors.red.withValues(alpha: 0.05)
              : hasValue 
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : hasFocus
                      ? AppColors.primary.withValues(alpha: 0.02)
                      : Colors.grey.withValues(alpha: 0.1),
          contentPadding: EdgeInsets.zero,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            widget.length,            (index) => SizedBox(
              width: widget.fieldWidth.w,
              height: widget.fieldHeight.h,
              child: Focus(
                onKeyEvent: (node, event) {
                  _onKeyEvent(event, index);
                  return KeyEventResult.ignored;
                },
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  style: widget.textStyle ?? 
                      CustomStyles.textStyle.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.hasError 
                            ? Colors.red 
                            : AppColors.midnightBlue,
                      ),
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  obscureText: widget.obscureText,
                  cursorColor: widget.cursorColor ?? AppColors.primary,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: _getDecoration(index),
                  onChanged: (value) => _onChanged(value, index),
                  onTap: () {
                    // Select all text when tapping on field
                    _controllers[index].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _controllers[index].text.length,
                    );
                  },
                ),
              ),
            ),
          ),
        ),        // Error message display
        if (widget.hasError && widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              widget.errorText!,
              style: CustomStyles.textStyle.copyWith(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  // Public method to clear all fields
  void clear() {
    setState(() {
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].clear();
        _otpValues[i] = '';
      }
    });
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  // Public method to get current OTP value
  String getCurrentOTP() {
    return _otpValues.join('');
  }

  // Public method to set OTP value
  void setOTP(String otp) {
    setState(() {
      for (int i = 0; i < widget.length && i < otp.length; i++) {
        _otpValues[i] = otp[i];
        _controllers[i].text = otp[i];
      }
    });
    _updateCallbacks();
  }
  // Public method to shake animation for incorrect OTP
  void shakeAnimation() {
    // This could be extended with actual shake animation
    if (widget.enableHapticFeedback) {
      HapticFeedback.vibrate();
    }
  }
}
