import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_styles.dart';
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
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: CustomStyles.inputDecoration(
                      'Full Name', 'Enter your Full Name')
                  .copyWith(
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.person,
                    color: AppColors.blueGray,
                    size: 20,
                  ),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Full Name is required'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
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
              validator: (value) => value == null || !value.contains('@')
                  ? 'Invalid email'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration:
                  CustomStyles.inputDecoration('Phone', '01XXXXXXXXX').copyWith(
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.phone,
                    color: AppColors.blueGray,
                    size: 20,
                  ),
                ),
              ),
              validator: (value) =>
                  value == null || value.length != 11 ? 'Invalid phone' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: CustomStyles.inputDecoration(
                      'Password', 'Enter your password')
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
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.blueGray,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: true,
              validator: (value) => value == null || value.length < 6
                  ? 'Password must be at least 6 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            Obx(() {
              return controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: CustomStyles.buttonStyle,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final model = RegisterRequestModel(
                              fullName: fullNameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            );
                            controller.registerUser(model);
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
