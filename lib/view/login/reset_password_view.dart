import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/view/login/sign_in_view.dart';
import 'package:http/http.dart' as http;

import '../../common/app_constants.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        final response = await http.post(
          Uri.parse('${AppConstants.baseUrl}/users/reset-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': widget.email,
            'newPassword': passwordController.text,
          }),
        );
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Password reset successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
          Get.offAll(() => SignInView());
        } else {
          Get.snackbar('Error', responseData['message'] ?? 'Reset failed',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      } catch (e) {
        Get.snackbar('Error', 'Server error, try again later',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: media.height * 0.1),
                  Image.asset(
                    'assets/img/color_logo.png',
                    fit: BoxFit.contain,
                    width: media.width * 0.15,
                    height: media.width * 0.15,
                  ),
                  SizedBox(height: media.height * 0.03),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter your new password below",
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.secondaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter new password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.04),
                  isLoading
                      ? const CircularProgressIndicator()
                      : RoundButton(
                          title: "Reset Password",
                          onPressed: resetPassword,
                        ),
                  SizedBox(height: media.height * 0.02),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back to OTP Verification",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
