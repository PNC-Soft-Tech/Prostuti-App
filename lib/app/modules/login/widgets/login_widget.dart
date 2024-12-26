import 'package:flutter/material.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';

class LoginWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;

  const LoginWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          TextField(
            controller: widget.emailController,
            decoration:
                CustomStyles.inputDecoration('Email', 'Enter your email')
                    .copyWith(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.email,
                  color: AppColors.blueGray,
                  size: 20,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.passwordController,
            decoration:
                CustomStyles.inputDecoration('Password', 'Enter your password')
                    .copyWith(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.lock,
                  color: AppColors.blueGray,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.blueGray,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: true, // Set to true or false based on your state
                    activeColor: AppColors.primary,
                    onChanged: (bool? newValue) {
                      // Handle the state change for the checkbox here
                    },
                  ),
                  Text(
                    "Save password",
                    style: CustomStyles.textStyle,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Handle Forgot password tap
                },
                child: Text(
                  "Forgot password?",
                  style: CustomStyles.textStyle.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onLoginPressed,
              style: CustomStyles.buttonStyle,
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
