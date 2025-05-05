import 'package:flutter/material.dart';
import 'package:grocery_store_flutter/common/app_constants.dart';
import 'package:grocery_store_flutter/common/color_extension.dart';
import 'package:grocery_store_flutter/common_widget/round_button.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/view/login/otp_verification_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController txtEmail = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Send OTP function
  Future<void> sendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        final response = await http.post(
          Uri.parse('${AppConstants.baseUrl}/users/send-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': txtEmail.text}),
        );

        final responseData = jsonDecode(response.body);
        final responseMessage =
            responseData['message'] ?? 'No message from server';

        if (response.statusCode == 200) {
          Get.snackbar(
            'Success',
            responseMessage,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          Get.to(() => OtpVerificationView(email: txtEmail.text));
        } else {
          Get.snackbar(
            'Error',
            responseMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
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
                  SizedBox(height: media.height * 0.15),
                  Image.asset(
                    'assets/img/color_logo.png',
                    fit: BoxFit.contain,
                    width: media.width * 0.15,
                    height: media.width * 0.15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Forgot Password",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter your registered email to get OTP",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: TColor.secondaryText,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),
                  // Email TextFormField
                  TextFormField(
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.04),

                  // Send OTP Button
                  isLoading
                      ? CircularProgressIndicator()
                      : RoundButton(
                          title: "Send OTP",
                          onPressed: sendOtp,
                        ),
                  SizedBox(height: media.height * 0.02),
                  TextButton(
                    onPressed: () {
                      Get.back(); // Go back to login page
                    },
                    child: Text(
                      "Back to Login",
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
