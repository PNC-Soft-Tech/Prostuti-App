import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../models/register_model.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Username'),
            validator: (value) => value == null || value.isEmpty
                ? 'Username is required'
                : null,
          ),
          TextFormField(
            controller: fnameController,
            decoration: InputDecoration(labelText: 'First Name'),
            validator: (value) => value == null || value.isEmpty
                ? 'First name is required'
                : null,
          ),
          TextFormField(
            controller: lnameController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: (value) => value == null || value.isEmpty
                ? 'Last name is required'
                : null,
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value == null || !value.contains('@') ? 'Invalid email' : null,
          ),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
            validator: (value) =>
                value == null || value.length != 10 ? 'Invalid phone' : null,
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value == null || value.length < 6
                ? 'Password must be at least 6 characters'
                : null,
          ),
          SizedBox(height: 20),
          Obx(() {
            return controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final model = RegisterRequestModel(
                          username: usernameController.text,
                          fname: fnameController.text,
                          lname: lnameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          password: passwordController.text,
                        );
                        controller.registerUser(model);
                      }
                    },
                    child: Text('Register'),
                  );
          }),
        ],
      ),
    );
  }
}
