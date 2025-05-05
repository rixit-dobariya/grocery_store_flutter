import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store_flutter/view/login/reset_password_view.dart';
import 'package:http/http.dart' as http;

import '../../common/app_constants.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart'; // You missed using this earlier!

class OtpVerificationView extends StatefulWidget {
  final String email;
  const OtpVerificationView({super.key, required this.email});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool canResend = false;
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 60;
    canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> resendOtp() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/users/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP resent to your email!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        startTimer();
      } else {
        Get.snackbar('Error', responseData['message'] ?? 'Something went wrong',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> verifyOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        final response = await http.post(
          Uri.parse('${AppConstants.baseUrl}/users/verify-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': widget.email, 'otp': otpController.text}),
        );
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'OTP verified successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
          Get.to(() => ResetPasswordView(email: widget.email));
        } else {
          Get.snackbar('Error', responseData['message'] ?? 'Invalid OTP',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
        }
      } catch (e) {
        Get.snackbar('Error', 'Server error',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
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
                    'assets/img/color_logo.png', // match the ForgotPasswordView
                    fit: BoxFit.contain,
                    width: media.width * 0.15,
                    height: media.width * 0.15,
                  ),
                  SizedBox(height: media.height * 0.03),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "OTP Verification",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: media.height * 0.01),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter the OTP sent to your email",
                      style: TextStyle(
                        fontSize: 16,
                        color: TColor.secondaryText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.05),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      hintText: '6-digit OTP',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'OTP is required';
                      } else if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.04),
                  isLoading
                      ? const CircularProgressIndicator()
                      : RoundButton(
                          title: "Verify OTP",
                          onPressed: verifyOtp,
                        ),
                  SizedBox(height: media.height * 0.02),
                  TextButton(
                    onPressed: canResend ? resendOtp : null,
                    child: Text(
                      canResend ? 'Resend OTP' : 'Resend OTP in $_start sec',
                      style: TextStyle(
                        color: canResend ? Colors.blue : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.02),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back to Forgot Password",
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
